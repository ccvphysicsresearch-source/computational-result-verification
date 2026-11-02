# Platform Blueprint

**Status:** Working blueprint  
**Development branch:** `platform-blueprint`  
**Purpose:** Describe the platform's mission, conceptual architecture, community workflow, scientific standards, and staged implementation plan.

This document consolidates the platform decisions made during the blueprint-design discussions. It is a product and architecture guide, not a substitute for the detailed [Verification Protocol](protocol.md), [Verification Record Standard](verification-record-standard.md), JSON Schema, or record template.

## 1. Vision and mission

The platform is a community-driven environment for reproducing, comparing, discussing, and improving computational results reported in scientific research.

It should make scientific computational claims easier to examine by connecting:

- A specific published result.
- One or more clearly defined numerical targets.
- Original and independently developed implementations.
- Reproducible executions and supporting evidence.
- Reference data and comparison criteria.
- Community discussion and formal assessments.
- A transparent history of revisions, disagreements, and limitations.

**Guiding principle: Review to improve, not merely to criticize. Scientific rigor with constructive collaboration.**

The platform welcomes contributions from researchers, students, numerical analysts, software engineers, independent scientists, and other interested participants. Institutional affiliation or formal academic credentials must not be the sole measure of contribution quality.

## 2. Core principles

1. **Evidence before claims.** Every verification claim should be traceable to identifiable code, data, execution, comparison, and reasoning.
2. **Specific scope.** Verification applies to stated numerical targets and checks, not automatically to an entire paper or all its conclusions.
3. **Independence is disclosed, not assumed.** Different software or algorithm names do not by themselves establish independent implementations or independent scientific validation.
4. **Published and reproduced results are distinct.** A published value, a contributor's computed value, a cross-check between implementations, and an assessment conclusion must never be conflated.
5. **Criteria before comparison.** Acceptance criteria should be documented before execution and comparison whenever practical. Revisions require a scientific justification and preserved history.
6. **Uncertainty is preserved honestly.** Record available uncertainty information; do not invent missing values or impose a universal uncertainty-propagation procedure.
7. **Openness with attribution and respect for rights.** Preserve provenance and respect licenses, copyright, privacy, and applicable data restrictions.
8. **Constructive scientific exchange.** Community members and reviewers should explain concerns and offer actionable improvements. Disagreement may remain unresolved.
9. **Preserve the record.** Revisions and withdrawals should not silently erase prior evidence, assessments, or discussion.
10. **Automation supports, not replaces, scientific judgment.** Structural validation and computational tools do not establish scientific correctness.

## 3. Conceptual data model

The platform should organize information around the following entities. The first six are the scientific core; community features connect participants to that core.

### 3.1 Scientific entities

1. **Publication** — The paper or other citable scholarly source.
2. **Computational Result** — The overall result or scientific claim in the publication that contributors are investigating.
3. **Numerical Target** — A specific value, profile, curve, table, equation-derived quantity, computational behavior, or other testable target within a Computational Result.
4. **Implementation** — A documented code implementation or computational method intended to reproduce or test one or more targets.
5. **Execution** — A particular run of an implementation, tied to an exact code revision, environment, inputs, parameters, command, date, outcome, and outputs.
6. **Evidence** — An individually identifiable artifact supporting a claim or assessment, linked to the relevant execution, target, or reference.

### 3.2 Assessment and community entities

7. **Verification Assessment** — An attributable scientific assessment identifying its outcome, assessor, scope, implementations and evidence examined, reasoning, and date.
8. **User / Contributor** — A stable platform identity with a public profile and privacy controls.
9. **Team** — A group of contributors with attributed roles and responsibilities.
10. **Discussion Thread and Message** — Community exchanges linked to a publication, result, target, implementation, execution, evidence item, or assessment.
11. **Knowledge Base Entry** — A reusable explanation of a resolved or important technical issue, linked to its originating discussion and evidence.
12. **Acknowledgement / Notification** — Recognition of useful contributions and user-controlled notices about relevant activity.

A Computational Result may contain multiple Numerical Targets. Each target has its own reference basis, criteria, implementations, evidence, completeness, agreement state, and assessment history. This prevents one successfully checked quantity from making an entire paper appear verified.

## 4. Results, references, and comparison

### 4.1 Keep four result concepts separate

For every Numerical Target, distinguish:

- **Published reference:** What the original paper or its supplementary material reports.
- **Independent reproduction:** What a contributor's implementation calculates.
- **Cross-verification result:** The comparison between two or more implementations or methods.
- **Assessment conclusion:** The scientific interpretation supported by the examined evidence.

These can differ. Agreement between independent implementations is useful evidence of numerical consistency, but it does not automatically prove agreement with the publication or correctness of a shared model or formulation.

### 4.2 Reference-data availability

The platform must not exclude a paper merely because it lacks machine-readable numerical values. Permitted comparison bases may include:

- Numerical values or tables reported in the publication.
- Author-provided supplementary or external datasets.
- Data extracted from published figures.
- Experimental or observational datasets from documented sources.
- Analytical solutions, known limiting cases, or established physical relations.
- Independently calculated reference values.
- Comparisons between independent implementations, clearly labeled as cross-checks rather than proof of agreement with the publication.
- Physical and mathematical consistency checks.

The record must identify which basis is used and explain its limitations. If no adequate reference is available, the comparison must be described as limited or inconclusive as appropriate.

### 4.3 Reference type and acquisition method

Record two separate classifications:

**Underlying reference type**
- Experimental.
- Observational.
- Theoretical.
- Numerical.
- Other, with explanation.

**Data acquisition or provenance**
- Explicitly reported in the paper.
- Author-provided dataset or supplementary material.
- Third-party dataset or publication.
- Digitized from a published figure.
- Independently calculated or derived.
- Other, with explanation.

A dataset can combine categories, but each component must be identifiable. For example, points digitized from a plot of astronomical measurements remain observational in origin and are digitized in acquisition method.

### 4.4 Digitized figure data

Digitized datasets are first-class, independently identifiable reference objects. Multiple contributors may digitize the same figure separately; their datasets must remain separate so extraction variability can be examined rather than hidden by premature merging.

For every digitization, record as applicable:

- Original publication, figure number, page, and source location.
- Contributor and date.
- Digitization software/tool and version.
- Extraction procedure and relevant settings.
- Axis calibration, units, ranges, and linear/logarithmic transformations.
- Curve or series identification and extraction range.
- Number and spacing of extracted points.
- Manual corrections, ambiguous regions, and overlapping curves.
- Estimated extraction uncertainty and image-resolution limitations.
- Resulting machine-readable coordinates and dataset revision.

Contributors must clearly distinguish author-provided numerical values from values digitized by themselves or others. The platform should avoid unauthorized copying or redistribution of copyrighted figure images. Prefer citation and figure identification, preservation of extracted coordinates and metadata, and newly generated plots from the extracted data. Contributors must respect applicable copyright, license, and permission requirements.

A built-in digitization tool is a possible future feature, not an MVP requirement. Initially, contributors may use external tools and submit machine-readable data plus provenance. The platform should remain tool-neutral. No single digitization tool should be treated as authoritative; independent extraction with different tools or procedures can be useful for cross-checking. Any future built-in tool should be benchmarked against known data and compared with established tools before strong accuracy claims are made.

## 5. Criteria, uncertainty, and numerical tests

### 5.1 Acceptance criteria

Each Numerical Target should define problem-appropriate comparison criteria, including where relevant:

- Compared quantity, domain, and units.
- Comparison metric and alignment/interpolation procedure.
- Acceptance tolerance or qualitative criterion.
- Reference precision, rounding, and limitations.
- Scientific or numerical justification.
- Additional physical or mathematical checks.

Contributors propose criteria and justify them; assessors evaluate and may challenge them. Criteria should be established before execution and comparison whenever practical, to reduce post hoc tolerance selection. If new scientific information justifies changing criteria, preserve the original criteria, revised criteria, dates, and reasons. Assessments should identify which criteria were applied.

There is no universal tolerance suitable for every scientific problem.

### 5.2 Uncertainty information

Record as much uncertainty information as is available, preserving its source, meaning, units, and original form. Examples include statistical and systematic uncertainty, confidence intervals, measurement or observational error, numerical truncation or approximation error, and digitization or image-resolution uncertainty.

If information is missing, use explicit statuses such as `Unknown` or `Not reported`; never invent an estimate. Preserve correlations or covariance information when reported and relevant.

Uncertainty propagation is optional and problem-dependent. Contributors decide whether it is appropriate and document the method, assumptions, equations, and inputs if performed. Assessors evaluate the scientific adequacy of the analysis. The platform must not automatically impose a universal propagation formula or simplify expert analysis into an unqualified automated number.

### 5.3 Additional numerical tests

Assessors may request problem-specific tests, including grid or timestep refinement, convergence studies, sensitivity to initial or boundary conditions, alternative solvers, conservation-law checks, and analytical limiting-case comparisons.

Contributors may challenge or decline a request with a reasoned explanation if it is unnecessary, impractical, or scientifically unsuitable. Requests, responses, supporting evidence, and resolution should be preserved. The appropriate tests depend on the target and method.

## 6. Implementation, execution, and independence

### 6.1 Independence declaration

Every implementation declares one of the following:

- **Fully independent:** Independently developed code without shared implementation code.
- **Partially independent:** Some shared, adapted, or reused components, but meaningful independent implementation remains.
- **Not independent:** Substantially derived from or directly reuses another implementation.

Contributors disclose code origins, shared components, dependencies, and relevant assistance. Assessors evaluate whether the declaration is justified. Independent coding does not imply independent methodology: implementations may share equations, assumptions, initial or boundary conditions, data, or post-processing.

### 6.2 Execution record

Each execution should identify:

1. Exact implementation revision or Git commit.
2. Operating system, language, compiler/interpreter, dependencies, and relevant versions.
3. Execution command or procedure.
4. Input data and parameters.
5. Execution date.
6. Outcome: success, failure, or incomplete.
7. Output references, including relevant logs and numerical results.

Additional information may be included when useful. Preserve failed runs and manual interventions when relevant.

### 6.3 Evidence

Evidence is individually identifiable and linked to the execution, target, reference, or assessment it supports. Each item should have an evidence ID, type, location or repository reference, description, and optional metadata/status. Raw outputs should be distinguished from derived summaries and manually transcribed values.

## 7. Verification workflow and status dimensions

Do not collapse administrative state, technical progress, completeness, scientific agreement, and assessment outcome into one status.

### 7.1 Technical workflow stages

The record-level workflow stages are:

1. `submitted`
2. `execution_checked`
3. `numerically_cross_checked`
4. `independently_reviewed`

These describe the checks documented so far. Reaching a stage does not automatically prove scientific correctness.

### 7.2 Record lifecycle

Record lifecycle is separate from technical progress. The intended lifecycle concepts are:

- Draft.
- Published/submitted.
- Superseded.
- Withdrawn.
- Archived.

The current schema may implement only a subset; schema and policy must be kept aligned as the model evolves. Revisions should preserve stable record identity and historical versions.

### 7.3 Computational Result status

The platform-level status for a Computational Result may be:

- Not yet submitted.
- In verification.
- Partially verified.
- Verification completed.
- Disputed.
- Archived.

The platform may suggest a status based on documented target-level progress. A moderator may correct it with an explanation and preserved history. Automated status calculation is administrative assistance, not AI scientific judgment.

### 7.4 Target-level completeness and agreement

Each Numerical Target has separate dimensions:

**Verification completeness**
- Not started.
- In progress.
- Substantially complete.
- Complete.

**Scientific agreement**
- Agreement.
- Agreement with limitations.
- Disagreement.
- Inconclusive.
- Not yet established.

A target may be completely examined while disagreement remains. Completeness must not be mistaken for agreement.

### 7.5 Assessment outcomes

A Verification Assessment records its own scientific outcome and scope. Multiple assessments are allowed and preserved; a new assessment must not overwrite an earlier one. Distinguish community assessment from any separately designated expert endorsement. Expertise disclosure is required for assessors, but formal credentials are not a prerequisite for participation.

## 8. Community discussion and formal review

### 8.1 Community discussion before formal review

After submission, a record enters an open community-discussion period before or alongside formal review. The initial proposed default minimum discussion period is 14 days; this is a configurable policy starting point, not a permanent scientific rule.

- Community members and interested participants may ask questions, examine evidence, identify problems, and suggest improvements.
- Formal review may begin earlier if a reviewer is available and the contributor agrees.
- If no reviewer is available after the minimum period, community discussion may continue; the submission should not be artificially closed merely because reviewers are scarce.
- Community discussion does not count as formal verification or scientific endorsement.

This design recognizes that AI-assisted workflows may increase submission volume faster than reviewer capacity. Community participation can surface issues early and help reviewers focus on unresolved questions, but popularity or comment volume is not evidence of correctness.

### 8.2 Constructive review cycle

The intended cycle is:

1. Contributor submits work.
2. Community discussion period begins.
3. Reviewer examines the submission and discussion.
4. Reviewer provides evidence-based comments and actionable improvement suggestions.
5. Contributor responds with explanations, corrections, additional tests, or evidence.
6. Reviewer reassesses the revised work.
7. Further discussion or revision occurs when needed.
8. Assessment and unresolved disagreements are recorded.

Reviewers should explain what is problematic, why it matters, and how it might be improved whenever possible. Feedback must address the work rather than personal ability, background, or institutional prestige. Contributors may ask questions, disagree, and challenge requested tests. Fundamental failures to meet basic scientific standards may justify returning or rejecting work, but reasons must be explained.

Community discussion, formal review, and scientific assessment are distinct activities. Consensus is not mandatory; scientifically justified disagreement may be preserved.

### 8.3 Discussion lifecycle and resolution

Discussion threads may be Open, Resolved, Unresolved, or Closed. Closing a discussion does not imply scientific consensus. Any participant may propose a resolution; the original author may confirm it, or a moderator may decide an administrative status when necessary. Moderators manage process and conduct, not scientific truth.

Resolved technical discussions may be turned into searchable knowledge-base entries linked to the original discussion, record, and evidence. Entries can be corrected as new evidence emerges.

## 9. Participants, teams, privacy, and collaboration

### 9.1 Profiles and attribution

Profiles may include display name or pseudonym, optional affiliation, expertise/interests, optional ORCID or other research identifier, optional GitHub/professional links, and contribution/assessment history.

Real names and pseudonyms are both allowed. Stable account identity supports attribution over time. Users control visibility of profile fields and may change settings. Private account details must not appear in public records.

### 9.2 Teams and shared work

Both individual and team contributions are supported. Teams may include researchers, numerical analysts, software engineers, data specialists, and reviewers. Attribute individual roles and responsibilities.

Initial team roles:
- Owner.
- Administrator.
- Contributor.
- Reviewer.
- Observer.

Members may hold multiple roles. Multiple teams may collaborate on a target or Computational Result while retaining attribution and responsibility for their own implementations. A shared workspace per Computational Result can organize objectives, teams, implementations, executions, evidence, discussions, and assessments.

Workspace statuses: Proposed, Active, Paused, Completed, Archived. Completion means planned work has concluded, not that the scientific result is proven.

### 9.3 Recognition and acknowledgements

Recognize quality and usefulness: independent implementations, careful assessments, error identification, helpful discussions, knowledge-base contributions, and improvements to reproducibility. Quality should outweigh quantity or popularity. No single score should define scientific standing. Recognition is not proof of correctness or expert endorsement.

Structured acknowledgements may identify specific contributions and link them to the relevant work, without implying that the acknowledged result is correct.

### 9.4 Notifications

Users control notification preferences, including category-level opt-in/out and optional email notices. Possible events include replies and mentions, questions, review feedback, assessment updates, revisions, discussion activity, and knowledge-base corrections.

## 10. Revisions, withdrawal, and preservation

The governing principle is **preservation before withdrawal; revision before removal**.

- Keep a stable identity for an implementation and create immutable revisions.
- Preserve prior code revisions, executions, evidence, discussions, and assessments.
- Record revision ID, date, class, change description, code commit, and reason.
- **Major revision:** Main numerical results change; reassess affected targets fully.
- **Moderate revision:** Main results remain unchanged, but convergence studies, error estimates, accuracy analyses, or supporting conclusions change; reassess affected analyses.
- **Minor revision:** Nonessential wording, formatting, or documentation changes; reassessment is normally unnecessary.
- Withdrawal marks an implementation or record as withdrawn with an optional reason; it does not silently erase the historical scientific record.
- Privacy, legal, or safety deletion requests are distinct from ordinary scientific withdrawal and must be handled under applicable policies.

## 11. Governance and moderation

Governance should support openness, fairness, traceability, and safe participation without creating unnecessary barriers before a real community exists.

- Moderators enforce process, privacy, attribution, and conduct rules; they do not decide scientific truth by authority.
- Administrative status changes and overrides require explanations and preserved history.
- Expertise is disclosed transparently; credentials may inform context but do not replace evaluation of methods, code, evidence, and reasoning.
- Conflicts of interest and relevant relationships should be disclosed where applicable.
- Multiple assessments and reasoned disagreements remain visible.
- Detailed governance should evolve through experience with real contributors and reviewers rather than delaying the MVP.

## 12. MVP scope and deferred capabilities

### 12.1 MVP priorities

The first working version should concentrate on a reliable scientific record and a small end-to-end workflow:

1. Publication and Computational Result identification.
2. One or more Numerical Targets with reference descriptions and target-specific criteria.
3. Implementation records, independence declarations, and exact code revisions.
4. Execution records and linked evidence artifacts.
5. Clear distinction between published references, computed results, cross-checks, and assessments.
6. Basic reference provenance and uncertainty fields.
7. Submission status and a simple community-discussion mechanism.
8. Constructive reviewer comments, contributor responses, and preserved assessment history.
9. Revision history and transparent limitations.
10. Machine validation of record structure, while clearly stating that validation does not prove scientific correctness.

The Shu (1977) case is the first worked example. Its ODE45 and higher-order Taylor comparison is a useful numerical cross-check, but the record must retain its stated scope and limitations. It must not imply that all results or conclusions in the paper have been independently verified.

### 12.2 Defer until the core workflow is proven

The following are future capabilities, not prerequisites for the first MVP:

- Built-in figure-digitization software.
- Automated or universal uncertainty propagation.
- AI-generated scientific verdicts or automatic reviewer replacement.
- Complex reputation scores or credential hierarchies.
- Highly granular team permissions.
- Large-scale notification automation.
- Advanced analytics and cross-paper knowledge graphs.
- Sophisticated dispute arbitration and governance machinery.

External digitization tools and manually documented workflows can be used initially. AI may assist with extraction, documentation, testing, or navigation later, but its role and outputs must be disclosed and remain subject to human scientific evaluation.

## 13. Development roadmap

1. **Consolidate the blueprint and data model.** Align the conceptual entities with the current record template and JSON Schema.
2. **Complete the Shu example.** Ensure its publication, targets, implementations, executions, evidence, criteria, and limitations are represented accurately.
3. **Build submission and validation.** Improve templates, schemas, examples, and automated structural tests.
4. **Build discussion and review workflow.** Start with a lightweight, traceable community discussion and assessment process.
5. **Build the website MVP.** Provide browsing, record pages, submissions, and discussion.
6. **Introduce AI assistance carefully.** Support contributors and reviewers without replacing scientific judgment.
7. **Pilot with external contributors.** Use actual experience to refine governance, usability, and reviewer capacity.

## 14. Relationship to existing repository documents

This blueprint is the high-level product and architecture guide.

- [Verification Protocol](protocol.md): technical workflow stages and scientific verdicts.
- [Verification Record Standard](verification-record-standard.md): minimum record content and evidence requirements.
- [Verification Record Template](../VERIFICATION_RECORD_TEMPLATE.md): human-readable record structure.
- [JSON Schema](../schemas/verification-record.schema.json): machine-checkable record structure.
- [Contribution Guide](contribute.md): practical contributor instructions.
- [Shu (1977) benchmark](shu1977.md): first worked scientific example.

These documents must be kept consistent. When policy requirements are not yet represented in the schema or tests, identify the gap explicitly rather than implying that automated validation enforces the policy.

## 15. Decision history and change control

This blueprint consolidates the platform decisions discussed through Decision 56. The decision history is a design record, not a claim that every proposed feature has already been implemented.

When the blueprint changes:
- Record the date and nature of substantive changes.
- Explain whether a change affects the data model, workflow, scientific policy, or MVP scope.
- Update related protocol, schema, tests, and examples deliberately.
- Preserve prior record versions and migration considerations.
- Prefer small, reviewable changes over broad rewrites.

**Current priority:** implement a small, dependable end-to-end verification workflow before expanding advanced community and automation features.
