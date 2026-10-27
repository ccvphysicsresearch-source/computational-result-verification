# Verification Protocol

## Purpose

This protocol defines how computational reproductions are submitted, evaluated, and reviewed on the platform. It separates the maturity of the verification process from the scientific conclusions supported by the evidence.

A completed workflow stage does not automatically establish scientific correctness.

## 1. Workflow stages

### Stage 1 — Submitted

**Purpose:** Establish a traceable submission.

Minimum requirements:

- Identify the scientific publication and, where available, its DOI.
- State the specific result, figure, table, equation, or computational claim being reproduced.
- Describe the reproduction attempt and its intended scope.
- Provide available source code, data, or a clear explanation of what is missing.
- Identify information that is unknown or not reported.

Passing this stage means the submission has enough information to be assessed. It does not mean the code has been executed or the result reproduced.

### Stage 2 — Execution checked

**Purpose:** Establish that the documented computational procedure can be executed under recorded conditions.

Minimum requirements:

- Provide code and instructions sufficient to attempt execution.
- Record the software environment, relevant dependencies, configuration, and numerical parameters.
- Record whether execution succeeded, failed, or was only partially completed.
- Preserve relevant logs and output files.
- Document execution errors and any manual interventions.

Successful execution demonstrates that the code ran under the stated conditions. It does not establish mathematical correctness or agreement with the publication.

### Stage 3 — Numerically cross-checked

**Purpose:** Compare computed results against a stated reference or another computational result.

Minimum requirements:

- Identify each quantity being compared and its source.
- Distinguish published reference values from newly computed values.
- Specify comparison procedures, units, tolerances, and error metrics where meaningful.
- Record convergence or sensitivity tests appropriate to the problem.
- Document discrepancies and unresolved numerical issues.
- Describe the relationship between the methods being compared, including shared equations, assumptions, initial conditions, code, and data.

Agreement between methods is evidence of numerical consistency. Its strength depends on the independence of the implementations and the quality of the reference.

A failed or inconclusive comparison must be documented honestly; it must not be represented as successful reproduction.

### Stage 4 — Independently reviewed

**Purpose:** Record a documented review of the scientific and computational evidence.

Minimum requirements:

- Identify the review date and reviewer, subject to the platform's attribution and privacy policies.
- State which parts of the record, code, formulation, and evidence were examined.
- Record the reviewer's findings, concerns, and requested corrections.
- Document the disposition of significant issues.
- Preserve the review history when the record changes.

A review applies only to its documented scope. It does not establish that every aspect of a paper or implementation has been verified.

## 2. Scientific verdicts

The scientific verdict is separate from the workflow stage. Use one of the following labels and explain the evidence supporting the choice.

### Reproduced within stated tolerances

The specified target result agrees with the stated reference within predefined or explicitly justified tolerances, and the documented checks are adequate for the scope claimed.

### Partial numerical reproduction

Some specified results or computational properties have been reproduced, but the evidence does not establish the full target result or broader scientific claim.

### Inconsistent with reference

A material discrepancy remains between the computed result and the reference under a documented comparison procedure. The discrepancy, its significance, and any investigated causes must be reported.

### Inconclusive

The available evidence is insufficient to determine whether the target result has been reproduced. Examples include missing reference data, unresolved numerical instability, incomplete execution, or ambiguous comparison criteria.

Do not use a successful execution or agreement between two implementations alone to claim that a scientific conclusion has been verified.

## 3. Required record fields

Every verification record must document each applicable field or explicitly use one of these labels:

- **Unknown** — the information is currently unknown to the contributor.
- **Not reported** — the information could not be found in the consulted source material.
- **Not applicable** — the field does not apply to this particular benchmark, with a brief explanation where needed.

Do not leave required fields silently blank. These labels describe missing information; they do not count as evidence that a requirement has been satisfied.

Each record should identify:

- Record identifier, version, status, and update date.
- Publication identity and target result.
- Original method and information available about it.
- Reproduced formulation, assumptions, and implementation.
- Code provenance, dependencies, and execution instructions.
- Numerical parameters, outputs, reference data, and comparison metrics.
- Method-independence assessment.
- Discrepancies, limitations, and unresolved questions.
- Scientific verdict and its justification.
- Review and revision history.

Problem-specific fields may be added where necessary.

## 4. Evidence and provenance

Whenever possible, preserve the following as versioned artifacts:

- Source code and configuration files.
- Execution instructions and environment information.
- Raw or machine-readable numerical outputs.
- Comparison scripts, error calculations, and test results.
- Logs and diagnostic reports relevant to the verdict.
- References to the publication, source data, and code versions.

Each reported result should be traceable to the code, configuration, and execution that produced it. Distinguish raw outputs from derived summaries and manually transcribed values.

If evidence cannot be made publicly available, document the restriction and explain its effect on independent assessment.

## 5. Assessing method independence

Describe the relationship between each pair of methods rather than assigning independence based only on different software or algorithm names.

Consider whether methods share:

- Governing equations or mathematical derivations.
- Assumptions, boundary conditions, and initial conditions.
- Source code, libraries, or copied implementation logic.
- Reference data or preprocessing procedures.
- Error calculations and post-processing.

Different integration algorithms can provide useful numerical cross-checks without independently validating the underlying formulation. A separately written implementation can still reproduce a shared conceptual error.

State which aspects of the result each comparison supports and which remain untested.

## 6. Limitations and discrepancies

Report failed runs, unexpected behavior, sensitivity to numerical parameters, unresolved discrepancies, and excluded methods when relevant.

A method excluded from the primary assessment should not be presented as supporting the final verdict. Its code and historical results may be retained as exploratory evidence if clearly labeled.

Do not interpret agreement in a single test case as a universal error bound or proof of correctness.

## 7. Updating a record

When evidence or code changes:

1. Update the record version and date.
2. Identify the changed artifacts and claims.
3. Re-run affected checks when feasible.
4. Explain whether the change affects the verdict.
5. Preserve prior review decisions and the reason for any verdict change.

Verification records are evidence-backed documents that can evolve as new information becomes available.

## 8. Scope of the platform

A platform verdict applies to the specific computational targets and checks documented in the record. It is not a general endorsement of the entire publication, all of its conclusions, or every use of the associated code.
