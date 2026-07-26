# ATYA-024 — Design and build the GitHub App dispatch broker

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-024 |
| Owning repository | Atya.Roadmap |
| Priority | P0 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-016 |
| Advisory prerequisites | None |
| Confidence | High |
| Risk | Critical |
| Effort | M |

## Public remediation summary

This issue tracks **Design and build the GitHub App dispatch broker**. Only the minimum public coordination information is included here. Verified details, affected trust-boundary evidence, and any reproduction material are retained privately by organization maintainers.

Private evidence reference: AUDIT-SEC-024 — see `reports/EVIDENCE-CAVEAT-LEDGER.md`, CAVEAT-001. This identifier is a sanitization placeholder, not a retrievable document.

## Scope

ATYA-024 owns the design and build half of replacing the PAT dispatch chain:

- the App registration, permission, and installation contract;
- the source OIDC and bounded dispatch contract;
- the threat model and its proof that branch, pull-request, fork, and unlisted workflow identities cannot reach the signing key;
- the Azure Function broker implementation, its security test suite, and the deployment-only Bicep plan;
- the non-active canonical source-workflow migration template;
- the static validators, negative fixtures, and sanitized migration ledger.

## Out of scope

Every operation that touches live infrastructure or a live credential belongs to **ATYA-149**: Azure provisioning, App registration and installation, key generation and Key Vault import, broker deployment, the live dispatch probe, cutover of the 29 source workflows, and revocation of the PAT.

ATYA-024 is complete when the artifacts above exist and validate. It does not require anything to be deployed, and it does not by itself remove the PAT.

## Required outcome

- Produce the contract, threat model, broker implementation, and migration template without expanding scope into deployment.
- Apply least privilege and preserve the approved ownership and dependency boundaries.
- Add regression, negative, and boundary coverage that proves the intended security properties without publishing exploitable details.
- Attach sanitized acceptance evidence suitable for public review.

## Dependencies

Hard dependencies: ATYA-016

Advisory prerequisites: None

## Related tasks

- ATYA-149
- ATYA-001
- ATYA-002
- ATYA-003

## Implementation guidance

1. No private evidence exists for this task. Establish the security facts by reading the repository source directly and record what was verified.
2. Confirm current live state and avoid copying sensitive diagnostics into public logs, pull requests, or issue comments.
3. Implement the contract and validators in **Atya.Roadmap**, and the broker in the designated `platform` repository.
4. Add non-disclosing automated coverage and document compatibility, migration, and rollback behavior.
5. Record sanitized evidence publicly.

## Acceptance criteria

Each criterion below is satisfiable by inspecting merged artifacts alone. No deployment, credential operation, or live probe is required.

- The sanitized App registration and installation contract exists and validates: `github/contracts/atya-024/github-app-registration.json`.
- The source OIDC and bounded dispatch contract exists and validates: `github/contracts/atya-024/dispatch-contract.json`.
- The threat model is documented, including why branch, pull-request, fork, and unlisted workflow identities cannot reach the signing key: `docs/ATYA-024-GITHUB-APP-DISPATCH.md`.
- A non-active canonical source-workflow migration template exists: `github/contracts/atya-024/source-workflow.template.yml`.
- The sanitized aggregate migration ledger exists: `github/contracts/atya-024/migration-ledger.csv`.
- Permission, topology, credential-placement, ledger, fixture, and sanitization validators pass, together with their negative authorization and contract-mutation cases: `pwsh -File ./tests/Test-GitHubAppDispatchContract.ps1`.
- The Azure Function broker, its managed-identity adapters, its synthetic security suite, and its deployment-only Bicep plan are merged in the `platform` repository.
- Compatibility, migration, and rollback implications are documented: `reports/ATYA-024-IMPLEMENTATION.md`.
- The public evidence is sanitized. The private evidence reference criterion is satisfied by CAVEAT-001 in `reports/EVIDENCE-CAVEAT-LEDGER.md` and is not carried as an open item.
- No unresolved high-severity regression remains in the affected scope.

## Implementation checkpoint

Discovery and the sanitized contract package are recorded in [the ATYA-024 implementation report](../../reports/ATYA-024-IMPLEMENTATION.md). The organization owner approved the Azure Function and Azure Key Vault architecture.

Nothing is deployed. No App is registered or installed, no key is generated, no secret or variable is created, and all 29 source workflows still use the PAT. That remaining work, and the seven unconfirmed deployment inputs it waits on, are tracked by **ATYA-149**. Completing ATYA-024 does not start the downstream source migrations, which now depend on ATYA-149.

## Standalone implementation prompt

Implement ATYA-024 for the AtyaLibraries ecosystem in repository **Atya.Roadmap**. Respect hard dependencies (ATYA-016). No private evidence exists; establish the security facts from repository source and do not publish credentials, logs, or exploit reproduction. Deliver the contract, threat model, broker implementation, and migration template with tests, migration notes, rollback guidance, and sanitized completion evidence. Do not deploy, register, install, or mint anything — that is ATYA-149.
