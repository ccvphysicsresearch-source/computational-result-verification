# Reproducing the Shu (1977) Taylor–RK45 Verification

## 1. Purpose

This guide describes how to run the automated Taylor-series versus adaptive Runge–Kutta verification test for the numerical solution associated with:

Shu, F. H. (1977), “Self-Similar Collapse of Isothermal Spheres and Star Formation,” *The Astrophysical Journal*, 214, 488–497.

- DOI: https://doi.org/10.1086/155274
- Paper PDF: https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF

The test checks whether two numerical integration methods produce consistent values for the dimensionless enclosed mass at a specified endpoint.

## 2. Software requirements

The test requires GNU Octave or a compatible MATLAB environment supporting the functions used by the implementation, including `odeset` and `ode45`.

Record the actual software version and operating system used for each verification run.

## 3. Source files

The main test is:

`papers/1977Shu/code/test_shu_taylor.m`

It uses the following supporting files:

- `shu_tay_march.m` — Taylor-series integration.
- `shu_tay_coeffs.m` — Taylor coefficient calculation.
- `shu_tay_crit.m` — supporting critical-point calculations.
- `rk45_integrate.m` — adaptive Runge–Kutta integration.

The test adds its own source directory to the MATLAB/Octave search path.

## 4. Test configuration

The test uses the following settings:

| Parameter | Value |
|---|---:|
| Similarity parameter \(A\) | 2.4 |
| Starting coordinate | 10 |
| Endpoint coordinate | 0.001 |
| Taylor order | 30 |
| Taylor tolerance | \(10^{-14}\) |
| RK45 relative tolerance | \(10^{-11}\) |
| RK45 absolute tolerance | \(10^{-13}\) |
| RK45 maximum step | 0.005 |
| Allowed absolute mass difference | \(10^{-8}\) |

Both methods use the same asymptotic initial conditions and endpoint for this comparison.

## 5. Run the verification

From the repository root, start GNU Octave:

```powershell
octave
```

At the Octave prompt, run:

```matlab
cd('papers/1977Shu/code')
test_shu_taylor
```

Alternatively, if the `octave` command is available in PowerShell, run the test without opening the interactive prompt:

```powershell
octave --quiet --eval "cd('papers/1977Shu/code'); test_shu_taylor"
```

If Octave is not recognized as a command, launch it using the executable path configured on your computer.

## 6. Expected outputs

The test prints:

- The configuration used.
- Taylor and RK45 endpoint mass values.
- The absolute difference between the endpoint masses.
- The number of steps reported by each method.
- A `PASS` or `FAIL` verification status.

The test writes its machine-readable report to:

`papers/1977Shu/results/taylor_verification.json`

The report contains the configuration, endpoint mass values, absolute error, allowed error, step counts, and comparison description.

The test passes when the relevant values are finite, the Taylor endpoint density is positive, and the absolute endpoint-mass difference does not exceed the configured tolerance.

Exact step counts and floating-point values can depend on the software implementation and execution environment. Record the actual output from your run rather than assuming that a historical output will be reproduced exactly.

## 7. What the test establishes

A passing result provides evidence that the Taylor-series and RK45 implementations agree on the endpoint mass for the specified configuration and tolerance.

It does not, by itself, establish that:

- The original paper's entire numerical procedure has been reproduced exactly.
- The governing equations and boundary conditions have been independently validated.
- The extrapolated central mass \(m_0\) agrees between both methods.
- An independent reviewer has confirmed the implementation.

The test compares endpoint mass at \(x=10^{-3}\), not extrapolated central mass \(m_0\). These quantities must not be presented as interchangeable.

## 8. Evidence and provenance

For a published verification record, preserve:

- The exact source revision used for the run.
- The actual Octave or MATLAB version and operating system.
- The command used to run the test.
- The complete console output.
- The generated `taylor_verification.json` report.
- Any errors, failed runs, or changes to solver settings.

A passing automated test is evidence of numerical consistency under the stated conditions. It is not equivalent to independent scientific review or complete reproduction of the original paper.

## 9. Status

This guide documents the Taylor-versus-RK45 endpoint-mass test. Broader reproduction claims require additional evidence and should be assessed separately.