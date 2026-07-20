# ATYA-001 implementation evidence

ATYA-001 establishes `AtyaLibraries/platform` as the ecosystem policy authority. The implementation is additive: it does not change package APIs, published packages, tags, or long-lived branch policy.

## Authority and contract

- Manifest: `platform/ecosystem/ecosystem.json`
- JSON Schema: `platform/ecosystem/ecosystem.schema.json`
- Validation: `platform/scripts/Validate-Ecosystem.ps1`
- Deterministic generation: `platform/scripts/Generate-EcosystemConsumers.ps1`
- CI and regression coverage: `platform/.github/workflows/ecosystem-manifest.yml` and `platform/tests/Test-Ecosystem.ps1`

The initial manifest records all 37 live organization repositories, 31 unique package identities (including the non-published SDK probe), and 23 retained PARK/CUT non-repository portfolio decisions. It covers repository archetype and lifecycle, visibility, default branch, package lifecycle/tier/purpose/publishing route, target frameworks, Build SDK pins, allowed internal dependency edges, policy version, and immutable fleet pins.

## Generated consumers

The manifest generates six downstream artifacts: constitution package catalog, CLI policy, template references, public-site data, publisher allowlist, and drift-audit policy. The platform constitution no longer retains a separate package catalog or dependency matrix, and the drift workflow loads its branch expectations and infrastructure scope from generated policy.

## Compatibility and rollback

This is the first version of the manifest contract (`schemaVersion` 1.0.0). Consumers migrate from hand-maintained policy to generated JSON without a package-facing compatibility change. Rollback is a normal revert of the platform and roadmap pull requests; immutable releases are unaffected.

## Acceptance state

Local validation covers JSON Schema, identifier and repository uniqueness, lifecycle enums, dependency existence/direction/cycles, required policy and pin formats, bounded input size/cardinality, both required negative fixtures, and deterministic output. ATYA-001 remains open until both draft pull requests are reviewed, CI passes, changes merge, and post-merge regeneration/acceptance is verified.

The tasks with ATYA-001 as their only hard dependency are ATYA-004, ATYA-016, ATYA-019, ATYA-090, ATYA-092, ATYA-093, ATYA-094, ATYA-095, ATYA-096, and ATYA-097. They remain Blocked during review and become Ready only after ATYA-001 is fully Done.
