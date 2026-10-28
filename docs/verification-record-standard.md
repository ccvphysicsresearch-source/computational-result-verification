# Computational Verification Record Standard

Version: 1.0 (draft)
Status: Proposed
Purpose: Define the minimum information and evidence needed to document
computational verification of scientific results.

## 1\. Core principles

Every record must make clear:

1. What scientific result is being checked.
2. What the publication reports and what information is missing.
3. How the result was recomputed.
4. What evidence supports the computation and comparison.
5. How closely the results agree and how agreement was assessed.
6. What conclusions are justified and what remains unverified.

A successful computation is not automatically a numerical reproduction.
Numerical agreement is not automatically independent verification.
Independent review is not a guarantee that a scientific conclusion is true.

## 2\. Minimum record fields

### 2.1 Record identity

* Stable record identifier.
* Record version.
* Creation and update dates.
* Contributor identities and roles, when known.
* Record status, using a value permitted by the schema:
  `draft`, `submitted`, `execution_checked`,
  `numerically_cross_checked`, or `independently_reviewed`.

### 2.2 Publication

* Title, authors, publication year, and venue.
* DOI or another persistent identifier, when available.
* Publication URL.
* Links to published code, data, supplements, or other relevant material,
or an explicit status explaining that they are unknown or unavailable.

### 2.3 Target result

* A precise description of the result or claim being checked.
* Relevant equation, figure, table, section, or page in the publication.
* Parameter values, units, domain, and boundary or initial conditions,
where applicable.
* The scope of the verification and any explicit exclusions.

### 2.4 Reference result

* Published value, reference data, expected behavior, or other comparison basis.
* Source location and units.
* Reported precision, rounding, and known limitations.
* A clear distinction between a published rounded value and a high-precision
numerical benchmark.

If no suitable reference is available, explain that limitation explicitly.

### 2.5 Methods and implementation

For each method, document as applicable:

* Method name and role.
* Source-code location and code revision.
* Algorithm, equations, and relevant assumptions.
* Input data and initial or boundary conditions.
* Parameters, solver settings, stopping criteria, and tolerances.
* Software, runtime, libraries, and relevant dependencies.
* Execution instructions and expected outputs.
* Relationship to other methods, including shared equations, data,
assumptions, and implementation components.

### 2.6 Execution evidence

Record whether the computation was run and whether it completed.
Where available, provide:

* Execution commands and environment information.
* Logs and raw outputs.
* Test results and exit status.
* Generated artifacts and their locations.
* Errors, warnings, failed runs, or deviations from the documented procedure.

A passing execution test establishes only what that test actually checks.

### 2.7 Quantitative comparison

Document:

* Which quantities, profiles, datasets, or behaviors were compared.
* The comparison procedure and any interpolation or preprocessing.
* The numerical values being compared.
* Error metrics, units, and acceptance tolerances.
* How the tolerances were selected or justified.
* The observed differences and any sensitivity or convergence checks.
* Whether the comparison covers the full target or only part of it.

Distinguish absolute error, relative error, convergence evidence, and
qualitative agreement. Do not compare quantities that have different
definitions or domains without explaining the relationship.

### 2.8 Evidence and provenance

Link relevant evidence, such as:

* Source code.
* Input and reference data.
* Raw outputs and execution logs.
* Comparison scripts and tests.
* Reports, figures, and tables.
* Code revisions and external persistent identifiers.

State whether evidence is committed, externally archived, generated locally,
or not yet available. Do not imply that a local uncommitted file is part of
a published code revision.

### 2.9 Limitations and discrepancies

Document relevant missing information, assumptions, numerical sensitivity,
unresolved differences, unavailable artifacts, and limits on interpretation.
Explain whether methods share assumptions or possible sources of error.

### 2.10 Verdict and review

Provide a justified scientific verdict and the current workflow stage.
If independent review has occurred, record the review scope, date, reviewer
identity or attribution policy, findings, and unresolved issues.

## 3. Missing information

Do not guess or silently omit material information.

The information fields support the statuses:
- `unknown`
- `not_reported`
- `not_applicable`
- `not_yet_confirmed`

Evidence items have their own status vocabulary:
- `available`
- `not_yet_confirmed`
- `unavailable`
- `not_applicable`

Use only statuses permitted for the relevant field. Do not assume that a
status supported in one part of the schema is accepted everywhere. Missing
information must not be represented as evidence that a claim is false or
that a test failed.

## 4\. Workflow stages

The workflow stage describes the checks documented so far:

* submitted: the record has been submitted but may not yet have been checked.
* execution\_checked: execution evidence has been checked for the stated scope.
* numerically\_cross\_checked: quantitative comparisons between specified
methods or references have been performed and documented.
* independently\_reviewed: an independent review has been completed and
its scope and findings have been recorded.

A workflow stage does not by itself establish the scientific verdict.

## 5\. Scientific verdicts

Use the verdict values supported by the current schema:

* reproduced\_within\_stated\_tolerances
* partial\_numerical\_reproduction
* inconsistent\_with\_reference
* inconclusive

The justification must explain why the evidence supports the selected verdict.
Do not claim complete reproduction when only a subset of results was checked.
An inconsistency should identify the conflicting quantities and comparison
conditions. Use inconclusive when the available evidence cannot support
a stronger conclusion.

## 6\. Methodological independence

Different numerical algorithms do not necessarily constitute independent
scientific verification. Records must disclose material shared dependencies,
including governing equations, input data, initial conditions, assumptions,
reference values, and code components.

Agreement between methods that share these elements can provide useful
numerical cross-checking, but it does not by itself establish that the shared
formulation or scientific model is correct.

## 7\. Tolerances and reproducibility

Tolerances must be stated with the comparison they govern and should be
justified by the scientific context, numerical precision, or a documented
acceptance criterion. Do not select tolerances after seeing the result
without disclosing that choice.

Execution instructions should be sufficient for another person to attempt
the computation. Record important environment details and dependencies.
Exact bitwise reproducibility is not always possible or necessary, but any
expected numerical variability should be described.

## 8\. Minimum submission checklist

Before submission, confirm that:

* The target result and reference source are identified.
* Missing publication or method details are explicitly documented.
* The implementation and relevant settings are described.
* Execution evidence is linked or its absence is stated.
* Comparisons include values, metrics, units, and tolerances where applicable.
* Evidence locations and code provenance are traceable.
* Shared assumptions and methodological limitations are disclosed.
* The verdict and workflow stage accurately reflect the evidence.

A schema-valid record may still contain incomplete scientific evidence.
Automated validation checks record structure; it does not prove scientific
correctness. Numerical cross-checking and independent review require
additional evidence beyond schema validity.

## 9\. Relationship to the repository schema

This document states the proposed policy for verification records.
The JSON Schema and automated tests define which structures and values
are mechanically accepted by the current implementation.

The policy and schema should be reviewed together. If they disagree, do not
silently assume that the schema enforces a policy requirement. Document the
gap and decide whether to update the schema, the policy, or both.

The schema requires the top-level record sections and specified identity,
publication, target, verification, and provenance fields. Other policy
requirements may require human review unless explicitly enforced by the
schema or automated tests.

## 10\. Versioning and changes

This is a draft standard. Changes to required fields, status definitions,
workflow stages, or verdict meanings should be documented and reviewed.
Schema changes should include corresponding validation tests and example
records to avoid breaking existing records without a deliberate migration.
