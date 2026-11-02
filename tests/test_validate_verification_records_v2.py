import json
import shutil
import tempfile
import unittest
from pathlib import Path

from jsonschema import Draft202012Validator, FormatChecker

from scripts import validate_verification_records_v2 as validator


REPO_ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = REPO_ROOT / "schemas" / "verification-record-v2.schema.json"
RECORD_PATH = (
    REPO_ROOT / "papers" / "1977Shu" / "verification_record_v2.json"
)


class ValidateVerificationRecordsV2Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
        Draft202012Validator.check_schema(cls.schema)
        cls.schema_validator = Draft202012Validator(
            cls.schema, format_checker=FormatChecker()
        )

    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.record = json.loads(RECORD_PATH.read_text(encoding="utf-8"))
        (self.root / "evidence").mkdir()
        (self.root / "evidence" / "result.json").write_text(
            "{}", encoding="utf-8"
        )
        self.record["evidence"] = [{
            "id": "EV-TEST",
            "description": "Test output",
            "kind": "raw_output",
            "location": "evidence/result.json",
            "status": "available",
            "target_ids": ["NT-001"],
            "implementation_id": "IMPL-TAYLOR",
        }]
        target = self.record["numerical_targets"][0]
        target["evidence_ids"] = ["EV-TEST"]
        target["implementation_ids"] = ["IMPL-TAYLOR", "IMPL-RK45"]
        target["execution_ids"] = []
        target["assessment_ids"] = []
        target["reference_dataset_ids"] = []

    def tearDown(self):
        self.temp_dir.cleanup()

    def errors(self):
        return validator.validate_record(
            self.record, self.schema_validator, self.root
        )

    def test_valid_record_passes(self):
        self.assertEqual(self.errors(), [])

    def test_missing_implementation_reference_fails(self):
        self.record["numerical_targets"][0]["implementation_ids"] = [
            "IMPL-DOES-NOT-EXIST"
        ]
        errors = self.errors()
        self.assertTrue(any("IMPL-DOES-NOT-EXIST" in e for e in errors), errors)
        self.assertTrue(any("REFERENCE:" in e for e in errors), errors)

    def test_missing_evidence_reference_fails(self):
        self.record["numerical_targets"][0]["evidence_ids"] = ["EV-MISSING"]
        errors = self.errors()
        self.assertTrue(any("EV-MISSING" in e for e in errors), errors)

    def test_duplicate_target_id_fails(self):
        duplicate = dict(self.record["numerical_targets"][0])
        self.record["numerical_targets"].append(duplicate)
        errors = self.errors()
        self.assertTrue(any("duplicate identifier 'NT-001'" in e for e in errors), errors)

    def test_assessment_criterion_reference_must_exist(self):
        assessment = {
            "id": "ASSESS-1",
            "target_ids": ["NT-001"],
            "assessor": {
                "identity": "reviewer-1",
                "expertise": "Numerical methods",
            },
            "outcome": "agreement",
            "implementations_examined": ["IMPL-TAYLOR"],
            "evidence_examined": ["EV-TEST"],
            "criteria_applied": ["AC-NOT-FOUND"],
            "reasoning": "Test assessment.",
            "date": "2026-11-02",
        }
        self.record["assessments"] = [assessment]
        self.record["numerical_targets"][0]["assessment_ids"] = ["ASSESS-1"]
        errors = self.errors()
        self.assertTrue(any("AC-NOT-FOUND" in e for e in errors), errors)

    def test_derived_from_implementation_reference_must_exist(self):
        self.record["implementations"][0]["independence"]["derived_from"] = [
            "IMPL-MISSING"
        ]
        errors = self.errors()
        self.assertTrue(any("IMPL-MISSING" in e for e in errors), errors)

    def test_missing_available_evidence_file_fails(self):
        self.record["evidence"][0]["location"] = "evidence/missing.json"
        errors = self.errors()
        self.assertTrue(any("does not exist" in e for e in errors), errors)

    def test_evidence_path_traversal_fails(self):
        self.record["evidence"][0]["location"] = "../outside.json"
        errors = self.errors()
        self.assertTrue(any("escapes the repository" in e for e in errors), errors)

    def test_external_https_evidence_url_passes_path_check(self):
        self.record["evidence"][0]["location"] = "https://example.org/result.json"
        errors = validator.check_evidence_locations(self.record, self.root)
        self.assertEqual(errors, [])

    def test_invalid_schema_field_fails(self):
        self.record["unexpected"] = True
        errors = self.errors()
        self.assertTrue(any("SCHEMA:" in e and "unexpected" in e for e in errors), errors)

    def test_nonexistent_target_reference_from_evidence_fails(self):
        self.record["evidence"][0]["target_ids"] = ["NT-NOT-THERE"]
        errors = self.errors()
        self.assertTrue(any("NT-NOT-THERE" in e for e in errors), errors)


if __name__ == "__main__":
    unittest.main()
