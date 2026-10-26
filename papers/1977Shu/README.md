# Shu (1977): Numerical Reproduction

This directory contains a numerical reproduction project for F. H. Shu's paper, *Self-Similar Collapse of Isothermal Spheres and Star Formation*.

**Current status:** Partial numerical reproduction with documented assumptions and cross-method consistency checks.

## 1. Reference

F. H. Shu (1977), “Self-Similar Collapse of Isothermal Spheres and Star Formation,” *The Astrophysical Journal*, **214**, 488–497.

- [ADS paper record and PDF](https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF)
- [DOI: 10.1086/155274](https://doi.org/10.1086/155274)

## 2. Objective

The objective is to solve the similarity equations for the collapse of an isothermal sphere and compare the numerical results with the published solution.

The project uses three numerical approaches:

1. Adaptive Runge–Kutta integration (RK45).
2. Fixed-step fourth-order Runge–Kutta integration (RK4).
3. A Chebyshev spectral collocation solver.

The implementations use the same governing similarity equations and asymptotic outer-boundary initial conditions where applicable.

## 3. Mathematical formulation

The similarity variables are

\[
x=\frac{r}{at},\qquad
\rho=\frac{\alpha(x)}{4\pi Gt^2},\qquad
u=av(x),
\]

where \(r\) is radius, \(t\) is time, \(a\) is the isothermal sound speed, \(G\) is the gravitational constant, and \(\alpha(x)\) and \(v(x)\) are dimensionless density and velocity profiles.

The dimensionless enclosed mass is

\[
m(x)=x^2\alpha(x)\,[x-v(x)].
\]

The similarity ordinary differential equations used in the numerical integrations are

\[
\frac{dv}{dx}
=
\frac{\left[\alpha(x-v)-2/x\right](x-v)}
{(x-v)^2-1},
\]

\[
\frac{d\alpha}{dx}
=
\frac{\alpha\left[\alpha-2(x-v)/x\right](x-v)}
{(x-v)^2-1}.
\]

The numerical methods use asymptotic expansions at a large outer radius to initialize the integration. The spectral solver instead enforces its outer-boundary conditions through its nonlinear residual system.

## 4. Directory structure

```text
1977Shu/
├── README.md
├── REPORT.md
├── code/
│   ├── shu_odes.m
│   ├── rk45_integrate.m
│   ├── shu1977_rk4.m
│   ├── shu1977_rk45.m
│   ├── shu1977_spectral_octave.m
│   ├── sc_cheb.m
│   ├── sc_res_collapse.m
│   ├── sc_solve_collapse.m
│   ├── sc_solve_collapse_N.m
│   └── other supporting solver files
└── results/
    └── summary.csv
```

The filenames above describe the expected organization of the project. Check the actual contents of `code/` before relying on this list; supporting files may differ.

## 5. Software requirements

- GNU Octave.
- The `.m` files in the `code/` directory and their supporting functions.
- The `results/` directory for recorded numerical summaries.

Record the exact GNU Octave version and operating system used when publishing or archiving results.

## 6. Running the numerical solvers

Install GNU Octave and clone or download this repository.

In GNU Octave, change to the repository's `papers/1977Shu/code` directory. For example, if the repository is in your current working directory:

```matlab
cd('papers/1977Shu/code')
```

Run the adaptive Runge–Kutta script:

```matlab
shu1977_rk45
```

The script uses `A` values from 2.2 to 4.0 for the collapse solutions and computes an expansion-wave estimate using \(A=2.001,\ 2.002,\ 2.003\). It writes its output to `shu1977_results_rk45.txt` in the current working directory.

For the fixed-step RK4 implementation and the spectral collocation solver, consult their source files and the documented test commands below. The scripts have different interfaces; check their function signatures before calling them.

### Spectral collocation test

The following call runs the solver at resolutions \(N=240\) and \(N=320\), allowing candidate results to be returned even when a resolution does not converge:

```matlab
[x320,v320,alpha320,h320] = ...
    sc_solve_collapse_N(2.4,[],[],[],true,40,1e-6,[240 320]);
```

Inspect `h320` to determine the status of each resolution. In the recorded test, \(N=240\) converged while \(N=320\) stagnated. Do not interpret the latter candidate as a converged solution.


## 7. Current results

| Method | Status | Estimated \(m_0\) |
|---|---|---:|
| RK4 | Successful integration | 1.8852093322 |
| RK45 | Successful integration | 1.8852093325 |
| Spectral, \(N=240\) | Converged | 1.8851668012 |
| Spectral, \(N=320\) | Stagnated | 1.8851668008* |
| Shu (1977), Table 1 | Published rounded value | 1.88 |

\*The \(N=320\) value is a candidate estimate from a stagnated run, not a converged result.

The RK4 and RK45 profile comparisons show maximum relative differences of approximately \(1.19\times10^{-8}\) for \(\alpha\) and \(2.03\times10^{-9}\) for \(v\), using the recorded common-grid comparison.

The spectral \(N=240\) profile differs from RK45 by maximum relative amounts of approximately \(5.08\times10^{-5}\) for \(\alpha\) and \(9.01\times10^{-5}\) for \(v\) on the comparison grid \(10^{-3}\leq x\leq10\).

See [`results/summary.csv`](results/summary.csv) for the machine-readable numerical summary and [`REPORT.md`](REPORT.md) for the fuller discussion.

## 8. Interpretation and limitations

The close agreement between RK4 and RK45 provides evidence of numerical consistency between two integration schemes. Because they use the same governing equations and initial asymptotic conditions, this agreement is not an independent validation of the mathematical formulation.

The spectral \(N=240\) solver converged according to its numerical criterion, while the \(N=320\) run stagnated. The latter should be treated as a diagnostic candidate, not as a successful higher-resolution convergence result.

The computed mass estimates are close to the published value \(m_0=1.88\), but the paper's tabulated value is rounded. The discrepancy alone does not establish whether the implementation reproduces every detail of the original calculation.

The paper describes using asymptotic expansions through two orders in \(x^{-2}\), evaluated at \(x=10\), to initialize a fourth-order Runge–Kutta integration. The precise step size and all numerical implementation details are not specified. Consequently, this project should be described as a partial numerical reproduction rather than an exact recreation of every original computational choice.

## 9. Reproducibility record

When updating this project, preserve:

- The exact solver source files used for each run.
- The GNU Octave version and operating system.
- Solver parameters and boundary conditions.
- Convergence messages and residual diagnostics.
- The commands used to generate the reported values.
- Any failed, stagnated, or nonconverged runs.

Do not overwrite a failed run's status with a success label merely because its output looks plausible.

## 10. Status

**Partial numerical reproduction.** The RK4 and RK45 solutions agree closely, and the \(N=240\) spectral solve converged. The higher-resolution spectral run stagnated, and the exact original numerical procedure is not fully specified. Further investigation is required before claiming a complete reproduction of Shu (1977).
