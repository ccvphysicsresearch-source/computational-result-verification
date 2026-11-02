"""Validate Computational Verification Record v2.0 files.

Checks JSON Schema conformance, cross-reference integrity, unique identifiers,
and the existence/safety of local evidence paths.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from urllib.parse import urlparse

from jsonschema import Draft202012Validator, FormatChecker

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = ROOT / "schemas" / "verification-record-v2.schema.json"
RECORD_PATTERN = "papers/**/verification_record_v2.json"


COLLECTIONS = {
    "numerical_targets": "numerical_targets",
    "reference_datasets": "reference_datasets",
    "implementations": "implementations",
    "executions": "executions",
    "evidence": "evidence",
    "assessments": "assessments",
}


def _items(record, collection):
    value = record.get(collection, [])
    return value if isinstance(value, list) else []


def check_unique_ids(record):
    """Check uniqueness of IDs in each record-level collection.

    Acceptance-criterion IDs are checked globally across the record so that
    assessment references are unambiguous.
    """
    errors = []
    for collection, label in COLLECTIONS.items():
        seen = set()
        for index, item in enumerate(_items(record, collection)):
            if not isinstance(item, dict):
                continue
            identifier = item.get("id")
            if not isinstance(identifier, str) or not identifier:
                continue  # JSON Schema reports missing/invalid IDs.
            if identifier in seen:
                errors.append(
                    f"{collection}[{index}].id: duplicate identifier {identifier!r}"
                )
            else:
                seen.add(identifier)

    criteria_seen = set()
    for target_index, target in enumerate(_items(record, "numerical_targets")):
        if not isinstance(target, dict):
            continue
        for criterion_index, criterion in enumerate(target.get("acceptance_criteria", [])):
            if not isinstance(criterion, dict):
                continue
            identifier = criterion.get("id")
            if not isinstance(identifier, str) or not identifier:
                continue
            if identifier in criteria_seen:
                errors.append(
                    "numerical_targets"
                    f"[{target_index}].acceptance_criteria[{criterion_index}].id: "
                    f"duplicate identifier {identifier!r}"
                )
            else:
                criteria_seen.add(identifier)
    return errors


def check_references(record):
    """Ensure every ID reference points to an existing object in this record."""
    errors = []
    ids = {}
    for collection in COLLECTIONS:
        ids[collection] = {
            item.get("id")
            for item in _items(record, collection)
            if isinstance(item, dict) and isinstance(item.get("id"), str)
        }

    criterion_ids = set()
    for target in _items(record, "numerical_targets"):
        if isinstance(target, dict):
            for criterion in target.get("acceptance_criteria", []):
                if isinstance(criterion, dict) and isinstance(criterion.get("id"), str):
                    criterion_ids.add(criterion["id"])

    def check_one(value, destination, field):
        if not isinstance(value, str) or value not in ids[destination]:
            errors.append(
                f"{field}: reference {value!r} does not match an existing "
                f"{destination} ID"
            )

    def check_many(values, destination, field):
        if not isinstance(values, list):
            return  # JSON Schema reports the wrong type.
        for index, value in enumerate(values):
            check_one(value, destination, f"{field}[{index}]")

    # Numerical Target -> other record objects.
    for i, target in enumerate(_items(record, "numerical_targets")):
        if not isinstance(target, dict):
            continue
        for field, destination in (
            ("reference_dataset_ids", "reference_datasets"),
            ("implementation_ids", "implementations"),
            ("execution_ids", "executions"),
            ("evidence_ids", "evidence"),
            ("assessment_ids", "assessments"),
        ):
            if field in target:
                check_many(target[field], destination, f"numerical_targets[{i}].{field}")

    # Reference Dataset -> Numerical Targets.
    for i, dataset in enumerate(_items(record, "reference_datasets")):
        if isinstance(dataset, dict) and "target_ids" in dataset:
            check_many(dataset["target_ids"], "numerical_targets",
                       f"reference_datasets[{i}].target_ids")

    # Implementation -> targets and other implementations.
    for i, implementation in enumerate(_items(record, "implementations")):
        if not isinstance(implementation, dict):
            continue
        if "target_ids" in implementation:
            check_many(implementation["target_ids"], "numerical_targets",
                       f"implementations[{i}].target_ids")
        independence = implementation.get("independence", {})
        if isinstance(independence, dict) and "derived_from" in independence:
            check_many(independence["derived_from"], "implementations",
                       f"implementations[{i}].independence.derived_from")

    # Execution -> implementation, targets, and evidence.
    for i, execution in enumerate(_items(record, "executions")):
        if not isinstance(execution, dict):
            continue
        if "implementation_id" in execution:
            check_one(execution["implementation_id"], "implementations",
                      f"executions[{i}].implementation_id")
        if "target_ids" in execution:
            check_many(execution["target_ids"], "numerical_targets",
                       f"executions[{i}].target_ids")
        if "evidence_ids" in execution:
            check_many(execution["evidence_ids"], "evidence",
                       f"executions[{i}].evidence_ids")

    # Evidence -> targets, execution, dataset, assessment, implementation.
    for i, evidence in enumerate(_items(record, "evidence")):
        if not isinstance(evidence, dict):
            continue
        for field, destination in (
            ("target_ids", "numerical_targets"),
            ("execution_id", "executions"),
            ("reference_dataset_id", "reference_datasets"),
            ("assessment_id", "assessments"),
            ("implementation_id", "implementations"),
        ):
            if field not in evidence:
                continue
            if field == "target_ids":
                check_many(evidence[field], destination, f"evidence[{i}].{field}")
            else:
                check_one(evidence[field], destination, f"evidence[{i}].{field}")

    # Assessment -> targets, implementations, evidence, and criteria.
    for i, assessment in enumerate(_items(record, "assessments")):
        if not isinstance(assessment, dict):
            continue
        for field, destination in (
            ("target_ids", "numerical_targets"),
            ("implementations_examined", "implementations"),
            ("evidence_examined", "evidence"),
        ):
            if field in assessment:
                check_many(assessment[field], destination, f"assessments[{i}].{field}")
        if "criteria_applied" in assessment:
            values = assessment["criteria_applied"]
            if isinstance(values, list):
                for j, value in enumerate(values):
                    if not isinstance(value, str) or value not in criterion_ids:
                        errors.append(
                            f"assessments[{i}].criteria_applied[{j}]: "
                            f"reference {value!r} does not match an existing "
                            "acceptance-criterion ID"
                        )
    return errors


def check_evidence_locations(record, root=None):
    """Check available local evidence files and reject unsafe paths."""
    root = Path(root if root is not None else ROOT).resolve()
    errors = []
    for index, item in enumerate(_items(record, "evidence")):
        if not isinstance(item, dict) or item.get("status") != "available":
            continue
        location = item.get("location")
        if not isinstance(location, str) or not location.strip():
            errors.append(
                f"evidence[{index}].location: available evidence requires "
                "a non-empty string location"
            )
            continue

        location = location.strip()
        parsed = urlparse(location)
        if parsed.scheme.lower() in ("http", "https"):
            if not parsed.netloc:
                errors.append(f"evidence[{index}].location: invalid URL ({location})")
            continue
        if parsed.scheme:
            errors.append(
                f"evidence[{index}].location: unsupported URL scheme ({location})"
            )
            continue

        relative_path = Path(location)
        if relative_path.is_absolute() or relative_path.drive:
            errors.append(
                f"evidence[{index}].location: absolute paths are not allowed "
                f"({location})"
            )
            continue
        try:
            full_path = (root / relative_path).resolve()
            full_path.relative_to(root)
        except (OSError, ValueError, RuntimeError):
            errors.append(
                f"evidence[{index}].location: path escapes the repository "
                f"or cannot be resolved ({location})"
            )
            continue
        if not full_path.is_file():
            errors.append(
                f"evidence[{index}].location: available evidence file "
                f"does not exist ({location})"
            )
    return errors


def validate_record(record, validator, root=None):
    """Return schema, identifier, reference, and evidence-path errors."""
    schema_errors = sorted(
        validator.iter_errors(record),
        key=lambda error: list(map(str, error.absolute_path)),
    )
    errors = []
    for error in schema_errors:
        field = ".".join(map(str, error.absolute_path)) or "(root)"
        errors.append(f"SCHEMA: {field}: {error.message}")
    errors.extend(f"ID: {message}" for message in check_unique_ids(record))
    errors.extend(f"REFERENCE: {message}" for message in check_references(record))
    errors.extend(f"EVIDENCE: {message}" for message in check_evidence_locations(record, root))
    return errors


def main():
    if not SCHEMA_PATH.is_file():
        print(f"ERROR: Schema not found: {SCHEMA_PATH}")
        return 1
    try:
        schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8-sig"))
        Draft202012Validator.check_schema(schema)
    except Exception as exc:
        print(f"ERROR: Schema is invalid or unreadable: {exc}")
        return 1

    record_paths = sorted(ROOT.glob(RECORD_PATTERN))
    if not record_paths:
        print(f"ERROR: No v2 records found matching {RECORD_PATTERN}")
        return 1

    validator = Draft202012Validator(schema, format_checker=FormatChecker())
    total_errors = 0
    for record_path in record_paths:
        try:
            record = json.loads(record_path.read_text(encoding="utf-8-sig"))
        except (OSError, json.JSONDecodeError) as exc:
            print(f"FAIL: {record_path.relative_to(ROOT)}: {exc}")
            total_errors += 1
            continue

        errors = validate_record(record, validator, ROOT)
        if errors:
            print(f"FAIL: {record_path.relative_to(ROOT)}")
            for message in errors:
                print(f"  - {message}")
            total_errors += len(errors)
        else:
            print(f"PASS: {record_path.relative_to(ROOT)}")

    if total_errors:
        print(f"\nVALIDATION FAILED: {total_errors} error(s).")
        return 1
    print(f"\nVALIDATION PASSED: {len(record_paths)} v2 record(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
