# Contribute

We welcome contributions that make scientific results easier to reproduce, compare, and independently evaluate.

## Ways to contribute

- Reproduce a result reported in a scientific paper.
- Implement an independent numerical method or formulation.
- Compare computed values with published tables, figures, or reference data.
- Improve execution instructions, automated tests, or diagnostic tools.
- Review equations, assumptions, convergence evidence, and numerical discrepancies.
- Report failed reproduction attempts and unresolved limitations.

## Before submitting

Identify the scientific publication and the specific result you want to reproduce. Check whether a verification record already exists, and explain how your contribution extends, tests, or corrects the existing evidence.

Distinguish values reported by the publication from values computed by your implementation. Do not present a numerical match as proof that the underlying scientific formulation is correct.

## Submission checklist

Before requesting review, check each applicable item:

- [ ] **Target:** Identify the publication and the specific result, figure, table, equation, or claim.
- [ ] **Formulation:** Document the governing equations, assumptions, initial conditions, and boundary conditions relevant to the calculation.
- [ ] **Implementation:** Provide source code, execution instructions, dependencies, and software versions.
- [ ] **Parameters:** Record numerical settings, solver tolerances, discretization parameters, and other relevant configuration.
- [ ] **Results:** Preserve numerical outputs and identify which values are published references and which are newly computed.
- [ ] **Comparison:** Explain the comparison procedure, error metrics, tolerances, and convergence or sensitivity tests where applicable.
- [ ] **Independence:** Describe shared equations, assumptions, code, libraries, data, and post-processing between compared methods.
- [ ] **Limitations:** Report failed runs, discrepancies, missing information, and unresolved questions.
- [ ] **Provenance:** Identify the relevant code version and preserve logs or other evidence needed to trace the result.
- [ ] **Record:** Update the verification record using the project's verification protocol.

If information is unavailable, mark it explicitly as **Unknown**, **Not reported**, or **Not applicable**, as appropriate, rather than silently omitting a required field.

## How to report results

Report successful and unsuccessful outcomes honestly. A failed run or disagreement with a published result can be a valuable contribution when the procedure and evidence are documented.

State exactly what was checked and avoid broader claims than the evidence supports. In particular, agreement between two implementations does not establish independent validation if they share a formulation, assumptions, or implementation logic.

Use the workflow stages and scientific verdicts defined in the [Verification Protocol](protocol.md). Workflow progress and scientific conclusions must be reported separately.

## Current development stage

The platform is under development. The initial priority is to establish a rigorous, transparent verification record using the Shu (1977) benchmark before expanding to additional papers.

Contributions should currently be submitted through the project's GitHub repository and reviewed before inclusion.

## Review and acceptance

Contributions may be reviewed for scientific scope, numerical evidence, traceability, clarity, and consistency with the verification protocol. Review findings and unresolved issues should be documented.

Acceptance into the platform does not automatically mean that a scientific result or the entire publication has been verified.

## Licensing and responsible contribution

Respect the licenses and attribution requirements of source code, datasets, and other materials. Clearly identify material derived from existing work.

Do not remove contradictory evidence or conceal failed tests to make a reproduction appear successful. Preserve enough information for others to understand and assess the claims being made.