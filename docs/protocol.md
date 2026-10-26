

\# Verification Protocol



We evaluate computational reproductions through a sequence of evidence-building stages. These stages describe the maturity of the available evidence; they do not automatically guarantee scientific correctness.



\## 1. Submitted



A reproduction record has been submitted with a scientific reference, a description of the target result, and the available code or data.



\## 2. Execution checked



The documented code has been executed in a recorded environment. Dependencies, configuration, and relevant output are documented.



Successful execution establishes that the code ran under the stated conditions. It does not establish that the implementation is scientifically correct.



\## 3. Numerically cross-checked



Results have been compared with a reference value, published data, or an independent implementation.



The comparison should specify:



\- Which quantities were compared.

\- The absolute or relative error, where meaningful.

\- Numerical tolerances and convergence tests.

\- Whether the comparison uses identical equations, independent formulations, or different numerical methods.



\## 4. Independently reviewed



A reviewer has examined the scientific formulation, implementation, numerical evidence, and stated limitations. The record should identify the scope of the review.



\## Verification verdict



The workflow stage and the scientific verdict are separate.



A record may conclude that a result is reproduced within stated tolerances, partially reproduced, inconsistent with the reference, or still inconclusive.



\## Evidence we expect



Each benchmark should document, where applicable:



\- The original publication and exact target result.

\- Governing equations and assumptions.

\- Code version and execution instructions.

\- Software environment and numerical parameters.

\- Raw outputs or reproducible summaries.

\- Error metrics and convergence evidence.

\- Differences from the original method.

\- Known limitations and unresolved questions.



\## Independence matters



Agreement between two programs is stronger evidence when they differ meaningfully in their implementation or numerical approach. Two programs can still share the same mistaken equation, assumption, or interpretation.



We therefore document the nature of each comparison rather than treating agreement alone as proof.
