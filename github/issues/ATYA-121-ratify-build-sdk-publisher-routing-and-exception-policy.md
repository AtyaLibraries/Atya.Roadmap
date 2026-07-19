# ATYA-121 — Ratify Build.Sdk publisher routing and release-recovery policy

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-121 |
| Owning repository | Atya.Roadmap |
| Priority | P0 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-016; ATYA-020; ATYA-036 |
| Advisory prerequisites | None |
| Confidence | High |
| Risk | Critical |
| Effort | M |

## Public remediation summary

This issue tracks **Ratify Build.Sdk publisher routing and release-recovery policy**. Only the minimum public coordination information is included here. Verified details, affected trust-boundary evidence, and any reproduction material are retained privately by organization maintainers.

Private evidence reference: AUDIT-SEC-121

## Required outcome

- Complete the named remediation without expanding scope beyond this ATYA task.
- Apply least privilege and preserve the approved ownership and dependency boundaries.
- Add regression, negative, and boundary coverage that proves the remediation without publishing exploitable details.
- Attach sanitized acceptance evidence suitable for public review; keep sensitive evidence in the approved private channel.

## Dependencies

Hard dependencies: ATYA-016; ATYA-020; ATYA-036

Advisory prerequisites: None

## Related tasks

- ATYA-031
- ATYA-018
- ATYA-024

## Implementation guidance

1. Obtain the private evidence from an authorized maintainer before changing the affected trust boundary.
2. Confirm current live state and avoid copying sensitive diagnostics into public logs, pull requests, or issue comments.
3. Implement the smallest dependency-ordered remediation in **Atya.Roadmap**.
4. Add non-disclosing automated coverage and document compatibility, migration, and rollback behavior.
5. Record sanitized evidence publicly and retain detailed verification privately.

## Acceptance criteria

- The remediation described by the issue title is implemented in the owning repository.
- Regression coverage demonstrates the intended security property without exposing a working exploit or credential detail.
- Compatibility, migration, and rollback implications are documented.
- Public evidence is sanitized and the private evidence reference is updated by maintainers.
- No unresolved high-severity regression remains in the affected scope.

## Standalone implementation prompt

Implement ATYA-121 for the AtyaLibraries ecosystem in repository **Atya.Roadmap**. Respect hard dependencies (ATYA-016; ATYA-020; ATYA-036), obtain AUDIT-SEC-121 through the private maintainer channel, and do not publish private evidence, credentials, logs, or exploit reproduction. Make a focused change with tests, migration notes, rollback guidance, and sanitized completion evidence.
