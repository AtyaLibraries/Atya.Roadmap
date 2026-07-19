# ATYA-124 — Correct and fixture-test platform drift SHA validation

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-124 |
| Owning repository | platform |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-019 |
| Advisory prerequisites | None |
| Confidence | High |
| Risk | High |
| Effort | M |

## Public remediation summary

This issue tracks **Correct and fixture-test platform drift SHA validation**. Only the minimum public coordination information is included here. Verified details, affected trust-boundary evidence, and any reproduction material are retained privately by organization maintainers.

Private evidence reference: AUDIT-SEC-124

## Required outcome

- Complete the named remediation without expanding scope beyond this ATYA task.
- Apply least privilege and preserve the approved ownership and dependency boundaries.
- Add regression, negative, and boundary coverage that proves the remediation without publishing exploitable details.
- Attach sanitized acceptance evidence suitable for public review; keep sensitive evidence in the approved private channel.

## Dependencies

Hard dependencies: ATYA-019

Advisory prerequisites: None

## Related tasks

- ATYA-026
- ATYA-028
- ATYA-039

## Implementation guidance

1. Obtain the private evidence from an authorized maintainer before changing the affected trust boundary.
2. Confirm current live state and avoid copying sensitive diagnostics into public logs, pull requests, or issue comments.
3. Implement the smallest dependency-ordered remediation in **platform**.
4. Add non-disclosing automated coverage and document compatibility, migration, and rollback behavior.
5. Record sanitized evidence publicly and retain detailed verification privately.

## Acceptance criteria

- The remediation described by the issue title is implemented in the owning repository.
- Regression coverage demonstrates the intended security property without exposing a working exploit or credential detail.
- Compatibility, migration, and rollback implications are documented.
- Public evidence is sanitized and the private evidence reference is updated by maintainers.
- No unresolved high-severity regression remains in the affected scope.

## Standalone implementation prompt

Implement ATYA-124 for the AtyaLibraries ecosystem in repository **platform**. Respect hard dependencies (ATYA-019), obtain AUDIT-SEC-124 through the private maintainer channel, and do not publish private evidence, credentials, logs, or exploit reproduction. Make a focused change with tests, migration notes, rollback guidance, and sanitized completion evidence.
