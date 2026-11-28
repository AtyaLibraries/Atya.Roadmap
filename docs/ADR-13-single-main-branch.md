# ADR-13: Single `main` branch, releases are tags on `main`

Status: Accepted (owner decision, 2026-11-28)

Date: 2026-11-28

Closes: ATYA-154

Supersedes: ADR-09

## Context

ADR-09 kept a `development` + `master` pair per repository, with a promotion pull request into `master` for each release and a merge-back into `development` afterwards so MinVer could see the newest stable tag.

In practice, for a single maintainer, this model cost a promotion PR and often a merge-back on every release (18 releases in the NEXT: FIXES lane). Where rulesets require squash-only linear history on `development` and merge-only on `master`, a merge-back is impossible by design and the two histories diverge permanently (recorded on ATYA-154 for `Atya.Templates.NuGetPackage` v1.4.0). Tags could also land on commits that `development` did not contain.

## Decision

Every repository has one long-lived branch, `main`. Work lands on `main` through pull requests. A release is an annotated tag on a commit of `main`; the central publisher is then started for that tag.

There are no promotion pull requests and no merge-backs.

## Consequences

- MinVer sees every release tag, because every tag is on `main`. Commits after a release build as prerelease versions automatically.
- The "pull requests to master must come from development" guard in `github-workflows` and the matching Cli rule are removed.
- `defaultBranch` becomes `main` in `platform/ecosystem/ecosystem.json`, which regenerates the publisher allowlist.
- Release documentation (publisher RUNBOOK, repository RELEASING files, template content) describes: merge to `main`, tag, run the publisher.
- Published tags and packages are unchanged. Old `master` branches are not needed for provenance, because tags keep released commits reachable.

## Adoption

The library repositories adopt this as part of the monorepo migration (ADR-14), which starts with a single `main` branch. Repositories that stay separate (`publisher`, `platform`, `Atya.Roadmap`, `Atya.Admin`, `.github`, `renovate-config`, the public site) move to `main` only, if not already there, in the same migration task.
