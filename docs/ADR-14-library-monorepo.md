# ADR-14: One library monorepo with independently versioned packages

Status: Accepted (owner decision, 2026-11-28)

Date: 2026-11-28

Closes: ATYA-013

## Context

The fleet had 37 repositories for one maintainer. Every fleet-wide change was multiplied by the number of repositories: the .NET SDK and Build SDK rolls were 27 to 28 pull requests each, workflow pinning touched 28 repositories, and Renovate opened the same bump in every repository. A cross-package change such as correlation (ATYA-022) needed four repositories and four ordered releases.

Options considered:

| Option | Fleet-wide change | One-time cost | Kept |
|---|---|---|---|
| A. Keep one repository per package | ~28 PRs | none | independent releases |
| B. About six family repositories | ~6 PRs | large | independent releases |
| C. One library monorepo | 1 PR | large | independent releases (tag prefixes) |

## Decision

Option C. The package, tooling and Build SDK repositories move into one repository, `AtyaLibraries/Atya`, with a single `main` branch (ADR-13).

Moved: Abstractions, BackgroundServices, Client, CodeQuality, Exceptions, Guards, HealthChecks, Idempotency, Logging, Mediator, Messaging.Abstractions, Messaging.InMemory, Messaging.Outbox, Metrics, Middleware, Observation, OpenTelemetry, Pagination, Primitives, ProblemDetails, Results, Serialization, Testing, Tracing, Validation, Cli, Atya.Build.Sdk.

Not moved, and why:
- `publisher`: the trusted release pipeline stays separate from the code it publishes.
- `platform`, `Atya.Roadmap`, `.github`, `renovate-config`, `AtyaLibraries.github.io`: governance, planning and site, not packages.
- `Atya.Admin`: an application with its own lifecycle.
- `Atya.Templates.NuGetPackage` and `Atya.Templates.UiAutomation`: see the amendment below. Each template is its own repository.
- `Time`: deprecated under ADR-02; archived, not migrated.
- `github-workflows`: its reusable CI only served the package repositories; archived once the monorepo has its own workflows.

## Rules in the monorepo

- **Versioning:** every package keeps its own version. Release tags are `<PackageId>/v<SemVer>`, for example `Atya.Foundation.Guards/v1.2.0`. Each project sets `MinVerTagPrefix` to `<PackageId>/v`.
- **Publisher:** accepts the prefixed form and requires the prefix to equal the package id inside the `.nupkg`. The allowlist maps every moved package id to repository `Atya`. The unprefixed `v<SemVer>` form stays valid for single-package repositories.
- **Dependencies between packages:** remain package references to published versions, so a release of one package never silently depends on unreleased code of another. Moving to project references is a separate, later decision.
- **Layout:** each former repository becomes `packages/<Name>/` with its history preserved; one root solution, one `global.json`, one `Directory.Packages.props` (the highest version wins where repositories disagreed), one Renovate configuration, one CI workflow, one CodeQL and dependency-review workflow.
- **CI:** every pull request builds and tests all packages; the codebase is small enough that path filtering is not needed yet.
- **Package metadata:** `RepositoryUrl` points at the monorepo; SourceLink follows automatically.

## Migration

1. Publisher accepts prefixed tags (pull request reviewed before merge).
2. Create `AtyaLibraries/Atya`, import each repository with history into `packages/<Name>/`, unify the build files, prove a green build and a local pack of every package with package validation against its last published version.
3. Transfer open issues to the monorepo and confirm their Project 5 items survive.
4. Update `platform` ecosystem data and regenerate the allowlist; update RUNBOOK and template content.
5. Prove the path with one real release from the monorepo.
6. Archive the moved repositories (read-only; links to old package versions keep working), plus `Time` and `github-workflows`.

## Amendment (2026-11-28): templates are not in the monorepo

Templates are not in the monorepo: each template is its own repository, because templates are whole application scaffolds with their own toolchains, smoke tests and release cadence. `Atya.Templates.NuGetPackage` and `Atya.Templates.UiAutomation` stay separate repositories, are not archived, and move to a single `main` branch (ADR-13) like every other repository. They are released through the central publisher with the unprefixed `v<SemVer>` tag, which stays valid for single-package repositories.

An import of both templates into `packages/` was built and verified first and then reversed before any release was made from it; the monorepo's `Atya.Templates.*/v*` baseline tags stay in place and are never moved or deleted. The archive list in migration step 6 therefore covers the 27 moved package, tooling and Build SDK repositories, plus `Time` and `github-workflows`.

## Reversibility

Archived repositories can be unarchived. Until step 6 every original repository is untouched and still releasable, so the migration can stop at any earlier step without loss.
