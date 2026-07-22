# ATYA-024 GitHub App dispatch contract

## Decision state

ATYA-024 is In Progress. Its evidence and live topology agree on 29 source workflows, one publisher target, one `publish-package` event, four independently tracked failed-dispatch migrations, and permanent replacement of the shared PAT. No source workflow, credential, App, installation, token, tag, or publication has been changed.

The registration contract is complete, but credential placement requires an organization-owner architecture decision. GitHub's [repository-dispatch endpoint](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event) requires Contents write; it does not offer a narrower App permission named “dispatch.” Installing that permission across source repositories would violate least privilege.

## Exact sanitized registration specification

The machine-readable authority is [`github-app-registration.json`](../github/contracts/atya-024/github-app-registration.json).

| Setting | Required value |
| --- | --- |
| Owner | AtyaLibraries organization |
| Name | Atya Publisher Dispatch |
| Visibility | Private; installable only by the owning organization |
| Homepage | This roadmap repository |
| OAuth callback URLs | None |
| Device flow | Disabled |
| User authorization during installation | Disabled |
| Setup URL | None |
| Webhook | Disabled; no subscribed events |
| Repository permissions | Contents: read and write; Metadata: read (automatic) |
| Organization/account permissions | None |
| Installation selection | Selected repositories |
| Installation scope | Exactly one repository with the publisher role |

Contents write is accepted only because the repository-dispatch endpoint requires it. The installation and every minted token must remain scoped to the one publisher target. Source repositories must not be included in the installation.

## Recommended credential placement

Store the downloaded private key in an external managed key vault as a non-exportable signing key. This follows GitHub's [private-key storage guidance](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps#storing-private-keys). Give the broker runtime identity permission to sign only; do not grant key read/export or secret-list rights. After verified import, remove the transient downloaded copy through the separately approved key ceremony. The broker signs the App JWT through the vault API, mints a one-repository installation token, uses it for one dispatch request, and retains it only in memory until the API response.

Store the non-secret client ID in the broker service’s ordinary deployment configuration. A client secret is unnecessary because the design does not use OAuth user authorization.

The evidence bundle establishes the security requirement, but not the existence or owner of a managed broker and key vault. Registration, installation, key generation, and placement therefore remain behind the manual checkpoint.

## Why branch and pull-request workflows cannot access the key

Under the recommended design, the private key is not a GitHub Actions organization, repository, or environment secret; it is not supplied to a hosted or self-hosted runner; and it is never returned by the broker. A workflow receives only its GitHub-issued OIDC token.

The broker rejects the request unless all of these conditions hold:

- the issuer and audience are exact;
- the organization and repository numeric identities are privately allowlisted;
- the event is `push`, the ref type is `tag`, and the ref matches the release-tag contract;
- the workflow identity and workflow commit are privately allowlisted and immutable;
- the bounded request body has only approved fields and matches the source identity;
- the package-to-source binding already accepted by the publisher remains valid.

An arbitrary branch fails the tag and immutable-workflow checks. A pull request fails the event and ref checks. A fork or unlisted repository fails the numeric-identity allowlist. Even a rejected workflow never receives the private key or an installation token. The included negative fixtures exercise these decisions with synthetic identities.

This proof does not claim that GitHub Actions secrets are branch-isolated. GitHub documents that [repository secrets are available to all workflows in a repository and organization secrets to all workflows in selected repositories](https://docs.github.com/en/code-security/reference/secret-security/secret-types#actions-secrets). Fork pull-request restrictions do not protect against every same-repository branch or collaborator scenario.

## Canonical migration mechanism

[`source-workflow.template.yml`](../github/contracts/atya-024/source-workflow.template.yml) is a non-active migration template. It replaces the shared PAT with `id-token: write`, obtains a GitHub OIDC identity, and submits a bounded request to the broker. The broker alone mints and consumes the App installation token.

The generator must fill package identity, correlation ID, dry-run policy, and immutable workflow identity only after the architecture decision. ATYA-127 through ATYA-130 retain ownership of their four source migrations. The public [`migration-ledger.csv`](../github/contracts/atya-024/migration-ledger.csv) records only sanitized aggregate counts; the private repository mapping remains outside this repository.

`Test-GitHubAppDeploymentScope.ps1` validates a private deployment export without printing repository names or numeric identities. It requires exactly 29 unique source IDs in the broker allowlist, exactly one separately identified publisher installation, selected-repository installation, Contents write plus Metadata read, and no organization permissions. The committed input is synthetic; a live export remains behind the checkpoint.

## Safe no-op proof design

Proof is staged and fail-closed:

1. Run the local JSON, CSV, YAML, permission, fixture, and sanitization validators. These make no network mutation.
2. After owner approval and broker deployment, submit synthetic OIDC claims directly to the broker policy evaluator. It must deny branches, pull requests, forks, unknown repositories, mutable workflow identities, invalid tags, unexpected fields, and oversized payloads without signing or minting a token.
3. With separate approval, run a broker dry-run from one allowlisted tag workflow. Dry-run authenticates and validates but must not mint an App token or call GitHub.
4. With separate approval, mint a token and verify its installation repository count and permission map using read-only endpoints. Revoke the token immediately after the probe.
5. Only after the previous gates pass, dispatch `publish-package` with `dry_run: true`. The publisher must terminate before artifact download, signing, OIDC exchange, release creation, or package push.
6. Live migration and publication proof belong to the downstream source tasks and require their own approvals. Existing package versions are never republished.

Steps 2 through 6 are designs only at this checkpoint and have not run.

## Migration, rotation, rollback, and recovery

Migration proceeds one source at a time after the broker and publisher no-op gates pass. During coexistence, the PAT path is frozen rather than expanded. The PAT is removed only after all 29 sources have passed their downstream proof and rollback evidence is accepted.

Routine rotation uses two App keys: import the new key into the vault, switch the signer, verify the public fingerprint and a separately approved no-op, then revoke the old key. No key material enters an issue, pull request, workflow log, or repository.

Before PAT removal, rollback disables the source OIDC path and restores the unchanged legacy workflow reference only under incident approval. After PAT removal, rollback disables broker dispatch and App installation token issuance; it does not recreate a PAT. A forward repair is required.

For suspected compromise: disable broker dispatch, revoke active installation tokens where possible, generate and import a replacement key, delete the compromised App key, review App and organization audit events, verify the publisher and source bindings, and resume only from the no-op gates. If the App registration itself is compromised, suspend or uninstall it and require a new owner-approved registration.

## Architecture decision request

The organization owner must choose one of these placement models before registration:

| Alternative | Branch/PR key isolation | Operational cost | Decision |
| --- | --- | --- | --- |
| External broker plus sign-only managed key vault | Strong: no Actions workflow or runner can read the key; OIDC claims are policy inputs only | Requires owned broker/vault service and incident operations | Recommended |
| Dedicated broker repository with an environment secret | Incomplete: protection depends on repository/environment administration and runner trust; key remains runner-readable | Lower infrastructure cost | Reject unless an independently reviewed control proves equivalent isolation |
| Organization or per-source Actions secrets | Weak: broad workflow access, replicated key material, and manual onboarding/rotation | Superficially simple, high security debt | Rejected |

The exact next action is a single organization-owner decision: approve the external OIDC broker plus sign-only managed-key-vault placement and name its accountable service owner, or reject it and provide an equivalent non-runner-readable signing service for review. Do not register the App as part of that decision.
