# ATYA-019 — Immutable workflow and action reference policy

Status: **Defined. Not rolled out.**

This document is the single authority for how `uses:` references are pinned across the
AtyaLibraries fleet. Where any other document, workflow, or check disagrees with it, this
document wins and the other artifact is the defect.

The machine-readable form is
[`immutable-reference-policy.json`](../github/contracts/atya-019/immutable-reference-policy.json).
The executable form is [`Test-ImmutableReference.ps1`](../scripts/Test-ImmutableReference.ps1).
Where prose and contract disagree, the contract wins; the validator reads its patterns and
rule identifiers from the contract and holds no independent copy of the policy.

ATYA-019 defines and verifies the policy. It does not apply it. Rollout is owned by
ATYA-124, ATYA-026, ATYA-027, ATYA-028, and ATYA-039.

## 1. The rule

A `uses:` reference to code outside the calling commit must name that code by an
identifier that cannot be repointed after review.

| Form | Verdict |
| --- | --- |
| `owner/repo@<40-hex-lowercase-sha>` with a trailing version comment | **Permitted** |
| `owner/repo@<40-hex-lowercase-sha>` with no comment, or a comment that names no version | Forbidden — IR002 |
| `owner/repo@v1`, `@v1.2.3`, `@main`, `@<short-sha>`, `@<UPPERCASE-SHA>` | Forbidden — IR001 |
| `docker://image@sha256:<64-hex>` | **Permitted** |
| `docker://image:tag` | Forbidden — IR003 |
| `./path/to/action` or `./.github/workflows/x.yml` | **Exempt by form** — IR004 |
| Anything else | Forbidden — IR005 (fails closed) |

The permitted written form is exactly:

```yaml
uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10  # v6.0.3
```

### Conformance is decided per reference

Not per file, and not per repository. Both files named in the ATYA-019 scoping notes mix
conformant and non-conformant references inside the same file, and one of them mixes them
inside the same job. A file-level boolean cannot express that state, so any check that
emits one is wrong by construction. This is recorded in the contract as
`evaluationUnit: "reference"` and enforced by fixture
[`mixed-references.workflow.yml`](../github/contracts/atya-019/fixtures/mixed-references.workflow.yml).

## 2. Why the version comment is mandatory

The comment is not documentation. It is the input Renovate uses to resolve a SHA back to a
version it can advance.

Renovate's `github-actions` manager recovers `currentValue` from the trailing comment. When
there is no comment it sets `enabled = false` with `skipReason: 'unversioned-reference'`,
because it cannot determine which tag or branch the SHA belongs to. The reference is then
immutable **and permanently frozen**: it will never receive another update, including a
security update, and nothing will report that fact.

An uncommented pin is therefore not "slightly less tidy" than a commented one. It is a
reference that has silently left the update system. Fourteen such references exist in the
fleet today (§6).

Verified against `renovatebot/renovate`,
`lib/modules/manager/github-actions/extract.ts`, read 2026-07-26, and the published
manager documentation.

## 3. First-party references get no exemption

`AtyaLibraries/github-workflows/...@v1` is held to exactly the same rule as
`actions/checkout@v4`. This is stated explicitly because the opposite is the intuitive
assumption and it is wrong here.

A first-party mutable tag is the **largest** blast radius in this fleet, not the smallest.
`AtyaLibraries/github-workflows` is consumed by every managed package repository. Moving
the `v1` tag — by mistake, by force-push, or by an attacker holding write access to one
infrastructure repository — changes the code executed by every consumer on its next run,
with no pull request opened anywhere and no review performed. The trust that makes
first-party code feel safe is trust in the *review process*, and a movable tag is precisely
the mechanism that bypasses review.

## 4. Reusable workflows versus actions

They are held to the same rule. The contract records this as
`differsFromAction: false`.

A reusable-workflow reference resolves through the same Git ref mechanism as an action
reference and is equally repointable by moving a tag. The only real difference is the YAML
key it appears under — `jobs.<id>.uses` rather than `jobs.<id>.steps[*].uses` — which
affects how a validator *extracts* the reference, not how it *judges* it. A validator that
looks only at step-level `uses:` will silently miss every reusable-workflow reference in
the fleet, which is the majority of first-party references.

## 5. Forms with no commit SHA

**Local references** (`./...`) are exempt by form, and are recorded as `exempt-by-form`
rather than passed silently. They resolve against the commit of the calling repository that
is already checked out for the run, so there is no independently movable ref to pin; their
integrity is inherited from the caller's own commit.

**`docker://` references** are *not* exempt. They have no commit SHA, but they have an
immutable equivalent: the image digest. `docker://alpine@sha256:<64 hex>` is permitted;
`docker://alpine:3.19` is forbidden, because a container tag is republishable in place.
A digest that is present but malformed is also forbidden — presence is not
well-formedness.

Neither form currently occurs anywhere in the fleet (verified 2026-07-26). The policy
resolves them anyway, because a policy that is silent on a case will be interpreted
generously by whoever meets it first.

## 6. Exceptions

An exception exists only when it is recorded in the `exceptions.register` array of the
policy contract, in a reviewed pull request to `Atya.Roadmap`. An exception claimed in the
consuming repository, in a code comment, or in a pull-request description is not an
exception, and the validator will not honour it.

Each entry must carry all six required fields: `reference`, `reason`, `approver`,
`recordedOn`, `expiresOn`, `remediationTask`. An entry missing any field is rejected
outright rather than partially honoured. Exceptions are time-boxed to at most 90 days, and
an expired exception reverts to the underlying violation — it does not linger as a pass.

Approver: `aasulyan`, accountable human owner.

**The register ships empty.** ATYA-019 grants no exceptions. The known non-conformant
references below are recorded as findings for the rollout tasks, not waved through.

## 7. What this policy requires of Renovate

ATYA-028 owns the preset. ATYA-019 states the requirement only and edits nothing in
`renovate-config`.

The observed preset (`AtyaLibraries/renovate-config/default.json`) already extends
`helpers:pinGitHubActionDigests` and automerges `github-actions` digest updates after CI,
with major updates gated on dashboard approval. That is the right shape. Four requirements
must hold for a SHA-pin policy to be sustainable rather than a slow freeze:

- **RN001** — Digest pinning stays enabled, so a newly introduced tag reference is converted
  to SHA-plus-comment rather than left mutable.
- **RN002** — Every SHA-pinned reference carries a version comment. Without it Renovate
  cannot advance the pin at all (§2). This is the requirement most likely to be treated as
  cosmetic and dropped.
- **RN003** — ATYA-028 must **confirm**, not assume, that the preset's `depType` matching
  actually reaches reusable-workflow references (`jobs.<id>.uses`) and not only step-level
  action references. `helpers:pinGitHubActionDigests` matches `matchDepTypes: ["action"]`.
  Renovate documents support for updating reusable workflows, and repository `uses:`
  references are extracted with `depType: 'action'`, so coverage is likely — but ATYA-019
  did not run Renovate against this fleet and does not assert it. Prove it with a live
  dependency dashboard or a dry run.
- **RN004** — Digest automerge stays gated on CI, and major updates stay gated on dashboard
  approval.

The interaction to understand: pinning without a working update mechanism trades a
*mutability* risk for a *staleness* risk. Both are real. The policy is only defensible as a
pair — immutable pins **plus** an update path that can advance them.

## 8. What a correct drift check must do

ATYA-124 implements against this section. It should be executable from this document alone.

### The observed defect

The existing check in `AtyaLibraries/platform` (`.github/workflows/drift-audit.yml`)
decides reference conformance with:

```js
/uses:\s*AtyaLibraries\/github-workflows\/\.github\/workflows\/dotnet-package-ci\.yml@v1\b/i
```

This requires the literal mutable tag `@v1`. **The check is inverted with respect to this
policy.** A repository that correctly SHA-pins the reusable workflow is reported as drift;
a repository that uses the mutable tag is reported as clean. Verified 2026-07-26 by reading
the workflow source and every `.github/workflows` file in the organization: 14 repositories
satisfy the check by being non-conformant, and 14 fail it while being closer to correct.

The root cause is not a typo in the regex. It is that one regex is being asked two
different questions at once — *does this repository call the expected workflow* (adoption)
and *is that call pinned immutably* (conformance) — so the ref value became load-bearing
for an adoption test. Fixing the ref form in a consuming repository appears to break
adoption, which is why the defect is stable.

### Requirements

- **DV001** — Never require a specific ref value. Conformance is a property of the ref
  *form*.
- **DV002** — Separate adoption from conformance and report them independently. Adoption
  asks whether `AtyaLibraries/github-workflows/.github/workflows/dotnet-package-ci.yml` is
  referenced from the expected job. Conformance asks whether that reference's ref is a
  40-hex lowercase SHA with a version comment. Neither answer may be inferred from the
  other.
- **DV003** — Evaluate every `uses:` occurrence independently; report file, line, reference,
  verdict, and rule id. A file-level boolean is insufficient.
- **DV004** — Classify each reference into one of the four kinds *before* judging it, and
  apply IR003 to `docker://` and IR004 to local references deliberately rather than by
  accident.
- **DV005** — Parse the trailing comment and enforce IR002.
- **DV006** — Fail closed under IR005 on any `uses:` value that cannot be classified, and on
  any workflow file that cannot be read or parsed. A validator that skips what it cannot
  understand reports clean fleets it never checked.
- **DV007** — Honour only exceptions in this contract's register, and treat an expired
  exception as a violation.
- **DV008** — Be exercised by fixtures covering at minimum the cases in
  [`fixtures/`](../github/contracts/atya-019/fixtures/), including a file that mixes
  conformant and non-conformant references.

`Test-ImmutableReference.ps1` is a conforming reference implementation of DV001 through
DV008 and may be ported rather than reinvented.

## 9. Compatibility, migration, and rollback

**Compatibility.** Adopting this policy changes no package, no public API, and no consumer
of any AtyaLibraries package. It changes only the text of `uses:` lines and the checks that
read them. No workflow behaviour changes at the moment of pinning, because a SHA-pin to the
commit a tag currently points at is functionally identical to that tag.

**Migration cost.** 126 of 168 references in the fleet are currently non-conformant (§10).
The work is mechanical but not free: each reference must be resolved to the SHA its tag
points at *today* and annotated with the version. Renovate can perform most of this
automatically once RN001–RN003 hold, which is the recommended route — hand-editing 126
references invites transcription errors that pin to a wrong-but-valid SHA, which is worse
than a tag because it is silent.

Migration must be ordered: **ATYA-124 before ATYA-026.** Rolling pinned workflows across
the fleet while the drift check still demands `@v1` would make every correctly migrated
repository report as drift, and the resulting noise would be read as the migration having
failed.

**Rollback.** The policy is withdrawn by reverting the task branch or deleting
`github/contracts/atya-019/`, `scripts/Test-ImmutableReference.ps1`, and
`tests/Test-ImmutableReferenceContract.ps1`. Nothing outside this repository depends on
them yet, because nothing has been rolled out. If the policy is withdrawn *after* rollout,
already-pinned references remain valid and functional — a SHA-pinned workflow does not stop
working because the policy that required it was withdrawn — so rollback is a matter of
ceasing to enforce, not of reverting the fleet. There is no state to unwind.

**If the policy proves wrong.** The most likely failure mode is RN003 turning out false:
Renovate does not in fact advance reusable-workflow pins. In that case the correct response
is *not* to abandon SHA-pinning for first-party references, but to narrow IR002 for that
kind and add an explicit update mechanism (a scheduled first-party bump task). Falling back
to `@v1` would restore the exact exposure described in §3.

## 10. Findings — observed, not fixed

Measured 2026-07-26 across all 36 organization repositories, by snapshotting every
`.github/workflows`, `.github/actions`, and `actions` YAML file and running
`Test-ImmutableReference.ps1` over the snapshot:

| Verdict | Count |
| --- | --- |
| Total `uses:` references | 168 |
| Conformant | 42 |
| Violation — IR001 (mutable ref) | 112 |
| Violation — IR002 (SHA with no usable version comment) | 14 |
| Exempt by form | 0 |

**126 of 168 references are non-conformant.** Note that "SHA-pinned" and "conformant" are
not the same set: 56 references are SHA-pinned, but 14 of those fail IR002, leaving 42
conformant. No reference was modified by ATYA-019.

The reference findings below are disjoint and sum to 126.

| # | Finding | Rule | Count | Owning repository | Remediated by |
| --- | --- | --- | --- | --- | --- |
| F2 | First-party reusable workflows by mutable `@v1` — `codeql-csharp` (28), `dependency-review` (28), `dotnet-package-ci` (14) | IR001 | 70 | managed fleet, templates | ATYA-026 |
| F3 | `actions/github-script@v7` in `publish-nuget.yml` and in the drift check | IR001 | 29 | managed fleet, templates, `platform` | ATYA-026, ATYA-124 |
| F4 | SHA-pinned but **no version comment** — frozen, never updated (§2) | IR002 | 14 | managed fleet, `publisher` | ATYA-026 |
| F6 | `actions/checkout@v4`, `actions/setup-dotnet@v4` in template CI | IR001 | 6 | `Atya.Templates.UiAutomation` | ATYA-026 |
| F7 | `checkout@v4`, `setup-node@v4`, `upload-pages-artifact@v3`, `deploy-pages@v4` | IR001 | 4 | `AtyaLibraries.github.io` | ATYA-040 |
| F8 | `actions/checkout@v4` in the policy-authority repository itself | IR001 | 2 | `platform` | ATYA-124 |
| F5 | `NuGet/login@v1` in `publish-template.yml` | IR001 | 1 | `Atya.Templates.NuGetPackage` | ATYA-026 |

Separately, and not a `uses:` reference:

| # | Finding | Owning repository | Remediated by |
| --- | --- | --- | --- |
| F1 | The drift check requires the mutable tag `@v1`, inverting this policy (§8) | `platform` | ATYA-124 |

F8 combined with F1 and F3 is worth stating plainly: the repository that audits the fleet
for policy compliance is itself non-conformant, in the very workflow that performs the
audit, while requiring a mutable tag of everyone else.

F4 is the finding most likely to be dismissed as cosmetic. It is not. Those 14 references
are the ones that will still be pinned to a 2026 commit in 2030.

`AtyaLibraries/github-workflows` is the one repository whose own references are fully
conformant: 13 of 13 SHA-pinned with version comments. It is the migration model for
everyone else.
