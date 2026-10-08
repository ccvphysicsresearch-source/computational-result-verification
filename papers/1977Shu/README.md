# Computational Verification of Shu (1977)

## Paper

**Shu, F. H. (1977)**
*Self-Similar Collapse of Isothermal Spheres and Star Formation*
The Astrophysical Journal, **214**, 488–497.
DOI: 10.1086/155274

* [ADS bibliographic record](https://ui.adsabs.harvard.edu/abs/1977ApJ...214..488S/abstract)
* [ADS full-text PDF](https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF)

This repository contains an **independent computational verification** of the similarity
solutions presented in Shu (1977).

The verification uses an independent numerical implementation, cross-code verification, and
quantitative validation of the published results.

> **Project mission:** A community-driven platform for independently verifying published scientific
> results through computational reproduction, cross-code verification, and quantitative validation.

---

## Verification Summary

| Criterion | Result |
|---|---|
| Mathematical problem | Matched |
| Original numerical method | Four-step Runge–Kutta |
| Independent numerical method | Chebyshev–Gauss–Lobatto spectral collocation |
| Cross-code verification | PASS |
| Maximum relative difference in reported comparisons | 0.618% |
| Physical behavior | Preserved |
| Scientific conclusion | Preserved |
| Discrepancy impact | Negligible |
| Overall verdict | **PASS** |

---

## Scientific Problem

Shu (1977) studies the self-similar gravitational collapse of an isothermal gas sphere.

The similarity variable is

$$
x = \frac{r}{at},
$$

where $r$ is radius, $t$ is time, and $A$ is the isothermal sound speed.

The physical variables are written in terms of dimensionless similarity functions:

$$
\rho(r,t)=\frac{\alpha(x)}{4\pi Gt^2},
$$

$$
u(r,t)=a\,v(x),
$$

$$
M(r,t)=\frac{a^3t}{G}m(x).
$$

The reduced mass is related to the density and velocity through

$$
m(x)=x^2\alpha(x)\left[x-v(x)\right].
$$

The numerical solutions being independently reproduced and validated here are:

$$
\alpha(x),\qquad v(x),\qquad m(x).
$$

---

## Numerical Result Being Validated

The primary numerical results considered are:

1. The family of similarity solutions for different values of the asymptotic density parameter $A$.
2. The reduced central/core mass $m_0$.
3. The expansion-wave solution obtained in the limit $$
A\rightarrow2^+
$$.
4. The values of $\alpha(x)$, $-v(x)$, and $m(x)$ for the expansion-wave solution.
5. The behavior at the critical point $$
x=1
$$.

The published values are taken from the numerical results and tables reported in Shu (1977).

---

## Numerical Method Used in the Original Paper

Shu (1977) obtains the similarity solutions numerically using an asymptotic expansion at large $$
x
$$, followed by numerical integration of the resulting ordinary differential equations.

The paper starts the numerical integration at

$$
x=10
$$

using the asymptotic series and then integrating inward using a **four-step Runge–Kutta method**.

For the expansion-wave solution, Shu approaches the limiting case $$
A=2
$$ using solutions with

$$
A=2.003,\quad 2.002,\quad 2.001
$$

and obtains the limiting solution by quadratic extrapolation.

This provides the reference numerical solution against which the independent implementation is compared.

---

## Independent Implementation

The present repository provides a numerical solver for the same similarity equations using a **different numerical method**.

The main program is:

```text
code/shu1977_spectral_octave.m
```

The independent implementation uses:

* Chebyshev–Gauss–Lobatto spectral collocation

* A logarithmic independent variable

  $$
  t=\ln x
  $$

* Complex-step numerical Jacobians

* Tikhonov-regularised Newton iteration

* Continuation in spectral resolution

* Continuation in the parameter $A$

The spectral resolution is increased through

$$
N=30\rightarrow60\rightarrow120.
$$

The parameter continuation begins near

$$
A=2.2
$$

and proceeds toward larger values of $A$.

This numerical method is fundamentally different from the four-step Runge–Kutta integration used in Shu (1977).

The purpose is therefore not merely to reproduce the same calculation with the same algorithm, but to perform an **independent cross-code verification**.

---

## Software Requirements

The calculation was developed and tested using:

* GNU Octave **10.3.0**
* VSCodium
* Octave Execution extension for VSCodium

Other reasonably recent GNU Octave versions may also work, but the validated environment is GNU Octave 10.3.0.

---

## How to Run

Open GNU Octave or run the program from VSCodium.

Change to the `code` directory:

```text
cd papers/1977Shu/code
```

Then execute:

```text
shu1977_spectral_octave
```

The program generates the numerical results and validation output described in the accompanying result file.

The principal result file is:

```text
results/shu1977_results_spectral_full.txt
```

---

## Computational Verification Procedure

The independent calculation is compared with the published results in several ways.

### 1. Similarity Profiles

The independently calculated profiles are:

$$
\alpha(x),\qquad v(x),\qquad m(x)
$$

are compared with the corresponding profiles reported by Shu (1977).

### 2. Reduced Core Mass

The calculated values of $m_0$ are compared with the values in Shu's Table 1 over the range

$$
2.2\leq A\leq4.0.
$$

### 3. Expansion-Wave Solution

The limiting expansion-wave solution is compared with Shu's Table 2 over

$$
0.05\leq x\leq1.
$$

The quantities compared are:

* $\alpha(x)$
* $-v(x)$
* $m(x)$

### 4. Critical Point

The solution is explicitly checked at the critical point

$$
x=1.
$$

For the expansion-wave solution, the expected values are

$$
\alpha(1)=2,
$$

$$
v(1)=0,
$$

$$
m(1)=2.
$$

### 5. Spectral Convergence

The independent solution is calculated at increasing spectral resolution:

$$
N=30,\quad60,\quad120.
$$

The stability of the numerical solution under this refinement is used as an independent convergence check.

---

## Computational Verification Results

### Table 1: Reduced Core Mass $m_0$

For the ten tested values of $A$ between 2.2 and 4.0:

| Error measure              |                Result |
| -------------------------- | --------------------: |
| Maximum absolute error     | $1.10\times10^{-2}$ |
| Mean absolute error        | $6.26\times10^{-3}$ |
| RMS error                  | $7.02\times10^{-3}$ |
| Maximum relative error     | $2.93\times10^{-3}$ |
| Maximum relative error (%) |            **0.293%** |
| Mean relative error (%)    |            **0.190%** |

The maximum relative difference is therefore approximately **0.293%**.

This is within the precision implied by the three-significant-figure values printed in the original paper.

---

### Table 2: Expansion-Wave Solution

For $$
0.05\leq x\leq1
$$:

#### Density variable $\alpha(x)$

| Error measure              |                Result |
| -------------------------- | --------------------: |
| Maximum absolute error     | $4.37\times10^{-2}$ |
| Mean absolute error        | $6.67\times10^{-3}$ |
| RMS error                  | $1.27\times10^{-2}$ |
| Maximum relative error     | $3.80\times10^{-3}$ |
| Maximum relative error (%) |            **0.380%** |

#### Velocity $-v(x)$

| Error measure              |                Result |
| -------------------------- | --------------------: |
| Maximum absolute error     | $4.07\times10^{-3}$ |
| Mean absolute error        | $1.24\times10^{-3}$ |
| RMS error                  | $1.99\times10^{-3}$ |
| Maximum relative error     | $6.18\times10^{-3}$ |
| Maximum relative error (%) |            **0.618%** |

#### Reduced mass $m(x)$

| Error measure              |                Result |
| -------------------------- | --------------------: |
| Maximum absolute error     | $4.64\times10^{-3}$ |
| Mean absolute error        | $1.47\times10^{-3}$ |
| RMS error                  | $2.01\times10^{-3}$ |
| Maximum relative error     | $4.42\times10^{-3}$ |
| Maximum relative error (%) |            **0.442%** |

The differences are consistent with the limited numerical precision of the values printed in the original paper.

---

## Critical Point Validation

At the critical point

$$
x=1
$$

the independent solution gives:

| Quantity      | Independent result | Shu (1977) |             Difference |
| ------------- | -----------------: | ---------: | ---------------------: |
| $$
\alpha(1)
$$ |           2.000000 |   2.000000 | $$ -1.6\times10^{-15} $$ |
| $$
-v(1)
$$     |           0.000000 |   0.000000 | $$ -8.2\times10^{-16} $$ |
| $$
m(1)
$$      |           2.000000 |   2.000000 | $$ -3.1\times10^{-15} $$ |

The critical-point conditions are therefore satisfied to approximately machine precision.

---

## Expansion-Wave Core Mass

At the numerical inner boundary

$$
x_{\min}=10^{-3},
$$

the independent calculation gives

$$
m_0=0.975484.
$$

The corresponding value reported by Shu (1977) is approximately

$$
m_0=0.975.
$$

The difference is

$$
\Delta m_0=4.84\times10^{-4}.
$$

Again, the difference is consistent with the significant-figure precision of the published value.

---

## Interpretation of the Differences

The independent spectral calculation produces values that are generally slightly above the tabulated values from Shu (1977).

The independent calculation agrees with the published results within the precision supported by the original tables.

The original paper reports numerical values to approximately three significant figures. Consequently, the printed values necessarily contain rounding and finite numerical-resolution effects.

The independent calculation agrees with the published results within the precision supported by the original tables.

In particular:

* The maximum relative error in Table 1 is **0.293%**.
* The maximum relative errors for the expansion-wave solution are **0.380%**, **0.618%**, and **0.442%** for $$
\alpha
$$, $$
-v
$$, and $$
m
$$, respectively.
* The critical-point conditions agree to approximately $10^{-15}$.
* The independently computed solution is stable under spectral refinement.

The small systematic offset is therefore consistent with differences in numerical method, resolution, and the limited significant figures reported in the original publication.

---

## Convergence

The spectral solver was evaluated using

$$
N=30,\quad60,\quad120.
$$

The Newton solver required approximately 2–4 iterations at each continuation stage.

Increasing the spectral resolution from $N=30$ to $60$ to $120$ produces only changes at the level expected from the numerical convergence tolerance, indicating stable refinement of the computed solution.

No anomalous behavior was observed away from the expected numerical difficulty associated with the critical point.

The convergence study therefore provides an additional numerical check independent of the comparison with the published tables.

---

## Verification Verdict

### PASS

The implementation of the Chebyshev–Gauss–Lobatto spectral method reproduces the similarity solutions of Shu (1977) to within the precision supported by the published numerical results.

The agreement is obtained using a numerical method fundamentally different from the
four-step Runge–Kutta procedure described in the original paper.

| Verification criterion | Assessment |
|---|---|
| Numerical agreement | **PASS** |
| Physical behavior | **PRESERVED** |
| Scientific conclusion | **PRESERVED** |
| Discrepancy impact | **NEGLIGIBLE** |
| Primary discrepancy source | **Numerical method / published rounding** |
| Overall verdict | **PASS** |

The principal quantitative results are:

- **Table 1 maximum relative error:** 0.293%
- **Table 1 mean relative error:** 0.190%
- **Expansion-wave maximum relative error in density:** 0.380%
- **Expansion-wave maximum relative error in velocity:** 0.618%
- **Expansion-wave maximum relative error in reduced mass:** 0.442%
- **Critical-point agreement:** approximately $10^{-15}$
- **Spectral convergence:** confirmed for

$$
N=30,60,120
$$

The numerical discrepancies are small relative to the precision of the published tabulated
values and do not alter the physical argument or scientific conclusion withdrawn from the
computed solutions.

These results support the conclusion that the numerical solutions reported by
Shu (1977) can be independently reproduced and computationally verified using a different
numerical approach.

---

## Reproducibility

To reproduce this validation:

1. Obtain this repository.

2. Install GNU Octave 10.3.0 or a compatible version.

3. Open the directory:

   ```text
   papers/1977Shu/code
   ```

4. Run:

   ```text
   shu1977_spectral_octave
   ```

5. Compare the generated results with:

   ```text
   results/shu1977_results_spectral_full.txt
   ```

The source code and numerical validation results are provided together so that the calculation can be independently inspected and rerun.

---

## Reference

Shu, F. H. (1977).

**Self-Similar Collapse of Isothermal Spheres and Star Formation.**

*The Astrophysical Journal*, **214**, 488–497.

DOI: [10.1086/155274](https://doi.org/10.1086/155274)

ADS:
https://ui.adsabs.harvard.edu/abs/1977ApJ...214..488S/abstract

Full text:
https://ui.adsabs.harvard.edu/link_gateway/1977ApJ...214..488S/ADS_PDF

