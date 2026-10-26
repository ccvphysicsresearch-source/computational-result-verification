# Computational Verification Record: Shu (1977)

**Record status:** Draft — evidence audit in progress
**Record ID:** CVR-1977-Shu-001
**Record version:** 0.2
**Date created:** 2026-10-10
**Date last updated:** 2026-10-26
**Contributors:** Unknown; contributor attribution required before publication.
**Reviewers:** Not yet independently reviewed.

## 1. Record Identity

- **Record ID:** CVR-1977-Shu-001
- **Record status:** Draft — evidence audit in progress
- **Record version:** 0.2
- **Date created:** 2026-10-10
- **Date last updated:** 2026-10-26
- **Contributors:** Unknown; attribution must be completed before publication.
- **Reviewers:** Not yet reviewed.

## 2. Publication Identity

- **Paper title:** Self-Similar Collapse of Isothermal Spheres and Star Formation
- **Authors:** Frank H. Shu
- **Publication year:** 1977
- **Journal or venue:** *The Astrophysical Journal*, 214, 488–497
- **DOI:** [10.1086/155274](https://doi.org/10.1086/155274)
- **Stable publication URL:** [NASA Astrophysics Data System](https://ui.adsabs.harvard.edu/abs/1977ApJ...214..488S/abstract)
- **Published code or data URL:** Not reported in the project evidence examined so far.
- **Published numerical results examined:** The similarity solutions for isothermal spherical collapse, with the primary quantitative test focused on the dimensionless mass parameter for \(A=2.4\). Shu's Table 1 reports a mass value of approximately \(1.88\) at the printed precision for this case.

This record does not claim to reproduce every solution family, profile, table, or scientific result in the publication.

## 3. Scientific Problem

- **Scientific field:** Astrophysics; star formation and self-similar gravitational collapse.
- **Research question:** To what extent can selected numerical results from Shu (1977) be reproduced and cross-checked using documented numerical implementations?
- **Physical or mathematical model:** Spherically symmetric, isothermal gas dynamics under self-gravity, expressed in similarity variables.
- **Similarity variables:**

  \[
  x=\frac{r}{at},\qquad
  \rho(r,t)=\frac{\alpha(x)}{4\pi Gt^2},
  \qquad u(r,t)=av(x).
  \]

  The dimensionless enclosed mass is

  \[
  m(x)=x^2\alpha(x)(x-v(x)).
  \]

- **Governing equations:** Define \(w=x-v\) and \(D=w^2-1\). The implemented equations are

  \[
  xD\frac{dv}{dx}=(\alpha wx-2)w,
  \]

  \[
  xD\frac{d\alpha}{dx}=\alpha(\alpha x-2w)w.
  \]

  Their equivalence to the equations in Shu (1977), including the treatment of the critical point, must be checked against the original publication and the project's mathematical documentation before final approval.
- **Initial conditions:** The RK4 and RK45 test case uses asymptotic starting conditions at \(x=10\). Exact coefficients should be checked against the implementation and the original paper. The Taylor-series method has its own documented local initialization; its exact settings must be linked to the corresponding test evidence.
- **Boundary and critical-point conditions:** For the expansion-wave solution, the documented conditions include \(v(1)=0\) and \(\alpha(1)=2\). This record does not claim that the local Taylor test alone verifies the complete expansion-wave solution.
- **Model assumptions and limitations:** Isothermal equation of state, spherical symmetry, and the similarity formulation. The physical assumptions and their applicability must be assessed against the publication.

## 4. Original Numerical Method

- **Method described in the publication:** Runge–Kutta integration is described in the reproduction notes. The precise original implementation details must be checked against the full paper.
- **Discretization or approximation:** Integration of the similarity ordinary differential equations from asymptotic starting conditions.
- **Time-stepping or iteration procedure:** The detailed original step-size policy is Unknown unless established from the publication or other authoritative documentation.
- **Convergence criteria:** The original numerical stopping and error criteria are Not reported in the evidence currently assembled.
- **Implementation language and software used by the original authors:** Unknown.
- **Method details unavailable or not yet established:** Exact original solver settings, complete initialization coefficients, central-mass extraction procedure, and any undocumented implementation choices.

The reproduction implementations are not assumed to duplicate every detail of Shu's original computation.

## 5. Independent Numerical Formulation

The current benchmark uses three numerical approaches.

### 5.1 Fixed-step RK4

- **Method:** Classical fourth-order Runge–Kutta integration.
- **Purpose:** Compute the similarity profiles and mass for the selected \(A=2.4\) test case.
- **Recorded interval:** \(x=10\) inward to \(x=10^{-3}\).
- **Recorded step size:** \(h=10^{-5}\).
- **Recorded mass:** \(m_0=1.885209332164\).
- **Recorded profile size:** 999,901 points.
- **Principal limitation:** RK4 shares the governing-equation implementation and initialization assumptions with RK45. Agreement between the two does not independently validate those shared choices.

### 5.2 Adaptive RK45 using ODE45

- **Method:** Adaptive Runge–Kutta integration using GNU Octave's `ode45`.
- **Purpose:** Cross-check the fixed-step RK4 calculation and compare the resulting profiles.
- **Recorded interval:** \(x=10\) inward to \(x=10^{-3}\).
- **Relative tolerance:** \(10^{-11}\).
- **Absolute tolerance:** \(10^{-13}\).
- **Maximum step:** \(0.005\).
- **Recorded mass:** \(m_0=1.885209332537\).
- **Recorded profile size:** 9,269 points.
- **Principal limitation:** The RK45 implementation uses the same governing equations and right-hand-side implementation as RK4. Their agreement is a numerical integration cross-check, not a fully independent validation of the mathematical formulation.

### 5.3 Higher-order Taylor-series integration

- **Method:** Higher-order Taylor-series integration using the project's Taylor coefficient, critical-point, and marching routines.
- **Purpose:** Provide an additional numerical approach that does not use Runge–Kutta stepping or global spectral collocation.
- **Recorded local test interval:** \(x=2\) to \(x=1.5\).
- **Recorded comparison:** Taylor-series integration against ODE45.
- **Recorded maximum scaled differences:**
  - \(v\): \(3.585\times10^{-14}\).
  - \(\alpha\): \(5.909\times10^{-14}\).
  - \(m\): \(1.095\times10^{-13}\).
- **Recorded Taylor order:** \(K=16\) for the cited local comparison.
- **ODE45 tolerances recorded for that comparison:** Relative tolerance \(10^{-12}\), absolute tolerance \(10^{-14}\).
- **Remaining documentation requirement:** Link the exact test script, Taylor marching settings, initialization, output, and comparison procedure.
- **Principal limitation:** The local comparison does not establish a global error bound or verify the complete collapse solution.

### 5.4 Scope exclusion

Chebyshev spectral collocation was explored during development but is excluded from the primary verification results and verdict. Its historical code and diagnostic artifacts are retained as exploratory work. Their results are not used as evidence for the conclusions of this record.

## 6. Implementation

- **Repository URL:** [Computational Result Verification](https://github.com/ccvphysicsresearch-source/computational-result-verification)
- **Relevant source directory:** `papers/1977Shu/code/`
- **Recorded RK4 source:** `papers/1977Shu/code/shu1977_rk4.m`
- **Recorded RK45 source:** `papers/1977Shu/code/shu1977_rk45.m`
- **Recorded shared ODE implementation:** `papers/1977Shu/code/shu_odes.m`
- **Taylor-series source files:** `shu_tay_coeffs.m`, `shu_tay_crit.m`, and `shu_tay_march.m`; exact repository paths and revision identifiers must be confirmed.
- **Profile-writing helper:** `sc_write_profile.m`; its role in the relevant Taylor workflow must be confirmed before attributing outputs to it.
- **Programming language and version:** GNU Octave is used for the recorded numerical implementations. The exact Octave version for each result must be confirmed from execution logs.
- **Operating system:** Windows development environment reported. Exact run environment must be recorded.
- **Dependencies and versions:** GNU Octave and any required packages; the complete dependency list remains to be verified.
- **Execution instructions:** Exact commands must be recorded and tested from the intended repository state.
- **Input data:** Parameter \(A\), starting and ending coordinates, initial conditions, step size or tolerances, and method-specific settings.
- **Output data:** RK4/RK45 comparison evidence includes `papers/1977Shu/results/rk4_rk45_crosscheck_A2.4.txt`. The exact current locations of Taylor test outputs and raw comparison data must be confirmed.
- **Reproducible workflow:** Not yet fully established for a clean checkout.
- **Code revision:** Record the exact Git commit hash used for each final validation run.

Historical exploratory files should be preserved. Their presence alone does not establish that they were used in the primary calculations.

## 7. Mathematical and Code Provenance

- **Equations attributed to the publication:** Similarity variables, governing similarity equations, critical-point conditions, and published numerical quantities.
- **Mathematical documentation:** `papers/1977Shu/mathematical_explanation.tex` is identified in earlier project notes; its current existence and contents must be checked before it is cited as authoritative evidence.
- **External algorithms and software:** Classical RK4, GNU Octave `ode45`, and higher-order Taylor-series integration. Exact algorithm references and implementation details should be added where relevant.
- **Original author code:** Unknown; no original implementation has been established in the current record.
- **Adapted or reused code:** Must be determined by source inspection and license review.
- **AI-assisted development disclosure:** AI-assisted development was used during preparation of the reproduction, according to project documentation. The final record should identify the applicable disclosure and distinguish assistance with development from independent technical review.
- **Licensing and attribution:** Repository license, source-file notices, and the licensing status of reused material must be verified before publication.
- **Equation-to-code traceability:** Map each governing equation and critical-point condition to the exact source function and line range before the record is finalized.

## 8. Computational Results

### 8.1 RK4 and RK45

For \(A=2.4\), the recorded mass estimates are

\[
m_{0,\mathrm{RK4}}=1.885209332164,
\]

\[
m_{0,\mathrm{RK45}}=1.885209332537.
\]

The absolute difference is approximately \(3.73\times10^{-10}\), and the relative difference is approximately \(1.98\times10^{-10}\).

The recorded maximum relative profile differences, calculated on a common logarithmic grid using piecewise cubic Hermite interpolation, are:

| Quantity | Maximum relative difference |
|---|---:|
| Density profile \(\alpha\) | \(1.19\times10^{-8}\) |
| Velocity profile \(v\) | \(2.03\times10^{-9}\) |

These are reported comparison results. The comparison script and underlying profile data must be linked so another researcher can reproduce the statistics.

### 8.2 Taylor-series local comparison

The Taylor-series method and ODE45 were compared over \(x=2\) to \(x=1.5\). The recorded maximum scaled differences are:

| Quantity | Maximum scaled difference |
|---|---:|
| Velocity \(v\) | \(3.585\times10^{-14}\) |
| Density \(\alpha\) | \(5.909\times10^{-14}\) |
| Mass \(m\) | \(1.095\times10^{-13}\) |

These results support close agreement for this local test. The scaling definition, test script, initialization, and raw output must be preserved for independent reproduction. The results must not be interpreted as global error estimates.

### 8.3 Published numerical result

For \(A=2.4\), Shu's Table 1 reports \(m_0\approx1.88\) at the printed precision.

The recorded RK4 and RK45 values are consistent with this rounded value. Because the published number has only two decimal places, the difference between a computed value and \(1.88\) is not, by itself, a reliable estimate of numerical error against an exact reference.

### 8.4 Excluded exploratory results

Spectral-collocation calculations and their resolution studies are outside the primary evidence set. They must not be used to claim successful spectral convergence or to determine the primary verdict in this record.

## 9. Quantitative Validation

### 9.1 Comparison definitions

- **Published reference result:** Shu's tabulated mass value \(m_0\approx1.88\) for \(A=2.4\), subject to verification against the original table.
- **RK4 result:** \(1.885209332164\).
- **RK45 result:** \(1.885209332537\).
- **Taylor-series result:** Local profile and mass comparison against ODE45 over \(x=2\) to \(x=1.5\); this test is not a direct high-precision comparison against a published mass value.
- **Compared quantities:** Dimensionless mass \(m\), density profile \(\alpha\), and velocity profile \(v\).
- **Comparison domains:** The full RK4/RK45 integration interval is \(10\geq x\geq10^{-3}\). The documented Taylor comparison covers only \(2\geq x\geq1.5\).
- **Interpolation or alignment:** The RK4/RK45 profile comparison uses a common logarithmic grid and piecewise cubic Hermite interpolation. The exact Taylor comparison alignment procedure must be linked to the test implementation.
- **Rounding and uncertainty:** The published mass value is rounded to two decimal places. A more precise authoritative reference has not been established in this record.

### 9.2 Numerical agreement

- **Absolute RK4/RK45 mass difference:** Approximately \(3.73\times10^{-10}\).
- **Relative RK4/RK45 mass difference:** Approximately \(1.98\times10^{-10}\).
- **Maximum relative RK4/RK45 density-profile difference:** Approximately \(1.19\times10^{-8}\).
- **Maximum relative RK4/RK45 velocity-profile difference:** Approximately \(2.03\times10^{-9}\).
- **Maximum scaled Taylor/ODE45 differences:** \(3.585\times10^{-14}\) for \(v\), \(5.909\times10^{-14}\) for \(\alpha\), and \(1.095\times10^{-13}\) for \(m\), for the documented local test.
- **Convergence verified:** The recorded agreement supports numerical consistency for the specific comparisons. It does not establish convergence of every solution family or global convergence of the Taylor-series method.
- **Acceptance criteria:** No universal tolerance is assumed. Results should be assessed against the documented comparison procedure, solver settings, reference precision, and intended scientific quantity.

## 10. Discrepancy Analysis

- **Discrepancies detected:** The computed mass values differ from the rounded printed value \(1.88\), and RK4 and RK45 differ by a small numerical amount.
- **Comparison level:** Numerical result and numerical integration cross-check.
- **Classification:** The RK4/RK45 difference is consistent with a small numerical integration difference under the tested settings. The difference from the printed mass value cannot be conclusively classified using the rounded value alone.
- **Evidence:** Recorded RK4/RK45 masses and profile-difference statistics; Shu's tabulated value, subject to checking against the original paper.
- **Cause established:** No complete causal analysis has been established.
- **Unresolved questions:** Exact reference-value extraction, original integration settings, mass-extraction details, raw comparison data, and independent reproduction of the summary statistics.
- **Effect on verification:** The available data support close numerical consistency for the tested case, but do not prove exact procedural reproduction or full scientific verification.

## 11. Physical and Structural Agreement

- **Relevant mathematical properties:** Similarity scaling, the governing ODEs, the critical-point conditions, and the dimensionless mass relation.
- **Qualitative behavior preserved:** Not fully established by the quantitative comparisons documented here.
- **Critical features preserved:** The expansion-wave conditions \(v(1)=0\) and \(\alpha(1)=2\) are documented in the project. Their implementation and numerical satisfaction should be supported by explicit tests before a pass verdict is assigned.
- **Conservation, stability, and scaling:** The mass relation and similarity scaling are relevant checks. A separate conservation-law or stability analysis is not established by the current evidence.
- **Evidence and limitations:** The numerical results support the specified cross-checks, but a comprehensive physical and structural validation remains outstanding.

## 12. Scientific Conclusion

- **Original scientific result examined:** Selected numerical aspects of Shu's self-similar isothermal-collapse solutions, with a primary mass comparison at \(A=2.4\) and a local Taylor-series cross-check.
- **Conclusion supported by the computation:** RK4 and RK45 produce closely matching numerical results for the tested configuration. The Taylor-series method agrees closely with ODE45 over the documented local interval.
- **Original conclusion preserved:** Not determined comprehensively. The documented comparisons do not cover every result or scientific claim in the paper.
- **Does the discrepancy affect the scientific conclusion?** No material effect has been demonstrated for the narrow numerical comparisons documented here. A broader scientific-impact assessment is not established.
- **Scientific impact:** Not established beyond the tested quantities and intervals.
- **Justification:** The recorded numerical methods agree closely in the stated comparisons, and the RK4/RK45 mass values are consistent with the published rounded value. This does not independently validate the full mathematical formulation, every solution branch, or the paper's broader conclusions.

## 13. Verification Verdict

- **RK4/RK45 numerical consistency:** Supported for the documented \(A=2.4\) test case, subject to reproduction of the comparison statistics.
- **Taylor-series/ODE45 local consistency:** Supported for the documented interval \(x=2\) to \(x=1.5\), subject to confirmation of the test configuration and raw output.
- **Agreement with the published mass:** Consistent with the rounded value \(m_0\approx1.88\); high-precision agreement with an authoritative reference has not been established.
- **Physical or structural agreement:** Not fully assessed.
- **Scientific conclusion:** Not comprehensively verified.
- **Overall verdict:** **PARTIAL NUMERICAL REPRODUCTION — broader verification pending.**
- **Primary unresolved issues:** Evidence traceability, reproducible execution instructions, complete equation-to-code mapping, exact reference extraction, independent review, and confirmation of the Taylor comparison artifacts.
- **Verdict justification:** The available results demonstrate close numerical consistency between RK4 and RK45 for a specified test case and between Taylor-series integration and ODE45 for a specified local interval. These are meaningful cross-checks, but they do not establish full independent verification of Shu (1977).

This verdict is deliberately scoped to the evidence currently documented. It should be revised only when additional checks are reproducibly demonstrated.

## 14. Review and Revision History

- **Independent reviewer:** None recorded.
- **Review date:** Not yet reviewed.
- **Review comments:** Pending.
- **Changes requested:** Pending review.
- **Resolution of review comments:** Not applicable at this draft stage.
- **Revision history:**
  - **Version 0.1:** Initial draft assembled from prior project notes and documentation.
  - **Version 0.2:** Primary scope revised to RK4, RK45, and higher-order Taylor series. Spectral collocation and its historical quantitative claims were removed from the primary verification evidence. Verdict narrowed to the documented comparisons.

## 15. Limitations and Future Work

- **Limitations:** The record has not been independently reviewed. Exact commands, code revisions, comparison scripts, raw data, and some method-specific settings remain to be confirmed.
- **Evidence limitations:** Reported numerical statistics must be reproduced from the identified source files and output data. A recorded result is not independently verified merely because it appears in a report.
- **Unverified claims or quantities:** Exact original solver settings, authoritative high-precision reference values, complete Taylor-series workflow details, full equation-to-code traceability, and broad physical or structural agreement.
- **Additional tests needed:**
  1. Re-run RK4 and RK45 from a recorded Git revision and reproduce their mass and profile comparisons.
  2. Re-run the Taylor-series local test with recorded settings and regenerate its comparison statistics.
  3. Preserve raw numerical outputs and the scripts that calculate the reported differences.
  4. Check the governing equations, asymptotic initialization, critical-point treatment, and mass extraction against the publication and mathematical documentation.
  5. Record software versions, execution commands, source revision identifiers, and file hashes where appropriate.
  6. Obtain independent technical review before assigning a stronger verdict.
- **Potential future independent implementations:** A separately coded solver with independently checked equation transcription and initialization. Such an implementation would provide additional evidence beyond comparisons that share the same right-hand side.
- **Suggested future work:** Improve machine-readable evidence, attach execution logs and comparison data, document provenance and licensing, and revise the verdict only after the relevant tests have been reproduced and reviewed.

---

**Draft status note:** This record remains a draft. Numerical values and method descriptions must be checked against the current repository, the original publication, and reproducible execution evidence before the record is marked as verified.