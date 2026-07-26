# ATYA-149 — Deploy the GitHub App dispatch broker and retire the PAT

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-149 |
| Owning repository | platform |
| Priority | P0 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Migration |
| Initial status | Blocked |
| Hard dependencies | ATYA-024 |
| Advisory prerequisites | None |
| Confidence | High |
| Risk | Critical |
| Effort | L |

## Public remediation summary

This issue tracks **Deploy the GitHub App dispatch broker and retire the PAT**. Only the minimum public coordination information is included here. Verified details, affected trust-boundary evidence, and any reproduction material are retained privately by organization maintainers.

Private evidence reference: AUDIT-SEC-024 — see `reports/EVIDENCE-CAVEAT-LEDGER.md`, CAVEAT-001. This identifier is a sanitization placeholder, not a retrievable document.

## Maintainer gate — this task cannot start on its own

ATYA-149 is gated on infrastructure decisions that only the maintainer can supply. It is **not agent-executable end to end**. Seven inputs remain unconfirmed and every one of them must be provided before the first provisioning step:

- Azure subscription
- Azure tenant
- Azure region
- resource group
- resource names
- deployment identity
- billing approval

Beyond those, the task performs irreversible credential operations — App registration, private-key generation, key import, and PAT revocation — each of which requires explicit maintainer authorization at the point of execution. An agent may prepare, sequence, and verify; it must not register, generate, import, mint, or revoke without that authorization.

## Scope

In dependency order:

1. Provision Azure resources from the merged deployment-only Bicep plan, with private data-plane endpoints and the exact key-scoped sign/verify role.
2. Register the GitHub App per the merged registration contract: private, installable only on the owning account, no webhook, no OAuth callback, Contents write plus Metadata read only.
3. Install the App on the single publisher target. Source repositories must not be included in the installation.
4. Generate the private key, import it into Azure Key Vault as a non-exportable signing key, verify the import, then destroy the transient downloaded copy through the approved key ceremony.
5. Deploy the broker to the provisioned Azure Function.
6. Run the broker dry-run checkpoint, then the installation-token probe, then a single live dispatch probe. Each is a separate manual checkpoint.
7. Cut the 29 source workflows over from the PAT to the OIDC dispatch path, using the canonical migration template.
8. Revoke the PAT and confirm no remaining consumer depends on it.

## Out of scope

Design, contract, threat model, broker implementation, and the migration template. Those are **ATYA-024** and are already merged.

## Required outcome

- Deploy and cut over without expanding scope beyond this ATYA task.
- Apply least privilege and preserve the approved ownership and dependency boundaries.
- Prove each stage before the next begins; do not batch checkpoints.
- Attach sanitized acceptance evidence suitable for public review; keep sensitive evidence in the approved private channel.

## Dependencies

Hard dependencies: ATYA-024

Advisory prerequisites: None

## Related tasks

- ATYA-024
- ATYA-127
- ATYA-128
- ATYA-129
- ATYA-130

## Implementation guidance

1. No private evidence exists for this task. Establish the security facts by reading the repository source directly and record what was verified.
2. Confirm every one of the seven unconfirmed deployment inputs is supplied before provisioning anything.
3. Confirm current live state and avoid copying sensitive diagnostics into public logs, pull requests, or issue comments.
4. Execute the scope in the stated order in **platform**, stopping at each manual checkpoint for maintainer authorization.
5. Do not revoke the PAT until every source workflow is cut over and verified.
6. Record sanitized evidence publicly and retain detailed verification privately.

## Acceptance criteria

- Azure resources are provisioned from the merged Bicep plan, with private data-plane endpoints and a key-scoped sign/verify role.
- The App is registered and installed on exactly one repository, holding the publisher role, with Contents write and Metadata read and no other permission.
- The signing key exists in Key Vault as non-exportable, the broker can sign through it, and no transient copy of the key remains.
- The broker is deployed and its dry-run path proves a true no-op.
- The installation-token probe confirms tokens are scoped to the single publisher target and are never visible to a source workflow.
- One live dispatch completes end to end through the broker.
- All 29 source workflows dispatch through the broker and none references the PAT.
- The PAT is revoked and no consumer remains dependent on it.
- Compatibility, migration, and rollback implications are documented, including the rollback path if cutover fails partway.
- Public evidence is sanitized. The private evidence reference criterion is satisfied by CAVEAT-001 and is not carried as an open item.
- No unresolved high-severity regression remains in the affected scope.

## Standalone implementation prompt

Implement ATYA-149 for the AtyaLibraries ecosystem in repository **platform**. Respect hard dependencies (ATYA-024). Do not begin until the maintainer supplies all seven unconfirmed deployment inputs. Provision from the merged Bicep, register and install the App on the single publisher target, complete the key ceremony, deploy the broker, pass the dry-run, token-probe, and live-dispatch checkpoints in order, cut the 29 source workflows over, and only then revoke the PAT. Every registration, key, token, and revocation operation requires explicit maintainer authorization at the point of execution. Do not publish private evidence, credentials, logs, or exploit reproduction.
