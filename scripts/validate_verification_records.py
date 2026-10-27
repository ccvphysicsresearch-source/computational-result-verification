import json
import sys
from pathlib import Path

from jsonschema import Draft202012Validator, FormatChecker

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = ROOT / "schemas" / "verification-record.schema.json"
RECORD_PATTERN = "papers/**/verification_record.json"


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

        if errors:
            print(f"FAIL: {record_path.relative_to(ROOT)}")
            for error in errors:
                field = ".".join(map(str, error.absolute_path)) or "(root)"
                print(f"  - {field}: {error.message}")
            total_errors += len(errors)
        else:
            print(f"PASS: {record_path.relative_to(ROOT)}")

    if total_errors:
        print(f"\nVALIDATION FAILED: {total_errors} error(s).")
        return 1

    print(f"\nVALIDATION PASSED: {len(records)} record(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
