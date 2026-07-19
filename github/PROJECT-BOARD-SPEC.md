# GitHub Project board specification

## Project

- Organization: AtyaLibraries
- Name: AtyaLibraries Ecosystem Modernization
- Planning repository: AtyaLibraries/Atya.Roadmap
- Planning-repository bootstrap: required before issue import; this approved infrastructure step is external to the ATYA graph and does not affect Ready/Blocked status.
- Scope: all 131 ATYA tasks; no remote resources were created by this architecture resolution.

Phases are thematic planning and reporting groups. Phase completion gates are non-blocking reporting milestones. The hard-dependency graph is authoritative for execution order, including valid cross-phase edges.

## Fields

| Field | Type | Values / rule |
|---|---|---|
| ATYA ID | Text | Immutable ATYA-xxx |
| Status | Single select | Backlog, Ready, In progress, In review, Blocked, Done, Deferred, Rejected |
| Priority | Single select | P0, P1, P2, P3 |
| Phase | Single select | 0 through 8 using milestone names; reporting only |
| Type | Single select | ADR, Audit, Cleanup, Documentation, Implementation, Migration, Verification |
| Repository | Text | Final issue owner under the primary-contract ownership policy |
| Primary contract owner | Text | Populated for the ten focused ownership reviews |
| Downstream repositories | Text | Semicolon-delimited repositories or managed-repository group |
| Child migration requirement | Single select | none-tightly-coupled, required-existing, required-on-confirmed-gap |
| Child migration tasks | Text | Semicolon-delimited owning-repository ATYA IDs |
| Evidence status | Single select | Verified, Partially verified, Requires verification, Refuted |
| Confidence | Single select | High, Medium, Low |
| Risk | Single select | Critical, High, Medium, Low |
| Effort | Single select | S, M, L |
| Hard dependencies | Text | Semicolon-delimited ATYA IDs; these alone block execution |
| Advisory prerequisites | Text | Semicolon-delimited ATYA IDs; nonblocking and caveat-bypassable |
| Source origin | Text | SOL/Fable/cross-review/new requirement |

## Ownership policy

- Organization-wide architecture, governance, inventory, release policy, cleanup coordination, and shared policy issues belong to Atya.Roadmap.
- Package-led implementation belongs to the repository that owns the primary public contract or implementation.
- Multi-repository reach alone never changes ownership.
- A downstream migration remains in the parent issue only when it is an inseparable part of one acceptance transaction. Otherwise it is a separate child issue in its owning repository.
- ATYA-028 creates per-repository children only after read-only verification confirms a gap.

## Views

1. **Execution board** — group by Status, filter out Deferred/Rejected, sort Priority then Phase then ATYA ID.
2. **Phase reporting** — table grouped by Phase, showing hard-dependency readiness and non-blocking milestone progress.
3. **Critical path** — P0/P1 items and all transitive hard prerequisites.
4. **Repository queue** — group by Repository; package implementers see only their standalone issues.
5. **Advisory-input view** — items with Advisory prerequisites, with caveat/approval evidence visible.
6. **Evidence queue** — Evidence status = Requires verification or Partially verified.
7. **Cleanup safety** — ATYA-090 through ATYA-110 with hard audit dependencies visible.
8. **Decisions** — Type = ADR, ordered by hard dependencies rather than phase number.
9. **Ownership migrations** — focused ownership rows with downstream repositories and child tasks.

## Automation rules

- New imported items start Ready only when Hard dependencies is empty; advisory prerequisites never change initial or subsequent status.
- When every hard dependency is Done, move Blocked to Ready; never do this if evidence remains Refuted.
- An advisory prerequisite may be bypassed only when the issue records the missing evidence, risk, approver, accepted caveat, and follow-up.
- Phase or milestone state must never move a task to Ready or Blocked.
- A PR linked to an ATYA issue moves it to In progress/In review; merge does not mark Done until acceptance evidence is attached.
- Deferred and Rejected require a decision-register link and reason.
- Cleanup action tasks cannot enter In progress until every hard audit dependency is Done and approved; advisory evidence never satisfies cleanup ancestry.

## Import order

0. Run the validator against the local artifacts and require a passing result.
1. Create the approved `AtyaLibraries/Atya.Roadmap` repository. This is the only pre-import bootstrap and is not performed by this plan-resolution task.
2. Create labels and non-blocking reporting milestones from JSON.
3. Create Atya.Roadmap organization-wide issues and package-specific issues from `github/issues` in their declared owners.
4. Add all 124 issues to the organization project.
5. Populate fields from `PROJECT-ITEMS.csv`, preserving separate Hard dependencies and Advisory prerequisites values.
6. Re-run the validator, then spot-check ATYA-019/124, ATYA-031/121, ATYA-057/122, ATYA-075, and ATYA-084/123.

No GitHub repository, issue, label, milestone, or Project is created by this specification itself.


## Public evidence boundary

Private audit-finding identifiers and raw evidence fields are intentionally excluded. Implementation State may be published as a high-level planning classification, but it never changes workflow status.
