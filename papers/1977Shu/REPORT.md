# Numerical Reproduction Report: Shu (1977)

**Status:** Partial numerical reproduction with three-method cross-checks
**Target paper:** Shu, F. H. (1977), “Self-Similar Collapse of Isothermal Spheres and Star Formation,” *The Astrophysical Journal*, 214, 488–497.
**DOI:** [10.1086/155274](https://doi.org/10.1086/155274)

## 1. Objective and scope

This report documents a numerical reproduction study of the similarity solutions discussed by Shu (1977). The primary computational scope is restricted to three numerical approaches:

1. Fixed-step fourth-order Runge–Kutta (RK4).
2. Adaptive Runge–Kutta integration using ODE45 (RK45).
3. Higher-order Taylor-series integration.

The objective is to compare numerical outputs, document the conditions under which agreement is observed, and assess consistency with specific published results. The study does not claim to verify every numerical result or scientific conclusion in the original paper.

Chebyshev spectral collocation was explored during development but is excluded from the primary verification results. Its historical source files and diagnostic outputs are retained separately and are not used to support the conclusions in this report.

## 2. Mathematical problem

The similarity variables are

\[
x=\frac{r}{at},\qquad
\rho(r,t)=\frac{\alpha(x)}{4\pi Gt^2},\qquad
u(r,t)=av(x),
\]

with dimensionless enclosed mass

\[
m(x)=x^2\alpha(x)(x-v(x)).
\]

Define

\[
w=x-v,\qquad D=w^2-1.
\]

The equations used in the computational implementation are

\[
xD\frac{dv}{dx}=(\alpha wx-2)w,
\]

\[
xD\frac{d\alpha}{dx}=\alpha(\alpha x-2w)w.
\]

Equation conventions, critical-point treatment, and asymptotic initial conditions must be traceable to the mathematical documentation and checked against the original publication before a final independent-review verdict is assigned.

## 3. Numerical methods

### 3.1 Fixed-step RK4

The recorded RK4 calculation uses \(A=2.4\), starts at \(x=10\), and integrates inward to \(x=10^{-3}\) with step size \(h=10^{-5}\).

Reported dimensionless mass:

\[
m_0=1.885209332164.
\]

The recorded profile contains 999,901 points.

### 3.2 Adaptive RK45

The recorded RK45 calculation uses the same parameter and integration endpoints, with relative tolerance \(10^{-11}\), absolute tolerance \(10^{-13}\), and maximum step \(0.005\).

Reported dimensionless mass:

\[
m_0=1.885209332537.
\]

The recorded profile contains 9,269 points.

### 3.3 Higher-order Taylor series

The Taylor-series implementation advances the solution using local higher-order expansions rather than a Runge–Kutta stepper or global spectral collocation.

A documented local test compares Taylor-series integration with ODE45 from \(x=2\) to \(x=1.5\). The reported maximum scaled differences are:

| Quantity | Maximum scaled difference |
|---|---:|
| \(v\) | \(3.585\times10^{-14}\) |
| \(\alpha\) | \(5.909\times10^{-14}\) |
| \(m\) | \(1.095\times10^{-13}\) |

These figures support close agreement for the specified local test. They are not global error bounds and do not establish agreement over every solution branch or integration interval.

The Taylor order, tolerances, initialization, comparison procedure, and exact output artifacts must accompany the result in the finalized evidence package.

## 4. Quantitative comparisons

### 4.1 RK4 versus RK45

| Quantity | Recorded result |
|---|---:|
| RK4 mass | 1.885209332164 |
| RK45 mass | 1.885209332537 |
| Absolute mass difference | \(3.73\times10^{-10}\) |
| Relative mass difference | Approximately \(1.98\times10^{-10}\) |
| Maximum relative profile difference in \(\alpha\) | \(1.19\times10^{-8}\) |
| Maximum relative profile difference in \(v\) | \(2.03\times10^{-9}\) |

The recorded profiles were compared on a common logarithmic grid using piecewise cubic Hermite interpolation. The exact comparison script and data should be linked in the finalized record.

The close agreement supports numerical consistency between the two integration schemes for the tested configuration. Because the implementations share the governing equations and right-hand-side implementation, this comparison is not a fully independent validation of the mathematical formulation.

### 4.2 Comparison with the published mass

For the \(A=2.4\) case, Shu's Table 1 reports a dimensionless mass value of approximately \(1.88\) at the published precision.

Both RK4 and RK45 produce values consistent with this rounded number. The additional digits from the computations should not be interpreted as a direct error measurement against an exact value unavailable at that precision.

### 4.3 Taylor-series comparison

The Taylor-series method has demonstrated close local agreement with ODE45 over the documented interval. This result provides an additional numerical cross-check, subject to confirmation of the implementation details and reproducible output.

The local comparison should not be presented as a global validation of the full collapse solution.

## 5. Interpretation

The present evidence supports two limited findings:

- RK4 and RK45 give closely matching mass and profile results for the tested \(A=2.4\) configuration.
- The higher-order Taylor-series method agrees closely with ODE45 in the documented local integration test.

These results are evidence of numerical consistency. They do not independently establish the correctness of all governing equations, boundary conditions, physical assumptions, solution branches, or scientific conclusions in Shu (1977).

## 6. Limitations and outstanding evidence

Before the benchmark is assigned a final verification verdict, the following items must be confirmed:

- Exact source files and revision identifiers used for each reported result.
- Reproducible commands and software versions.
- Taylor-series order, tolerances, and initialization for the reported comparison.
- The comparison script and raw data underlying profile-difference statistics.
- Equation and boundary-condition traceability to the original publication.
- Independent technical review of the computational evidence.

Information that is unavailable should be marked **Unknown**, **Not reported**, or **Not applicable**, as appropriate, rather than inferred.

## 7. Current assessment

**Assessment:** Numerical cross-consistency demonstrated for the specific cases examined; broader quantitative verification remains limited to the documented comparisons.

The RK4 and RK45 results are closely consistent with one another and with the rounded mass value reported by Shu (1977) for the examined case. The Taylor-series method supplies a further local numerical comparison with ODE45.

The benchmark remains a partial numerical reproduction. A final verification verdict requires complete evidence traceability, review of the mathematical formulation and boundary conditions, reproducible execution instructions, and independent technical review.

## References

Shu, F. H. (1977). "Self-Similar Collapse of Isothermal Spheres and Star Formation." *The Astrophysical Journal*, 214, 488–497. https://doi.org/10.1086/155274

NASA Astrophysics Data System: https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF