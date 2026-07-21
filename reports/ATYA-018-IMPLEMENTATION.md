# ATYA-018 implementation evidence

Date: 2026-07-21

Public issue: [publisher #9](https://github.com/AtyaLibraries/publisher/issues/9)

Product pull request: [publisher #11](https://github.com/AtyaLibraries/publisher/pull/11)

## Review classification

The product change is implementation-complete and review-ready on draft pull
request #11. It is intentionally unmerged, the controlling issue remains open,
and ATYA-018 remains incomplete pending review and merge.

## Finding and remediation

The earlier publisher authorized the primary package but did not treat its symbol
package, retained SBOM, and deterministic artifact inventory as one governed
pre-publication unit. Provenance attestation also occurred after the irreversible
publication step. The remediation preserves the ATYA-016 job boundary while making
complete-bundle validation, sealing, retention, and attestation prerequisites for
credential acquisition.

The accepted release unit contains exactly one primary `.nupkg`, one matching
`.snupkg`, one CycloneDX package SBOM, and one deterministic manifest. Trusted
publisher code validates bounded structure and content, package identity, version,
repository provenance, immutable tag, portable PDB and SourceLink data, SBOM
identity, and ATYA-001 policy authorization. It records lengths and SHA-256 values,
retains and attests all four files, verifies them again before credentials, and
re-verifies immediately before push. The untrusted build still has no publication
authority, and the privileged job never checks out or executes requested source.

NuGet publishes the primary and symbol packages sequentially rather than as a
remote multi-object transaction. The implemented guarantee is therefore the
strongest safe boundary available: every required artifact is complete, retained,
hashed, and attested before the first remote mutation. An interrupted or partial
push is recovered forward-only with a new immutable version and tag; published
objects are never overwritten, deleted, or reused.

## Sanitized acceptance evidence

- Product head `602ad078df0a6cb767227248cab1d9dee79602d1` is based on the
  ATYA-016 publisher merge `1ed15efc183e77579f4eded1c3fd43710d4d60d3`.
- The publisher security regression suite passes 93 tests with no failures in
  Windows PowerShell 5.1 and PowerShell 7 locally.
- Positive coverage seals the complete authorized package, symbol, SBOM, and
  manifest set. Negative fixtures cover missing or duplicate artifacts; mismatched
  id, version, and provenance; malformed or ambiguous package metadata; malformed
  portable PDB or missing SourceLink; malformed, incomplete, or unsupported SBOM;
  unexpected files and unsafe paths; empty, per-file, expanded, aggregate, and
  entry-count bounds; policy/schema failures; artifact hash drift; and manifest
  tampering.
- Static workflow assertions prove that sealing, retention, attestation, and
  post-attestation verification precede login and push, and that the push step
  re-verifies the sealed bytes. They also preserve minimal permissions and the
  no-source privileged boundary.
- Local PowerShell parsing, YAML lint, policy/fixture JSON parsing, sanitization,
  and Git diff checks pass.
- Both configured publisher pull-request jobs passed for the product head on
  Linux and Windows in [CI run 29862421940](https://github.com/AtyaLibraries/publisher/actions/runs/29862421940).
- No production publication workflow, package push, release, credential/OIDC
  request, real attestation service, tag mutation, policy change, or environment,
  permission, ruleset, or organization-setting change was used for validation.
- Public artifacts contain no raw private evidence, credentials, private paths,
  sensitive logs, or reproduction details.

## Compatibility, migration, rollback, and recovery

Existing callers keep the repository, release-ref, solution, package-project, and
global-json inputs and gain no PackageId field or secret. Every authorized package
must now produce the shared Build SDK `.snupkg` and SourceLink metadata; packages
that disable symbols fail before credentials and must migrate without a publisher
exception. The last compatible behavior is the ATYA-016 publisher merge recorded
above.

A pre-publication failure is corrected in source or authoritative policy and retried
through a new reviewed immutable release. Rollback is a normal revert that keeps
publication stopped while a forward fix is prepared. If a remote push may have
started, maintainers preserve the sealed artifact and attestation, verify primary
and symbol registry state separately, and follow the documented incident process.
They never overwrite a package or reuse its version or tag.

## Issue, project, and dependent disposition

Publisher issue #9 remains open. ATYA-018 may move from In Progress to In Review
only with both draft pull requests and acceptance evidence ready; it must not move
to Done in this work.

No dependent status changes are authorized. ATYA-029, ATYA-106, ATYA-113,
ATYA-114, and ATYA-127 through ATYA-131 all remain Blocked on their recorded hard
dependencies. Completion of ATYA-018 alone would not make any of them Ready.
