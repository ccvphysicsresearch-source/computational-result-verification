# Computational Verification Record — Template v2.0

**Schema:** `schemas/verification-record-v2.schema.json`  
**Model:** One record represents one Computational Result and contains one or more independently traceable Numerical Targets.

> This template is a human-readable guide to a v2.0 JSON record. The JSON Schema is the structural authority. Keep IDs stable across revisions; do not use titles as identifiers.

## Completion and missing-information policy

Provide documented information or an explicit status. Do not silently leave essential information blank.

Use these status objects where a value is unavailable or inapplicable:

- `{"status": "unknown", "note": "..." }` — relevant information could not be established.
- `{"status": "not_reported", "note": "..." }` — the cited source does not report it.
- `{"status": "not_applicable", "note": "..." }` — the field genuinely does not apply.
- `{"status": "not_yet_confirmed", "note": "..." }` — confirmation is pending.

These statuses are distinct. Do not use `not_applicable` merely because information is missing. A draft may be incomplete, but unresolved essential evidence must remain visible.

---

## 1. Record identity and lifecycle

- **Record ID:** `[stable record identifier]`
- **Record version:** `1.0`
- **Lifecycle status:** `draft | published | superseded | withdrawn | archived`
- **Technical workflow stage:** `submitted | execution_checked | numerically_cross_checked | independently_reviewed`
- **Created:** `YYYY-MM-DD`
- **Last updated:** `YYYY-MM-DD`
- **Contributors:** platform identity, display name/status, role, optional affiliation.
- **Revision history:** version, date, revision class (`major | moderate | minor`), description, reason, and exact commit where known.
- **Withdrawal reason:** if applicable.

Lifecycle status, workflow stage, target completeness, scientific agreement, and assessment outcome are separate dimensions. Do not infer one from another.

## 2. Publication

- **Title:**
- **Authors:**
- **Year:**
- **Journal or venue:**
- **DOI:**
- **Publication URL:**
- **Published code or data URL:** explicit URL or missing-information status.

## 3. Computational Result

- **Computational Result ID:** stable identifier within the platform.
- **Title:**
- **Description:** describe the result or scientific claim being investigated.
- **Research question:**
- **Scientific field:**
- **Overall platform status:** `not_yet_submitted | in_verification | partially_verified | verification_completed | disputed | archived`
- **Status rationale:**

A Computational Result groups the scientific context. It does not imply that every target or every conclusion in the publication has been verified.

## 4. Numerical Targets

Create one entry for every specific quantity, profile, curve, table, computational behavior, or other testable claim.

Repeat this section for each target.

### Numerical Target `NT-001`

- **Stable target ID:** `NT-001` (never change this ID when the title or description changes).
- **Title:**
- **Description:**
- **Scope:** precisely state what is and is not being tested.
- **Quantity and unit:**
- **Verification completeness:** `not_started | in_progress | substantially_complete | complete`
- **Scientific agreement:** `agreement | agreement_with_limitations | disagreement | inconclusive | not_yet_established`
- **Acceptance criteria:** list the criterion IDs defined below.
- **Reference dataset IDs:**
- **Implementation IDs:**
- **Execution IDs:**
- **Evidence IDs:**
- **Assessment IDs:**
- **Notes:**

A target can be completely examined while disagreement remains. Completeness is not scientific agreement.

## 5. Reference Datasets

Create a separate object for every reference dataset or independently extracted dataset. Do not merge independent digitizations into one dataset.

For each dataset:

- **Reference dataset ID:**
- **Target IDs:** one or more stable Numerical Target IDs.
- **Description:**
- **Underlying reference type:** `experimental | observational | theoretical | numerical | other`
- **Acquisition method:** `reported_in_publication | author_provided | third_party_dataset | digitized_figure | independently_calculated | other`
- **Source citation:**
- **Publication figure/page:** when applicable.
- **Source URL:**
- **Contributor and acquisition date:** when applicable.
- **Data location and format:**
- **Units:**
- **Uncertainty information:** kind, original value/form, unit, method, and notes. Preserve statistical, systematic, observational, numerical, digitization, and covariance information where available.
- **Digitization metadata:** tool/version, procedure, axis calibration and scale, series identification, extraction range, point count, manual corrections, image-resolution limits, and other limitations.
- **Notes:**

Clearly distinguish values explicitly reported by the authors from values extracted or calculated by contributors. Respect copyright, licenses, and data-use restrictions.

## 6. Acceptance Criteria

Define criteria separately for each target, preferably before execution and comparison.

For each criterion:

- **Criterion ID:** unique within the record.
- **Description:**
- **Quantity and unit:**
- **Comparison metric:** `absolute_error | relative_error | rms_error | maximum_norm | visual_agreement | qualitative | other`
- **Criterion type:** `absolute_tolerance | relative_tolerance | range | qualitative | physical_check | other`
- **Threshold or allowed range:** numerical value or explicit qualitative rule.
- **Comparison domain:**
- **Alignment/interpolation method:**
- **Scientific justification:**
- **Established at:** date/time.
- **Revision history:** date/time, change, and reason for each change.

There is no universal tolerance for all scientific problems. If criteria are revised after exploratory work, preserve the original criterion and explain why the revision is scientifically justified.

## 7. Implementations

Create a separate object for each implementation. One implementation may address multiple targets.

For each implementation:

- **Implementation ID:**
- **Name:**
- **Role:** `original_method | primary_reproduction | cross_check | exploratory`
- **Target IDs:**
- **Description:**
- **Method description:** governing equations, algorithm, discretization/approximation, and relevant assumptions.
- **Independence classification:** `fully_independent | partially_independent | not_independent`
- **Independence explanation:** explain shared equations, assumptions, algorithms, code, data, or post-processing.
- **Shared components and derived-from implementation IDs:**
- **Repository URL and source paths:**
- **Exact revision/commit:**
- **Language/runtime and dependencies:**
- **License and attribution:**
- **AI-assistance disclosure:**

Different code or solver names do not by themselves establish independent scientific validation. Independent coding does not necessarily mean an independent mathematical formulation.

## 8. Executions

Each execution represents one particular run of one implementation. Preserve failed and incomplete runs when relevant.

For each execution:

- **Execution ID:**
- **Implementation ID:**
- **Target IDs:**
- **Exact code revision/commit:**
- **Environment:**
  - Operating system and version.
  - Language runtime/compiler and version.
  - Relevant dependency names and versions.
  - Hardware/container/environment details, where relevant.
- **Command or procedure:**
- **Input data:** description, location, and SHA-256 hash where applicable.
- **Parameters:** exact values and units.
- **Execution date/time:** include timezone where known.
- **Outcome:** `success | failure | incomplete`
- **Numerical outputs:** quantity, value, unit, result type (`computed | derived | diagnostic`), comparison scope, uncertainty, and notes.
- **Evidence IDs:**
- **Manual interventions:**
- **Notes:**

An execution must point to the exact implementation revision used. Do not substitute the current repository revision for an unconfirmed historical revision.

## 9. Evidence

Give every evidence item a stable, unique ID. Link it to the target and, where relevant, to the execution, reference dataset, implementation, or assessment it supports.

For each item:

- **Evidence ID:**
- **Description:**
- **Kind:** `source_code | raw_output | execution_log | comparison_script | reference_data | test | report | figure | other`
- **Location:** repository-relative path or external URL, or an explicit missing-information status.
- **Availability:** `available | not_yet_confirmed | unavailable | not_applicable`
- **Target IDs:**
- **Execution ID / reference dataset ID / implementation ID / assessment ID:** where applicable.
- **Code revision:**
- **SHA-256:** where applicable.
- **Metadata:**

Distinguish raw outputs from derived summaries and manually transcribed values. Each important claim should be traceable to the evidence supporting it.

## 10. Verification Assessments

Multiple assessments are allowed. Preserve each assessment; a later assessment must not overwrite an earlier one.

For each assessment:

- **Assessment ID:**
- **Target IDs assessed:**
- **Assessor identity:**
- **Assessor display name and expertise:** expertise disclosure is required; formal credentials are not a prerequisite for participation.
- **Outcome:** `agreement | agreement_with_limitations | disagreement | inconclusive | not_assessed`
- **Implementation IDs examined:**
- **Evidence IDs examined:**
- **Acceptance criterion IDs applied:**
- **Scientific reasoning:** explain the evidence, methods, assumptions, and limitations behind the conclusion.
- **Assessment date:**
- **Review scope:**
- **Unresolved issues:**
- **Expert endorsement:** true/false, only where a distinct expert-endorsement designation is intended.

Community discussion is not itself a formal assessment. An assessment is attributable and scoped to the targets and evidence actually examined.

## 11. Limitations

List specific limitations, including as applicable:

- Unavailable or rounded published reference values.
- Missing implementation details or uncertain code provenance.
- Unconfirmed execution environments or historical revisions.
- Incomplete convergence, sensitivity, or uncertainty analysis.
- Reference-data or digitization limitations.
- Targets, claims, or conclusions not examined.
- Unresolved discrepancies and lack of independent review.
- Licensing, attribution, or AI-assistance details still requiring confirmation.

Do not convert unknowns into assumptions or imply that unexamined parts of a paper have been verified.

## 12. Record provenance

- **Repository URL:**
- **Record revision/commit:**
- **License and attribution:**
- **AI-assistance disclosure:**
- **Tools used to prepare the record:**
- **Additional provenance notes:**

---

## Scientific interpretation principles

1. Keep the published reference, contributor-computed result, cross-verification comparison, and assessment conclusion distinct.
2. Agreement between implementations is evidence of numerical consistency, not automatic proof that the publication or shared model is correct.
3. A target-specific conclusion must not be generalized to the entire paper without evidence.
4. Report discrepancies and uncertainty honestly; do not impose universal error thresholds.
5. Preserve failed runs, revisions, disagreements, and unresolved questions.
6. Review should help contributors improve their work through clear, evidence-based, actionable feedback.
7. Structural schema validation does not establish numerical or scientific correctness.

## Relationship to the JSON Schema

The machine-readable schema is `schemas/verification-record-v2.schema.json`. This Markdown template explains the intended content but does not replace schema validation. The JSON record must use the exact property names, enumerated values, and object structures defined by that schema.
