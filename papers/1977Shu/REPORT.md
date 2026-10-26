# Numerical Reproduction Report: Shu (1977), Self-Similar Collapse of Isothermal Spheres

**Status:** Partial numerical reproduction with cross-method consistency checks
**Target paper:** Shu, F. H. (1977), “Self-Similar Collapse of Isothermal Spheres and Star Formation,” *The Astrophysical Journal*, 214, 488–497.
**Reference:** [NASA ADS paper record and PDF](https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF)
**Implementation environment:** GNU Octave on Windows
**Primary test case:** \(A=2.40\)

## Abstract

This report documents a numerical reproduction attempt of the self-similar isothermal collapse solutions presented by Shu (1977). The similarity equations were solved using two ordinary differential equation integration methods, classical fourth-order Runge–Kutta (RK4) and adaptive Runge–Kutta integration (RK45), and a Chebyshev spectral collocation method.

For the test case \(A=2.40\), the RK4 and RK45 integrations produced closely agreeing estimates of the central mass parameter, \(m_0\approx1.88520933\). The spectral calculation produced \(m_0\approx1.88516680\). Spectral calculations at resolutions \(N=240\) and \(N=320\) gave central mass estimates agreeing to approximately \(4\times10^{-10}\) in absolute terms. However, the \(N=320\) nonlinear solver terminated with a stagnation status rather than a convergence status. The paper reports \(m_0=1.88\) in its table at \(A=2.40\).

These results demonstrate strong numerical consistency between the two ODE integration methods. The spectral mass estimates at \(N=240\) and \(N=320\) are numerically close, but the \(N=320\) nonlinear solver terminated with a stagnation status. Their agreement therefore does not establish spectral convergence. The results do not yet establish exact reproduction of Shu’s original numerical procedure, nor do they constitute a fully successful spectral convergence study.

## 1. Objective

The objective is to reproduce the self-similar collapse solution for an isothermal sphere described by Shu (1977), focusing on the similarity profiles and the central mass parameter.

The primary comparison quantity is \(m_0\), evaluated for \(A=2.40\), for which the paper's table gives \(m_0=1.88\) at the printed precision.

The work also compares the density and velocity profiles obtained using different numerical methods.

## 2. Mathematical formulation

The similarity variables are defined as

\[
x=\frac{r}{at},\qquad
\rho=\frac{\alpha(x)}{4\pi Gt^2},\qquad
u=av(x),\qquad
M=\frac{a^3t}{G}m(x),
\]

where \(a\) is the isothermal sound speed and \(G\) is the gravitational constant.

The dimensionless mass is related to the density and velocity profiles by

\[
m(x)=x^2\alpha(x)\,[x-v(x)].
\]

The similarity equations implemented in the ODE solver are

\[
\frac{dv}{dx}
=
\frac{[\alpha(x-v)-2/x](x-v)}
{(x-v)^2-1},
\]

and

\[
\frac{d\alpha}{dx}
=
\frac{\alpha[\alpha-2(x-v)/x](x-v)}
{(x-v)^2-1}.
\]

These equations are integrated for the selected parameter \(A\), using the large-\(x\) asymptotic behavior to initialize the ODE calculations.

## 3. Numerical methods

### 3.1 RK4 integration

The fixed-step solver uses classical fourth-order Runge–Kutta integration. It starts at \(x=10\) and integrates inward to \(x=10^{-3}\).

The initial values use asymptotic expressions for \(\alpha\) and \(v\), including higher-order corrections. The central mass estimate uses the computed mass profile and a small-\(x\) extrapolation correction.

For \(A=2.40\), the run with nominal step size \(h=10^{-5}\) gave

\[
m_{0,\mathrm{RK4}}\approx1.8852093322.
\]

### 3.2 Adaptive RK45 integration

The adaptive solver uses GNU Octave's `ode45`, with `ode15s` available as a fallback in the implementation.

The reported test used the settings

- Relative tolerance: \(10^{-11}\)
- Absolute tolerance: \(10^{-13}\)
- Maximum step: \(0.005\)

The integration interval was \(10\geq x\geq10^{-3}\).

For \(A=2.40\), the result was

\[
m_{0,\mathrm{RK45}}\approx1.8852093325.
\]

The RK4 and RK45 profiles were compared on a common logarithmic grid using piecewise cubic Hermite (`pchip`) interpolation.

### 3.3 Chebyshev spectral collocation

The spectral solver represents the solution on a Chebyshev grid in \(t=\log x\). A Chebyshev differentiation matrix is used to discretize the differential equations, and a nonlinear Newton-type method solves the resulting residual equations.

The test used

\[
x_{\min}=10^{-6},\qquad x_{\max}=40,\qquad A=2.40.
\]

The outer boundary conditions use asymptotic expressions for the velocity and density. The inner behavior is represented through the nonlinear solution rather than by imposing a separately specified central boundary value.

The residual function, differentiation matrix, nonlinear solver, and wrapper are implemented in the Octave code. The wrapper was extended to test both \(N=240\) and \(N=320\), using the lower-resolution solution as the initial guess for the higher-resolution solver.

## 4. Results

### 4.1 Central mass estimates

| Method | Resolution or settings | Estimated \(m_0\) | Solver status |
|---|---|---:|---|
| RK4 | \(h=10^{-5}\), nominal | 1.8852093322 | Successful |
| RK45 | Specified adaptive tolerances | 1.8852093325 | Successful |
| Spectral | \(N=240\) | 1.8851668012 | Converged |
| Spectral | \(N=320\) | 1.8851668008 | Stagnated |

The RK4 and RK45 mass estimates differ by approximately \(3\times10^{-10}\). The spectral mass estimates differ by approximately \(4\times10^{-10}\) between the two tested resolutions.

The spectral and ODE-based estimates differ by approximately \(4.25\times10^{-5}\), or \(0.0023\%\) relative to the RK45 value.

### 4.2 Comparison with Shu (1977)

Shu's table reports \(m_0=1.88\) for \(A=2.40\).

The spectral estimate exceeds the printed value by approximately \(0.00517\); the RK4 and RK45 estimates exceed it by approximately \(0.00521\).

The table provides only two decimal places. Therefore, the printed value is insufficient to determine whether the small discrepancy reflects rounding, differences in numerical procedures, or other implementation details.

The results are close to the tabulated value, but exact agreement with the original numerical result has not been established.

### 4.3 Profile agreement

Using `pchip` interpolation on a common logarithmic grid, the maximum relative profile differences between RK4 and RK45 were approximately

| Quantity | Maximum relative difference |
|---|---:|
| Density \(\alpha\) | \(1.19\times10^{-8}\) |
| Velocity \(v\) | \(2.03\times10^{-9}\) |

The spectral solution at \(N=240\) differed from RK45 by approximately

| Quantity | Maximum relative difference |
|---|---:|
| Density \(\alpha\) | \(5.08\times10^{-5}\) |
| Velocity \(v\) | \(9.01\times10^{-5}\) |

The maximum density difference occurred near \(x=0.00278\); the maximum velocity difference occurred near \(x=1.0723\).

The close agreement of RK4 and RK45 is evidence of numerical consistency between the two integrations. Because they share the same equations, asymptotic initialization, and mass-extraction approach, their agreement is not an independent validation of those shared choices.

### 4.4 Spectral resolution test

The spectral mass estimates for \(N=240\) and \(N=320\) were

\[
m_{0,240}=1.8851668012,
\qquad
m_{0,320}=1.8851668008.
\]

Their difference is approximately \(4\times10^{-10}\). The maximum relative profile differences between the two candidate solutions were approximately \(5.70\times10^{-5}\) for \(\alpha\) and \(6.87\times10^{-5}\) for \(v\).

However, the \(N=320\) Newton solver terminated with status `stagnated`. Its reported scaled relative residual was approximately \(6.71\times10^{-8}\). The saved run also reports an unscaled residual norm of approximately \(1.14\times10^{-3}\); because the two residual measures use different scaling, their magnitudes should not be compared directly.

The close mass estimates and similar profiles indicate numerical consistency across the two tested resolutions, but they do not establish spectral convergence. Further investigation of the nonlinear solver's stopping criteria and residual scaling is needed before treating the \(N=320\) solution as converged.

## 5. Limitations

Several limitations remain.

1. **Exact procedural reproduction is unconfirmed.** Shu describes using asymptotic initial conditions evaluated at \(x=10\) and a fourth-order Runge–Kutta integration scheme. The available description does not fully specify every integration parameter needed to reproduce the original computation exactly.

2. **The central mass extraction includes an implementation-specific correction.** The small-\(x\) mass extrapolation used here has not been demonstrated to be identical to Shu's original extraction procedure.

3. **The spectral refinement test is incomplete.** The \(N=320\) nonlinear solver stagnated, so the higher-resolution candidate cannot yet be treated as a fully converged solution.

4. **The reference value is rounded.** The tabulated \(m_0=1.88\) does not provide enough digits for a stringent numerical error assessment.

5. **The methods share assumptions.** Agreement between the ODE solvers does not independently verify the derivation of the equations or the asymptotic initialization.

## 6. Reproducibility and implementation

The implementation uses GNU Octave and the following source files:

- `shu_odes.m` — similarity ODE system.
- `rk45_integrate.m` — adaptive ODE integration and mass estimation.
- `shu1977_rk4.m` — fixed-step fourth-order Runge–Kutta integration.
- `sc_cheb.m` — Chebyshev differentiation matrix.
- `sc_res_collapse.m` — spectral residual and outer boundary conditions.
- `sc_solve_collapse_N240.m` — original fixed-resolution spectral wrapper.
- `sc_solve_collapse_N.m` — configurable-resolution spectral wrapper.
- `sc_newton_cs.m` — nonlinear solver used by the spectral method.

For a complete reproducibility package, the repository should preserve the exact versions of these files, the Octave version, the parameter values, solver settings, command transcripts, convergence statuses, and generated output data. The spectral stagnation status should remain part of the recorded results rather than being omitted.

## 7. Conclusion

The implemented calculations produce mutually consistent numerical profiles for the \(A=2.40\) isothermal-collapse test case. The RK4 and RK45 integrations agree closely, while the spectral solver produces a similar central mass estimate and similar profiles at the two tested resolutions. However, the \(N=320\) nonlinear solver stagnated, so the spectral resolution test does not establish convergence.

The computed central mass is approximately \(1.88517\) using the spectral method and \(1.88521\) using the ODE integrations, compared with the \(1.88\) printed in Shu's table.

The evidence supports a **partial numerical reproduction with documented assumptions and cross-method consistency checks**. Exact reproduction of Shu's original computational procedure has not been established, and the spectral convergence study remains incomplete because the \(N=320\) nonlinear solver stagnated.

## Reference

Shu, F. H. (1977). “Self-Similar Collapse of Isothermal Spheres and Star Formation.” *The Astrophysical Journal*, 214, 488–497. https://doi.org/10.1086/155274
