import json
import sys


from pathlib import Path

from jsonschema import Draft202012Validator, FormatChecker

from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = ROOT / "schemas" / "verification-record.schema.json"
RECORD_PATTERN = "papers/**/verification_record.json"

def check_evidence_locations(record, root=None):
    """Check that available local evidence points to files inside the repository."""
    root = Path(root if root is not None else ROOT).resolve()
    errors = []

    for index, item in enumerate(record.get("evidence", [])):
        location = item.get("location")
        status = item.get("status")

        if status != "available":
            continue

        if not isinstance(location, str) or not location.strip():
            errors.append(
                f"evidence[{index}].location: "
                "available evidence requires a non-empty location"
            )
            continue

        location = location.strip()
        parsed = urlparse(location)

        # External HTTP(S) evidence is not a local repository file.
        if parsed.scheme.lower() in ("http", "https"):
            if not parsed.netloc:
                errors.append(
                    f"evidence[{index}].location: invalid external URL "
                    f"({location})"
                )
            continue

        # Reject URLs using unsupported schemes.
        if parsed.scheme:
            errors.append(
                f"evidence[{index}].location: unsupported URL scheme "
                f"({location})"
            )
            continue

        # Accept repository-relative paths only.
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
def check_record_consistency(record):
    """Return semantic consistency errors not covered by JSON Schema."""
    errors = []

    # A reported absolute error must not exceed its stated tolerance.
    for method_index, method in enumerate(record.get("methods", [])):
        for result_index, result in enumerate(method.get("results", [])):
            error = result.get("absolute_error")
            tolerance = result.get("tolerance")

            if (
                isinstance(error, (int, float))
                and not isinstance(error, bool)
                and isinstance(tolerance, (int, float))
                and not isinstance(tolerance, bool)
                and error > tolerance
            ):
                errors.append(
                    f"methods[{method_index}].results[{result_index}]: "
                    f"absolute_error ({error}) exceeds tolerance ({tolerance})"
                )

    # An independently reviewed record must document its reviewer and review.
    verification = record.get("verification", {})

    if verification.get("workflow_stage") == "independently_reviewed":
        reviewers = record.get("record", {}).get("reviewers")
        review_scope = verification.get("review_scope")
        review_date = verification.get("review_date")

        if not isinstance(reviewers, str) or not reviewers.strip():
            errors.append(
                "record.reviewers: independent review requires a documented reviewer identity"
            )

        if not isinstance(review_scope, str) or not review_scope.strip():
            errors.append(
                "verification.review_scope: independent review requires a documented review scope"
            )

        if not isinstance(review_date, str) or not review_date.strip():
            errors.append(
                "verification.review_date: independent review requires a documented review date"
            )

    return errors


def main():
    if not SCHEMA_PATH.is_file():
        print(f"ERROR: Schema not found: {SCHEMA_PATH}")
        return 1

    try:
        schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(schema)
    except Exception as exc:
        print(f"ERROR: Schema is invalid or unreadable: {exc}")
        return 1

    records = sorted(ROOT.glob(RECORD_PATTERN))
    if not records:
        print(f"ERROR: No records found matching {RECORD_PATTERN}")
        return 1

    validator = Draft202012Validator(
        schema,
        format_checker=FormatChecker(),
    )
    total_errors = 0

    for record_path in records:
        try:
            record = json.loads(record_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            print(f"FAIL: {record_path.relative_to(ROOT)}: {exc}")
            total_errors += 1
            continue
        errors = sorted(
            validator.iter_errors(record),
            key=lambda error: list(map(str, error.absolute_path)),
        )

        consistency_errors = check_record_consistency(record)
        evidence_errors = check_evidence_locations(record, ROOT)
        if errors or consistency_errors or evidence_errors:
            print(f"FAIL: {record_path.relative_to(ROOT)}")

            for error in errors:
                field = ".".join(map(str, error.absolute_path)) or "(root)"
                print(f"  - {field}: {error.message}")

            for message in consistency_errors:
                print(f"  - CONSISTENCY: {message}")
            for message in evidence_errors:
                print(f"  - EVIDENCE: {message}")
            total_errors += (
    len(errors)
    + len(consistency_errors)
    + len(evidence_errors)
)
        else:
            print(f"PASS: {record_path.relative_to(ROOT)}")
    if total_errors:
        print(f"\nVALIDATION FAILED: {total_errors} error(s).")
        return 1

    print(f"\nVALIDATION PASSED: {len(records)} record(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
