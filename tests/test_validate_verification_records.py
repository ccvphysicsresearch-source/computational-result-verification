import contextlib
import io
import json
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from scripts import validate_verification_records as validator


REPO_ROOT = Path(__file__).resolve().parent.parent
REAL_SCHEMA = REPO_ROOT / "schemas" / "verification-record.schema.json"
REAL_RECORD = REPO_ROOT / "papers" / "1977Shu" / "verification_record.json"


class ValidateVerificationRecordsTests(unittest.TestCase):

    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.schema_path = self.root / "schema.json"
        self.records_dir = self.root / "papers" / "example"
        self.records_dir.mkdir(parents=True)
        self.record_path = self.records_dir / "verification_record.json"

        shutil.copyfile(REAL_SCHEMA, self.schema_path)
        shutil.copyfile(REAL_RECORD, self.record_path)

        self.patches = [
            patch.object(validator, "ROOT", self.root),
            patch.object(validator, "SCHEMA_PATH", self.schema_path),
        ]
        for patcher in self.patches:
            patcher.start()
            self.addCleanup(patcher.stop)

        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["evidence"] = [
            {
                "description": "Test evidence",
                "kind": "raw_output",
                "location": "test_evidence.txt",
                "status": "available",
            }
        ]

        (self.root / "test_evidence.txt").write_text(
            "Test evidence",
            encoding="utf-8",
        )

        self.record_path.write_text(
            json.dumps(record),
            encoding="utf-8",
        )


    def tearDown(self):

        self.temp_dir.cleanup()

    def run_validator(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            exit_code = validator.main()
        return exit_code, output.getvalue()
    def test_valid_record_passes(self):
        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 0)
        self.assertIn("VALIDATION PASSED: 1 record(s).", output)
        self.assertIn("PASS:", output)

    def test_archived_record_status_passes(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["record"]["status"] = "archived"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 0, output)

    def test_workflow_stage_is_invalid_record_status(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["record"]["status"] = "numerically_cross_checked"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("record.status", output)

    def test_missing_required_field_fails(self):
        record = json.loads(self.record_path.read_text(encoding="utf-8"))
        record.pop("schema_version", None)
        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("VALIDATION FAILED:", output)
        self.assertIn("schema_version", output)

    def test_invalid_scientific_verdict_fails(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["verification"]["scientific_verdict"] = "verified"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("VALIDATION FAILED:", output)
        self.assertIn("scientific_verdict", output)

    def test_invalid_evidence_status_fails(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["evidence"][0]["status"] = "probably_available"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()
        self.assertEqual(exit_code, 1)
        self.assertIn("VALIDATION FAILED:", output)
        self.assertIn("status", output)

    def test_unrecognized_top_level_field_fails(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["unrecognized_field"] = "unexpected"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("VALIDATION FAILED:", output)
        self.assertIn("unrecognized_field", output)


    def test_absolute_error_exceeding_tolerance_fails(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        result = record["methods"][0]["results"][0]
        result["absolute_error"] = 0.02
        result["tolerance"] = 0.01

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("absolute_error", output)
        self.assertIn("exceeds tolerance", output)

    def test_absolute_error_equal_to_tolerance_passes(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        result = record["methods"][0]["results"][0]
        result["absolute_error"] = 0.01
        result["tolerance"] = 0.01

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 0, output)

    def test_independent_review_without_review_details_fails(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["verification"]["workflow_stage"] = (
            "independently_reviewed"
        )

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("record.reviewers", output)
        self.assertIn("verification.review_scope", output)
        self.assertIn("verification.review_date", output)

    def test_independent_review_with_details_passes(self):
        record = json.loads(
            self.record_path.read_text(encoding="utf-8")
        )
        record["verification"]["workflow_stage"] = (
            "independently_reviewed"
        )
        record["record"]["reviewers"] = "Independent Reviewer 1"
        record["verification"]["review_scope"] = (
            "Independent review of methods and numerical evidence."
        )
        record["verification"]["review_date"] = "2026-10-29"

        self.record_path.write_text(
            json.dumps(record), encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 0, output)

    def check_evidence(self, location, status="available"):
        record = {
            "evidence": [
                {
                    "description": "Test evidence",
                    "kind": "raw_output",
                    "location": location,
                    "status": status,
                }
            ]
        }
        return validator.check_evidence_locations(record, self.root)

    def test_existing_evidence_file_passes(self):
        evidence_file = self.root / "evidence.txt"
        evidence_file.write_text("test evidence", encoding="utf-8")

        errors = self.check_evidence("evidence.txt")

        self.assertEqual(errors, [])

    def test_missing_available_evidence_fails(self):
        errors = self.check_evidence("missing.txt")

        self.assertEqual(len(errors), 1)
        self.assertIn("does not exist", errors[0])

    def test_external_https_url_passes(self):
        errors = self.check_evidence(
            "https://doi.org/10.1086/155274"
        )

        self.assertEqual(errors, [])

    def test_path_traversal_fails(self):
        errors = self.check_evidence("../outside.txt")

        self.assertEqual(len(errors), 1)
        self.assertIn("escapes the repository", errors[0])

    def test_non_available_evidence_does_not_require_file(self):
        for status in (
            "not_yet_confirmed",
            "unavailable",
            "not_applicable",
        ):
            with self.subTest(status=status):
                errors = self.check_evidence(
                    "missing.txt",
                    status=status,
                )
                self.assertEqual(errors, [])


    def test_malformed_json_fails(self):
        self.record_path.write_text(
            '{"id": invalid json}', encoding="utf-8"
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("FAIL:", output)
        self.assertIn("VALIDATION FAILED:", output)

    def test_no_records_fails(self):
        self.record_path.unlink()

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("No records found", output)

    def test_invalid_schema_fails(self):
        self.schema_path.write_text(
            '{"type": "not-a-valid-schema-type"}',
            encoding="utf-8",
        )

        exit_code, output = self.run_validator()

        self.assertEqual(exit_code, 1)
        self.assertIn("Schema is invalid or unreadable", output)


if __name__ == "__main__":
    unittest.main()

