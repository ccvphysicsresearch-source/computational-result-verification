---
title: Home
hide:
  - navigation
  - toc
---

<div class="sr-hero">
  <div class="sr-hero-copy">
    <div class="sr-eyebrow">OPEN SCIENCE · COMMUNITY-DRIVEN VERIFICATION</div>

    <h1>Help verify published scientific results.</h1>

    <p>Scientific findings deserve independent computational checks. We make the code, numerical comparisons, and evidence behind published results easier to examine.</p>

    <p><strong>Contribute an independent implementation, compare results, or review the evidence.</strong></p>

    <div class="sr-hero-actions">
      <a href="shu1977.md" class="md-button md-button--primary">Explore benchmarks</a>
      <a href="protocol.md" class="md-button">Read our protocol</a>
    </div>
  </div>

  <div class="sr-hero-visual">
    <div class="sr-visual-label">HOW IT WORKS</div>

    <div class="sr-workflow-item">
      <span class="sr-workflow-icon">01</span>
      <div>
        <strong>Identify a result</strong>
        <p>Choose a specific published claim that can be tested computationally.</p>
      </div>
    </div>

    <div class="sr-workflow-connector"></div>

    <div class="sr-workflow-item">
      <span class="sr-workflow-icon">02</span>
      <div>
        <strong>Reproduce and compare</strong>
        <p>Implement the method independently and compare numerical results.</p>
      </div>
    </div>

    <div class="sr-workflow-connector"></div>

    <div class="sr-workflow-item">
      <span class="sr-workflow-icon">03</span>
      <div>
        <strong>Share the evidence</strong>
        <p>Publish code, settings, convergence tests, and discrepancies for review.</p>
      </div>
    </div>
  </div>
</div>
---

## Explore the platform

<div class="grid cards" markdown>

-   **Research fields**

    Browse scientific disciplines and specialized research topics.

-   **Papers**

    Find published papers and the results contributors are investigating.

-   **Verification records**

    Examine numerical comparisons, methods, evidence, and limitations.

-   **Contribute**

    Submit an implementation, reproduce a result, or review existing work.

</div>

## Featured verification

<div class="sr-feature" markdown>

<div class="sr-feature-label">FIRST NUMERICAL BENCHMARK</div>

### Shu (1977) — Self-similar isothermal gas dynamics

How reliably can we reproduce the numerical solutions associated with Shu's classic study of isothermal gas-cloud collapse?

Our benchmark compares two numerical approaches:

- **ODE45:** adaptive Runge–Kutta integration.
- **Higher-order Taylor series:** an independent integration approach based on local Taylor expansions.

The comparison examines the similarity profiles and derived mass, alongside numerical errors, convergence behavior, and methodological limitations.

**Our goal is not simply to match a number.** It is to document how the result was obtained, how independent calculations agree, and what the available evidence does—and does not—establish.

[Explore the Shu benchmark →](shu1977.md)

</div>

## What makes a verification record useful?

- **Transparent methods:** equations, algorithms, and implementation details.
- **Quantitative evidence:** errors, tolerances, comparisons, and convergence tests.
- **Reproducible execution:** code, configurations, and instructions.
- **Honest limitations:** unresolved discrepancies and missing information are explicitly documented.

[Read the verification protocol →](protocol.md)
