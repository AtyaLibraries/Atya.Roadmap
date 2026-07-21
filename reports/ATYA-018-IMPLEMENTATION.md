# ATYA-018 implementation evidence

Date: 2026-07-21

Public issue: [publisher #9](https://github.com/AtyaLibraries/publisher/issues/9)

Product pull request: [publisher #11](https://github.com/AtyaLibraries/publisher/pull/11)

## Review classification

The product change passed independent acceptance and publisher pull request #11
is merged. Exact-merge CI and clean detached verification also passed. The
controlling issue remains open and ATYA-018 remains In Review only until this
evidence pull request merges and final bookkeeping is completed.

## Finding and remediation

The earlier publisher authorized the primary package but did not treat its symbol
package, retained SBOM, and deterministic artifact inventory as one governed
pre-publication unit. Provenance attestation also occurred after the irreversible
publication step. The remediation preserves the ATYA-016 job boundary while making
complete-bundle validation, sealing, retention, and attestation prerequisites for
credential acquisition.

The accepted release unit contains exactly `package.nupkg`, `package.snupkg`,
`package.sbom.cdx.json`, and `release-manifest.json`. Trusted
publisher code validates bounded structure and content, package identity, version,
repository provenance, immutable tag-resolved commit, portable PDB and exact-commit
SourceLink data, SBOM identity, and ATYA-001 policy authorization. It records
lengths and SHA-256 values,
retains and attests all four files, verifies them again before credentials, and
re-verifies immediately before push with an explicitly pinned .NET/NuGet CLI.
The untrusted build still has no publication authority, and the privileged job
never checks out or executes requested source.

NuGet publishes the primary and symbol packages sequentially rather than as a
remote multi-object transaction. The implemented guarantee is therefore the
strongest safe boundary available: every required artifact is complete, retained,
hashed, and attested before the first remote mutation. An interrupted or partial
push is recovered forward-only with a new immutable version and tag; published
objects are never overwritten, deleted, or reused.

## Sanitized acceptance evidence

- Final product head `684b4798642c9805a33254f4e19d1ca9ad34f1ca` was merged as
  `e9740930e358e730199e0fa73ac3a970752a6cfe`, based on the ATYA-016 publisher
  merge `1ed15efc183e77579f4eded1c3fd43710d4d60d3`.
- The publisher security regression suite passes 110 tests with no failures in
  Windows PowerShell 5.1 and PowerShell 7 locally. Linux adds two applicable
  filesystem fixtures and passes 112 tests.
- Positive coverage seals the complete authorized package, symbol, SBOM, and
  manifest set. Negative fixtures cover missing or duplicate artifacts; mismatched
  id, version, provenance, and source commit; malformed or ambiguous package
  metadata and archive names; malformed portable PDB or missing/inconsistent
  SourceLink; malformed, incomplete, identity-mismatched, or unsupported SBOM;
  unexpected files and unsafe paths; empty, per-file, expanded, aggregate, and
  entry-count bounds; policy/schema failures; artifact hash drift; and manifest
  omission, duplication, reordering, and tampering.
- Static workflow assertions prove that sealing, retention, attestation, and
  post-attestation verification precede login and push, and that the push step
  re-verifies the sealed bytes. They also preserve minimal permissions and the
  no-source privileged boundary. The tag-resolved commit is bound through both
  package metadata records, Portable PDB SourceLink, the manifest, and both
  pre-push verifications; publication uses exact .NET SDK `10.0.301`.
- The immutable `actions/attest-build-provenance` v2.4.0 commit
  `e8998f949152b193b063cb0ec769d69d929409be` was inspected. Its pinned
  implementation accepts the explicit multi-path input and creates one statement
  covering all four expected subject names and SHA-256 digests.
- Local PowerShell parsing, YAML lint, policy/fixture JSON parsing, sanitization,
  Git diff checks, real package/symbol/SBOM-shape sealing, and byte-identical
  cross-engine manifest serialization pass.
- Both configured pull-request jobs passed on the final product head in
  [CI run 29865566885](https://github.com/AtyaLibraries/publisher/actions/runs/29865566885).
  Both configured push jobs passed on the exact merge commit in
  [CI run 29865735629](https://github.com/AtyaLibraries/publisher/actions/runs/29865735629).
  The Windows YAML step is intentionally platform-gated; trusted YAML parsing
  passed on Linux and independent local lint also passed.
- A clean detached worktree at the exact merge commit passed the complete suite
  under Windows PowerShell 5.1 and PowerShell 7 (110/110 each), YAML/JSON and
  PowerShell parsing, sanitization, policy and committed-diff checks, cross-engine
  canonical-manifest comparison, and real artifact-shape validation. It remained
  clean and only that temporary worktree was removed.
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

Publisher issue #9 remains open and ATYA-018 remains In Review until this evidence
pull request is merged. Once merged, the accepted lifecycle calls for a sanitized
completion comment, issue closure, the exact approved Evidence Status, and a move
to Done.

No dependent status changes are authorized. After ATYA-018 completion, ATYA-029
remains Blocked on ATYA-003; ATYA-106 on ATYA-003, ATYA-020, ATYA-031, ATYA-096,
and ATYA-131; ATYA-113 on ATYA-112; ATYA-114 on ATYA-032; ATYA-127 through
ATYA-130 on ATYA-024; and ATYA-131 on ATYA-003 and ATYA-020.
