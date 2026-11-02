# Validation Guide

This guide explains how contributors and maintainers can check the structure and internal consistency of computational verification records.

The goal is to make validation predictable and approachable: contributors should know what to run, what a result means, and how to correct a problem without having to guess.

> **Important:** A passing validator confirms that a record meets the checks implemented by the validator. It does not execute the scientific code, reproduce the published result, or establish scientific correctness. Scientific assessment follows the [Verification Protocol](protocol.md).

## 1. What is validated?

The repository currently supports two record formats:

| Version | Record file pattern | Validator |
|---|---|---|
| v1 | `papers/**/verification_record.json` | `scripts/validate_verification_records.py` |
| v2 | `papers/**/verification_record_v2.json` | `scripts/validate_verification_records_v2.py` |

The v1 validator checks JSON Schema conformance, selected record-consistency rules, and evidence locations.

The v2 validator checks JSON Schema conformance, unique identifiers, cross-references between record objects, and evidence locations. It also checks that the v2 schema itself is valid.

Both validators check that evidence marked as available points to an existing repository file or a valid HTTP(S) URL. Local evidence paths must remain within the repository.

## 2. Set up the environment

Run commands from the repository root (the directory containing `scripts`, `schemas`, `tests`, and `papers`).

You need Python and the `jsonschema` package. On Windows PowerShell:

```powershell
py --version
py -m pip install jsonschema
```

On macOS or Linux, the equivalent commands are commonly:

```bash
python3 --version
python3 -m pip install jsonschema
```

If your environment uses a virtual environment, activate it before installing the package and running the commands.

## 3. Validate records

### Validate v1 records

Windows PowerShell:

```powershell
py scripts/validate_verification_records.py
```

macOS/Linux:

```bash
python3 scripts/validate_verification_records.py
```

### Validate v2 records

Windows PowerShell:

```powershell
py scripts/validate_verification_records_v2.py
```

macOS/Linux:

```bash
python3 scripts/validate_verification_records_v2.py
```

A successful run reports each record as `PASS` and ends with `VALIDATION PASSED`. A failed run reports the record and the detected errors, then ends with `VALIDATION FAILED`.

Each validator searches for its corresponding record filename under `papers/`. If no matching records are found, it reports an error rather than silently succeeding.

## 4. Run the automated tests

Tests check both valid examples and deliberately invalid records. They help ensure that important errors are detected.

Use test discovery from the repository root.

### v1 tests

```powershell
py -m unittest discover -s tests -p "test_validate_verification_records.py" -v
```

### v2 tests

```powershell
py -m unittest discover -s tests -p "test_validate_verification_records_v2.py" -v
```

### Run both suites

```powershell
py -m unittest discover -s tests -p "test_validate_verification_records*.py" -v
```

On macOS/Linux, replace `py` with `python3`.

Test discovery is intentional: it runs the test files from the `tests` directory without requiring that directory to be imported as a Python package.

## 5. Understand the results

### Validator output

- **PASS** — the record passed the checks implemented by that validator.
- **FAIL** — one or more checks failed. Read the messages printed below the record name.
- **VALIDATION PASSED** — all records found by that validator passed.
- **VALIDATION FAILED** — at least one record or check failed.

### Test output

- **ok** — the test passed.
- **FAIL** — the test ran but its expected behavior was not met.
- **ERROR** — the test could not complete, often because of an unexpected exception or environment problem.
- **Ran N tests ... OK** — all tests in that test run passed.

A test suite passing means the tested validator behavior is working for those cases. It does not mean every possible malformed record or scientific issue has been tested.

## 6. Common problems

### Python cannot find the validator script

Check that you are in the repository root:

```powershell
Get-Location
Test-Path .\scripts\validate_verification_records_v2.py
```

The second command should return `True` for the v2 validator. If it returns `False`, check that the repository is up to date and that you are in the intended working copy. Do not delete or overwrite local research files to resolve this.

### Python reports that `jsonschema` is missing

Install it into the same Python environment used to run the validator:

```powershell
py -m pip install jsonschema
py -m pip show jsonschema
```

If you use a virtual environment, make sure it is activated in the current terminal.

### A test import fails

Use the test-discovery commands in Section 4. In particular, prefer:

```powershell
py -m unittest discover -s tests -p "test_validate_verification_records_v2.py" -v
```

This avoids relying on `tests` being an importable package.

### A schema error is reported

Read the field path and message. Check the corresponding record against the version-specific schema and template:

- [v1 schema](../schemas/verification-record.schema.json)
- [v2 schema](../schemas/verification-record-v2.schema.json)
- [v2 human-readable template](../VERIFICATION_RECORD_TEMPLATE_V2.md)

Do not remove a required field merely to silence an error. If the information is genuinely unavailable, use the missing-information status supported by that record version.

### A cross-reference error is reported in v2

Check that every referenced ID exists in the appropriate collection and is spelled exactly the same way. Also check for duplicate IDs. For example, an execution's `implementation_id` must refer to an implementation in the same record.

### An evidence-path error is reported

For evidence marked `available`, check that:

- The path is repository-relative, not an absolute path.
- The file exists in the working tree.
- The path does not escape the repository.
- An external link uses a valid HTTP(S) URL.

If evidence is not yet available, do not label it as available. Record its actual status and explain what remains to be supplied.

## 7. A contributor-friendly workflow

For a new or updated record, the recommended sequence is:

1. Read the relevant [contribution guidance](contribute.md) and [Verification Protocol](protocol.md).
2. Choose the record version and use its matching schema and template.
3. Fill in what is known; identify unknown or unreported information explicitly rather than guessing.
4. Add code, execution details, outputs, and evidence references as they become available.
5. Run the matching validator.
6. Correct errors one at a time, preserving meaningful scientific evidence and failed attempts.
7. Run the matching automated test suite if you changed validator code, schema behavior, or tests.
8. Include the commands run and their outcomes when submitting the change for review.

You do not need to claim that a result is fully reproduced in order to contribute. A carefully documented partial result, failed run, discrepancy, or unresolved question can be valuable.

## 8. Contributor experience principles

Validation should help contributors improve a submission, not make them feel that a failed check invalidates their scientific work.

The project should aim for the following:

- **Clear next steps:** every error should identify the affected record or field and, where possible, how to investigate it.
- **No silent assumptions:** missing information should be represented explicitly, not guessed.
- **Preserve work:** a failed run should not require deleting useful outputs, diagnostics, or earlier attempts.
- **Explain the boundary:** structural validation, execution checks, numerical comparison, and scientific review are different activities.
- **Support gradual contribution:** contributors should be able to document partial progress and limitations honestly.
- **Respectful review:** feedback should be specific, evidence-based, and constructive.
- **Predictable instructions:** commands should be copyable, version-specific, and tested on the documented environment.
- **Accessible participation:** institutional affiliation or advanced software expertise should not be prerequisites for asking questions or making a useful, well-documented contribution.

These principles are product goals as well as documentation goals. As the platform develops, contributor feedback should be used to identify confusing instructions, recurring setup failures, unclear error messages, and unnecessary submission friction.

## 9. What validation does not do

A passing record validator does not establish that:

- The implementation correctly represents the governing equations.
- The numerical method is stable, convergent, or sufficiently accurate.
- The code was actually executed as described.
- Two implementations are scientifically independent.
- A computed value agrees with the original publication.
- The publication's broader scientific conclusions are correct.

Those questions require appropriate numerical experiments, evidence, and scientific assessment under the [Verification Protocol](protocol.md).

## 10. Reporting a problem with validation

If a command fails unexpectedly or an error message is unclear, please include:

- Operating system and Python version.
- The exact command you ran.
- The complete error output (remove private information first).
- Whether the issue occurs with an existing record or only your new record.
- Any relevant schema, validator, or test changes.

Do not include passwords, access tokens, private datasets, or other sensitive information in an issue or public discussion.

Constructive reports about confusing instructions or difficult setup are welcome. Improving the contributor experience is part of improving the platform.
