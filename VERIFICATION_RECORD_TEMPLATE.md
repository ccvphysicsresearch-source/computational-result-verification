# Computational Verification Record — Template v1.0

## Field Completion and Missing-Information Policy
Every field must be completed with documented information or an explicit status value. Blank fields are permitted in draft records but should be resolved before a record is finalized.

Use the following values consistently:

* **Unknown** — The information is relevant, but it could not be established from the available evidence.
* **Not reported** — The information was not explicitly reported in the cited publication or source being examined.
* **Not applicable** — The field does not apply to the scientific problem or verification procedure.

These values are not interchangeable. In particular, do not use `Not applicable` merely because information is unavailable.

Where relevant, include a brief explanation of the status and identify the sources examined.

### Required and Conditional Fields

**Core requirements for a finalized verification record:**

1. Identification of the publication and the scientific result being examined.
2. Description of the original numerical method, including any unavailable details.
3. Description of the independent numerical formulation and implementation.
4. Identification of the computational evidence and comparison procedure.
5. Quantitative validation results, where quantitative comparison is applicable.
6. Analysis of relevant physical or mathematical properties.
7. Assessment of the effect on the original scientific conclusion.
8. An overall verdict with an evidence-based justification.
9. Limitations, provenance, and sufficient information to assess the verification independently.

**Conditional requirements:**

Some fields depend on the scientific problem. For example, conservation-law checks, critical-point analysis, stability tests, and time-stepping details are required only when relevant to the problem or method.

A conditional field that genuinely does not apply should be marked `Not applicable`, with a brief justification when the reason is not self-evident.

A missing or unresolved essential piece of evidence must not be concealed by assigning a `PASS` verdict.

## 1. Record Identity

* **Record ID:**
* **Record status:** Draft / Under Review / Verified / Archived

Record status describes the workflow or review stage; it is separate from the verification verdict. For example, a record may be `Under Review` while its current verdict is `INCONCLUSIVE`. Use `Verified` only when the record has met the project's review requirements.
* **Record version:**
* **Date created:**
* **Date last updated:**
* **Contributors:**
* **Reviewers:**

## 2. Publication Identity

* **Paper title:**
* **Authors:**
* **Publication year:**
* **Journal or venue:**
* **DOI:**
* **Stable publication URL:**
* **Published code or data URL:** Not available / URL
* **Published numerical results being examined:**

## 3. Scientific Problem

* **Scientific field:**
* **Research question:**
* **Physical or mathematical model:**
* **Governing equations:**
* **Initial conditions:**
* **Boundary conditions:**
* **Model assumptions and limitations:**

## 4. Original Numerical Method

* **Method described in the publication:**
* **Discretization or approximation:**
* **Time-stepping or iteration procedure:**
* **Convergence criteria:**
* **Implementation language and software:**
* **Method details unavailable in the publication:**

Distinguish methods explicitly documented by the authors from details inferred or reconstructed by the verifier.

## 5. Independent Numerical Formulation

* **Independent method:**
* **Reason for choosing this method:**
* **Mathematical formulation:**
* **Discretization or approximation:**
* **Initial and boundary conditions used:**
* **Treatment of singularities, critical points, or other numerical difficulties:**
* **Expected sources of numerical error:**
* **Differences from the original formulation:**

Explain why this constitutes an independent numerical approach and identify any shared assumptions, algorithms, or code.

## 6. Implementation

* **Repository URL:**
* **Source-code path:**
* **Programming language and version:**
* **Dependencies and versions:**
* **Operating system or execution environment:**
* **Execution instructions:**
* **Input data:**
* **Output data:**
* **Reproducible command or workflow:**
* **Code revision or commit identifier:**

## 7. Mathematical and Code Provenance

* **Equations and methods taken from the publication:**
* **External algorithms, references, or software used:**
* **Original implementation components:**
* **Adapted or reused code:**
* **AI-assisted development disclosure, where applicable:**
* **Licensing and attribution:**
* **Equation-to-code traceability:**

Clearly distinguish published scientific content, independent mathematical formulation, implementation choices, and third-party material.

## 8. Computational Results

* **Results generated:**
* **Tables, figures, and data files:**
* **Important derived quantities:**
* **Numerical precision and tolerances:**
* **Convergence or refinement tests:**
* **Sensitivity tests:**
* **Execution logs or other supporting evidence:**
* **Evidence references:** Links or paths to source files, result tables, figures, execution logs, and relevant code revisions; identify the specific evidence supporting important claims.

## 9. Quantitative Validation

### 9.1 Comparison definition

* **Published reference result:**
* **Independent result:**
* **Compared quantities and units:**
* **Comparison domain:**
* **Interpolation or alignment procedure, if needed:**
* **Treatment of rounding and uncertainty:**

### 9.2 Numerical agreement

* **Maximum absolute difference:**
* **Maximum relative difference, where meaningful:**
* **RMS difference or other summary metric:**
* **Agreement in important derived quantities:**
* **Convergence verified:** Yes / No / Not applicable / Unknown
* **Acceptance criteria and justification:**

Do not interpret relative errors near zero without considering absolute errors and the scale of the quantity.

## 10. Discrepancy Analysis

* **Discrepancy detected:** Yes / No / Unknown
* **Comparison level:** Model / Mathematical formulation / Numerical result / Physical behavior / Scientific conclusion
* **Classification:** Physical or model / Numerical method / Implementation / Source or reporting / Unknown
* **Evidence supporting the classification:**
* **Cause established:** Yes / No / Partially
* **Unresolved questions:**
* **Effect on the verification result:**

More than one discrepancy class may apply. An unexplained discrepancy must remain explicitly unresolved.

## 11. Physical and Structural Agreement

* **Relevant physical or mathematical properties:**
* **Qualitative behavior preserved:** Yes / No / Partially / Not applicable
* **Critical features preserved:** Yes / No / Partially / Not applicable
* **Conservation, stability, scaling, or other applicable properties:**
* **Evidence and limitations:**

Specify which properties are relevant to the scientific problem; not every property applies to every paper.

## 12. Scientific Conclusion

* **Original scientific conclusion examined:**
* **Conclusion supported by the independent computation:**
* **Original conclusion preserved:** Yes / No / Partially / Inconclusive
* **Does the discrepancy affect the scientific conclusion?** Yes / No / Unknown
* **Scientific impact:** Negligible / Minor / Significant / Major / Unknown
* **Justification:**

## 13. Verification Verdict

* **Numerical agreement:** PASS / PASS WITH DIFFERENCES / INCONCLUSIVE / FAIL
* **Physical or structural agreement:** PASS / PASS WITH DIFFERENCES / INCONCLUSIVE / FAIL / NOT APPLICABLE
* **Scientific conclusion:** PRESERVED / CHANGED / INCONCLUSIVE / NOT ASSESSED
* **Overall verdict:** PASS / PASS WITH DIFFERENCES / INCONCLUSIVE / FAIL
* **Primary discrepancy source:** Physical or model / Numerical method / Implementation / Source or reporting / Unknown / None identified
* **Discrepancy impact:** Negligible / Minor / Significant / Major / Unknown
* **Verdict justification:**

The verdict must be based on documented evidence and problem-appropriate criteria. No universal numerical-error threshold applies to all scientific problems.

## 14. Review and Revision History

* **Independent reviewer:**
* **Review date:**
* **Review comments:**
* **Changes requested:**
* **Resolution of review comments:**
* **Revision history:**

## 15. Limitations and Future Work

* **Limitations of this verification:**
* **Evidence limitations:** Claims not checked, unavailable sources, tests not performed, and reasons the evidence is incomplete or insufficient.
* **Unverified claims or quantities:**
* **Additional tests needed:**
* **Potential independent implementations:**
* **Suggested future work:**

---

## Verification Record Principles

1. Separate the original numerical method from the independent numerical formulation.
2. Make every verification claim traceable to evidence.
3. Report methods, assumptions, software, and execution conditions transparently.
4. Distinguish numerical agreement from physical agreement and agreement in scientific conclusions.
5. Classify discrepancies before interpreting their significance.
6. Do not treat failure to reproduce a result as proof that the original publication is incorrect.
7. Do not impose a universal numerical-error threshold across different scientific problems.
8. Preserve unresolved questions rather than filling gaps with unsupported assumptions.
9. Make the code, data, comparison procedure, and limitations accessible wherever licensing and practical constraints permit.
