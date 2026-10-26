# Computational Verification Record: Shu (1977)

## 1. Record Identity

- **Record ID:** CVR-1977-Shu-001
- **Record status:** Draft
- **Record version:** 0.1
- **Date created:** 2026-10-10
- **Date last updated:** 2026-10-10
- **Contributors:** Unknown; contributor attribution should be completed before publication.
- **Reviewers:** Not yet reviewed.

## 2. Publication Identity

- **Paper title:** Self-Similar Collapse of Isothermal Spheres and Star Formation
- **Authors:** Frank H. Shu
- **Publication year:** 1977
- **Journal or venue:** The Astrophysical Journal, 214, 488–497
- **DOI:** 10.1086/155274
- **Stable publication URL:** https://ui.adsabs.harvard.edu/abs/1977ApJ...214..488S/abstract
- **Published code or data URL:** Not reported in the project evidence examined so far.
- **Published numerical results being examined:** The similarity solution for isothermal spherical collapse, including the expansion-wave solution and the dimensionless mass-accretion parameter \(m_0(A)\) for the family of solutions.

## 3. Scientific Problem

- **Scientific field:** Astrophysics; star formation and self-similar gravitational collapse.
- **Research question:** Can the published similarity solutions and associated dimensionless quantities be reproduced using an independently formulated numerical method?
- **Physical or mathematical model:** Spherically symmetric, isothermal gas dynamics under self-gravity, expressed in similarity variables.
- **Governing equations:** The similarity relations and differential equations documented in `papers/1977Shu/mathematical_explanation.tex`. The dimensional relations include
  \[
  \rho(r,t)=\frac{\alpha(x)}{4\pi Gt^2},\qquad
  u(r,t)=av(x),\qquad
  M(r,t)=\frac{a^3t}{G}m(x),\qquad
  x=\frac{r}{at}.
  \]
  The mass relation is
  \[
  m=x^2\alpha(x)(x-v).
  \]
  The differential equations and their derivation should be checked against the cited paper and the mathematical documentation before this record is finalized.
- **Initial conditions:** Asymptotic starting conditions at \(x=10\) are documented for the original integration procedure. Exact coefficients and implementation details should be cited from the paper or supporting documentation.
- **Boundary conditions:** For the expansion-wave solution, the documented critical-point conditions are \(v(1)=0\) and \(\alpha(1)=2\). Other boundary and asymptotic conditions must be recorded separately for each solution family.
- **Model assumptions and limitations:** Isothermal equation of state, spherical symmetry, and the similarity formulation. Additional assumptions and the limits of applicability should be confirmed against the publication.

## 4. Original Numerical Method

- **Method described in the publication:** Four-step Runge–Kutta integration is documented in the reproduction notes.
- **Discretization or approximation:** Ordinary differential equations are integrated from asymptotic starting conditions; the expansion-wave limit is examined through extrapolation using \(A=2.003,\ 2.002,\ 2.001\), according to the reproduction notes.
- **Time-stepping or iteration procedure:** Spatial integration in the similarity coordinate; the detailed step-size policy requires confirmation from the paper or original documentation.
- **Convergence criteria:** Not yet fully established from the publication.
- **Implementation language and software:** Original implementation language and software are unknown from the evidence currently recorded.
- **Method details unavailable in the publication:** To be determined by a systematic comparison with the full paper and any supplementary material.

## 5. Independent Numerical Formulation

- **Independent method:** Chebyshev–Gauss–Lobatto spectral collocation in \(t=\ln x\), using \(w=\ln\alpha\), with a nonlinear residual solved by a regularized Newton method.
- **Reason for choosing this method:** To provide a numerical formulation distinct from direct fixed-step Runge–Kutta integration and to assess agreement under grid refinement.
- **Mathematical formulation:** The similarity equations are transformed into a nonlinear collocation system. The implementation and transformations are documented in `papers/1977Shu/mathematical_explanation.tex`.
- **Discretization or approximation:** Chebyshev–Gauss–Lobatto collocation, with continuation through \(N=30,\ 60,\ 120\) collocation points.
- **Initial and boundary conditions used:** The implementation uses the documented solution-specific conditions. For the expansion-wave solution, \(v(1)=0\) and \(\alpha(1)=2\) are enforced.
- **Treatment of singularities, critical points, or other numerical difficulties:** The critical point satisfies \((x-v)^2=1\). The spectral solver uses a logarithmic coordinate and log-density representation; details of the critical-point treatment must be checked in the code and mathematical documentation.
- **Expected sources of numerical error:** Collocation truncation, nonlinear-solver tolerance, regularization, domain truncation, boundary-condition implementation, and reference-value rounding.
- **Differences from the original formulation:** Spectral collocation and nonlinear residual solution are used instead of direct four-step Runge–Kutta integration. The extent of independence should be evaluated alongside shared equations, assumptions, and boundary conditions.

## 6. Implementation

- **Repository URL:** https://github.com/ccvphysicsresearch-source/computational-result-verification
- **Source-code path:** `papers/1977Shu/`; the exact paths of all solver and helper files should be confirmed against the current repository tree.
- **Programming language and version:** GNU Octave 10.3.0.
- **Dependencies and versions:** GNU Octave; additional dependencies should be confirmed from the source files and execution environment.
- **Operating system or execution environment:** Windows development environment is reported; the precise execution environment for each validation run should be recorded.
- **Execution instructions:** To be completed with the exact command used to run the solver from a clean checkout.
- **Input data:** Solver parameters, collocation resolutions, and solution-specific boundary conditions; exact inputs should be recorded with the execution command.
- **Output data:** `results/shu1977_results_spectral_full.txt` is the documented results-file path; verify that this file is present in the current repository.
- **Reproducible command or workflow:** Unknown until confirmed from the current source tree and a fresh execution.
- **Code revision or commit identifier:** Record the exact commit used for the validation run before finalizing.

## 7. Mathematical and Code Provenance

- **Equations and methods taken from the publication:** Similarity relations, governing similarity equations, and published reference quantities attributed to Shu (1977).
- **External algorithms, references, or software used:** Chebyshev spectral collocation and nonlinear least-squares/Newton techniques; exact algorithm references and software details should be listed in the mathematical documentation.
- **Original implementation components:** Unknown; no original author code has been established in the evidence recorded here.
- **Adapted or reused code:** To be checked by inspecting the source files and their license notices.
- **AI-assisted development disclosure, where applicable:** AI-assisted development was used in preparing the reproduction, according to the project documentation. The final record should link to the exact disclosure and distinguish assistance from human verification.
- **Licensing and attribution:** Verify the repository license, source-file notices, and the licensing status of any reused material before publication.
- **Equation-to-code traceability:** See `papers/1977Shu/mathematical_explanation.tex`; add precise source-file and function references before finalization.

## 8. Computational Results

- **Results generated:** A documented spectral-solver reproduction of the expansion-wave solution and the \(m_0(A)\) family.
- **Tables, figures, and data files:** `Shu1977_results_spectral_full.txt` is the documented results file; exact current path and tracked status must be checked.
- **Important derived quantities:** \(m_0(A)\), \(\alpha(x)\), \(-v(x)\), and \(m(x)\).
- **Numerical precision and tolerances:** The recorded comparisons report relative and absolute differences; solver tolerances and full precision of the reference data must be extracted from the actual implementation and result files.
- **Convergence or refinement tests:** Results were recorded for \(N=30,\ 60,\ 120\); Newton continuation reportedly converged in 2–4 iterations per stage. The underlying logs should be linked.
- **Sensitivity tests:** A comparison across multiple \(A\) values and an expansion-wave solution was recorded. Further sensitivity tests should be documented with their input parameters.
- **Execution logs or other supporting evidence:** Exact log paths are not yet established.
- **Evidence references:** `papers/1977Shu/mathematical_explanation.tex`; `papers/1977Shu/README.md`; the solver source files and numerical result files, whose exact paths and revision must be confirmed.

## 9. Quantitative Validation

### 9.1 Comparison definition

- **Published reference result:** Published \(m_0(A)\) values and expansion-wave profiles attributed to Shu (1977); the exact reference table, figure, or extraction procedure must be identified.
- **Independent result:** Spectral-collocation solver output documented in the project results.
- **Compared quantities and units:** Dimensionless \(m_0(A)\), \(\alpha(x)\), \(-v(x)\), and \(m(x)\).
- **Comparison domain:** \(A=2.2\)–\(4.0\) for the recorded \(m_0(A)\) comparison; \(x=0.05\)–\(1\) for the recorded expansion-wave profile comparison. The exact sampled points should be preserved in the evidence files.
- **Interpolation or alignment procedure, if needed:** Unknown until the comparison implementation is inspected.
- **Treatment of rounding and uncertainty:** The reported comparisons include differences from rounded published values. The exact precision of the paper's reference values must be documented.

### 9.2 Numerical agreement

- **Maximum absolute difference:** \(1.10\times10^{-2}\) for the recorded \(m_0(A)\) comparison.
- **Maximum relative difference, where meaningful:** \(0.293\%\) for the recorded \(m_0(A)\) comparison; \(0.380\%\) for \(\alpha(x)\), \(0.618\%\) for \(-v(x)\), and \(0.442\%\) for \(m(x)\) in the expansion-wave comparison.
- **RMS difference or other summary metric:** Recorded \(m_0(A)\) RMS absolute difference \(7.02\times10^{-3}\); mean absolute difference \(6.26\times10^{-3}\); mean relative difference \(0.190\%\).
- **Agreement in important derived quantities:** At \(x=1\), the spectral result reportedly satisfies \(\alpha=2\), \(-v=0\), and \(m=2\) to approximately \(10^{-15}\). At \(x_{\min}=10^{-3}\), the recorded \(m_0\) is \(0.975484\), compared with a published value of \(0.975\), a difference of \(4.84\times10^{-4}\).
- **Convergence verified:** Provisionally, yes, according to the recorded \(N=30,\ 60,\ 120\) refinement study; verify the underlying data before finalization.
- **Acceptance criteria and justification:** No universal tolerance is assumed. The observed differences should be evaluated relative to the published precision, refinement behavior, independent-method agreement, and their effect on the scientific conclusion.

## 10. Discrepancy Analysis

- **Discrepancy detected:** Yes, small numerical differences are recorded.
- **Comparison level:** Numerical result.
- **Classification:** Numerical method and source or reporting are plausible categories; the cause is not conclusively established.
- **Evidence supporting the classification:** Recorded differences between spectral results and published values, along with reported agreement among spectral, fixed-step RK4, and adaptive RK45 implementations.
- **Cause established:** Partially. Historical RK4/critical-region resolution and published rounding have been suggested as possible explanations, but have not been established as the definitive cause.
- **Unresolved questions:** Exact reference-value extraction, original integration settings, comparison alignment, and the reproducibility of all reported summary statistics from the current repository.
- **Effect on the verification result:** The recorded discrepancies are small, but their final classification and impact assessment depend on confirming the reference data and comparison workflow.

## 11. Physical and Structural Agreement

- **Relevant physical or mathematical properties:** Similarity scaling, the critical-point condition, the expansion-wave boundary values, and consistency of the dimensionless mass relation.
- **Qualitative behavior preserved:** Provisionally, yes, according to the recorded comparison; direct evidence should be linked.
- **Critical features preserved:** The critical-point values at \(x=1\) are reported to agree to approximately machine precision.
- **Conservation, stability, scaling, or other applicable properties:** Similarity relations and the mass relation are relevant. A separate conservation-law or stability analysis has not yet been established by the recorded evidence.
- **Evidence and limitations:** Mathematical documentation and solver outputs are the intended evidence sources; precise code and data references remain to be added.

## 12. Scientific Conclusion

- **Original scientific conclusion examined:** Shu's self-similar isothermal-collapse solution and the associated expansion-wave behavior and dimensionless mass-accretion parameter.
- **Conclusion supported by the independent computation:** The recorded computation is consistent with the examined published numerical results within the reported differences; full source-to-result traceability remains to be confirmed.
- **Original conclusion preserved:** Provisionally, yes; not yet a final independently reviewed determination.
- **Does the discrepancy affect the scientific conclusion?** No material effect has been identified in the recorded analysis, subject to confirmation of the numerical evidence.
- **Scientific impact:** Provisionally negligible.
- **Justification:** Reported profile differences are below \(0.7\%\), and the recorded critical-point values agree to approximately machine precision. This assessment remains provisional until the comparison and reference extraction are independently checked.

## 13. Verification Verdict

- **Numerical agreement:** PASS WITH DIFFERENCES (provisional)
- **Physical or structural agreement:** PASS (provisional)
- **Scientific conclusion:** PRESERVED (provisional)
- **Overall verdict:** INCONCLUSIVE pending evidence and workflow audit.
- **Primary discrepancy source:** Unknown; numerical-method and source/reporting effects remain possible.
- **Discrepancy impact:** Provisionally negligible.
- **Verdict justification:** Existing project notes report close quantitative agreement and cross-method consistency. However, the exact source data, execution commands, logs, code revision, and comparison procedure have not yet been assembled here as traceable evidence. Under the project's own policy, the overall verdict remains INCONCLUSIVE until those essential elements are confirmed.

## 14. Review and Revision History

- **Independent reviewer:** None recorded.
- **Review date:** Not yet reviewed.
- **Review comments:** Pending.
- **Changes requested:** Pending review.
- **Resolution of review comments:** Not applicable at this draft stage.
- **Revision history:** Version 0.1; initial draft assembled from existing project notes and documentation.

## 15. Limitations and Future Work

- **Limitations of this verification:** The record has not yet been independently reviewed. Several evidence paths, execution details, and reference-extraction procedures remain to be confirmed.
- **Evidence limitations:** The reported quantitative statistics are drawn from prior project notes; their reproduction from the current source files and raw comparison data has not yet been demonstrated in this record.
- **Unverified claims or quantities:** Original method settings; exact published reference values and their extraction; current availability and revision of result files; solver tolerances; comparison alignment; full cross-method agreement; licensing and code-reuse status.
- **Additional tests needed:** Re-run the documented workflow from the recorded commit; reproduce summary statistics from raw comparison data; confirm critical-point treatment and refinement results; review source and provenance documentation.
- **Potential independent implementations:** A fresh implementation of the similarity equations using a separately coded adaptive Runge–Kutta solver, with explicit critical-point handling.
- **Suggested future work:** Attach machine-readable comparison data and execution logs, record exact source paths and commit hashes, obtain an independent technical review, and revise the verdict only after the evidence audit.

---

**Draft status note:** This record is a structured starting point. Numerical values and method descriptions must be checked against the current repository, the full publication, and reproducible execution evidence before the record can be marked `Verified`.