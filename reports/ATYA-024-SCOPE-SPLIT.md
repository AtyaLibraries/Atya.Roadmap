# ATYA-024 scope split

Date: 2026-07-27

Public issue: [#17 — ATYA-024](https://github.com/AtyaLibraries/Atya.Roadmap/issues/17)

## Why

ATYA-024 was defined as "Replace the PAT dispatch chain with a GitHub App" — a single task
spanning design, implementation, deployment, and cutover. Its design and implementation
half is finished and merged. Its deployment half cannot start: seven infrastructure inputs
are unconfirmed, and every remaining step is an irreversible credential operation requiring
maintainer authorization.

That left the task in a state it could not leave. It could never be honestly closed,
because the PAT is still in use; and it could never be honestly called incomplete, because
the work that was actually assigned to an implementer is done. Meanwhile four downstream
migrations declared a hard dependency on ATYA-024, when what they actually require is a
**live** broker — something a designed-but-undeployed broker does not provide.

The split makes the terminal state truthful and the dependency edges accurate.

## What moved

| | ATYA-024 (kept) | ATYA-149 (new) |
|---|---|---|
| Title | Design and build the GitHub App dispatch broker | Deploy the GitHub App dispatch broker and retire the PAT |
| Owning repository | `Atya.Roadmap` | `platform` |
| Type | Implementation | Migration |
| Priority / Risk | P0 / Critical | P0 / Critical |
| Phase | 2 | 2 |
| Effort | M | L |
| Hard dependencies | ATYA-016 | ATYA-024 |
| Scope | App registration contract, OIDC and dispatch contract, threat model, broker implementation and security suite, deployment-only Bicep, migration template, validators and fixtures, sanitized ledger | Azure provisioning, App registration and installation, key generation and Key Vault import, transient-copy destruction, broker deployment, dry-run and token-probe and live-dispatch checkpoints, cutover of 29 source workflows, PAT revocation |
| Can an agent complete it? | Yes — merged artifacts satisfy every criterion | **No.** Gated on seven maintainer-supplied inputs and per-operation authorization |

Nothing was deleted. Every acceptance criterion that previously sat in ATYA-024 either
remained there in a form satisfiable by merged artifacts, or moved verbatim in intent to
ATYA-149.

## Dependency edges changed

| Task | Before | After |
|---|---|---|
| ATYA-127 | ATYA-018; **ATYA-024** | ATYA-018; **ATYA-149** |
| ATYA-128 | ATYA-018; **ATYA-024** | ATYA-018; **ATYA-149** |
| ATYA-129 | ATYA-018; **ATYA-024** | ATYA-018; **ATYA-149** |
| ATYA-130 | ATYA-018; **ATYA-024** | ATYA-018; **ATYA-149** |
| ATYA-149 | — | ATYA-024 *(new edge)* |

Each was changed in all three places that record it: the `Dependencies` column of
`github/PROJECT-ITEMS.csv`, the metadata table and `## Dependencies` section of the issue
spec, and the `dependencies` field of the manifest `tasks[]` entry. The four tasks keep
ATYA-024 in their `Related tasks` list, which remains true — the broker design is still
related to them; it is simply no longer what gates them.

## Graph integrity

`scripts/Test-RoadmapGraph.ps1` was added to make this checkable rather than asserted. No
validator for the manifest or project items existed before; that is stated plainly because
the alternative is implying a check that was never run.

The script fails on dangling ID references, dependency cycles, missing issue files, and
disagreement between the CSV, the spec metadata table, and the manifest. It reports — but
does not fail on — the manifest coverage gap described below, because that condition
predates this change.

## Pre-existing condition found, not fixed

`github/PROJECT-MANIFEST.json` is internally inconsistent, and was before this change. Its
`tasks[]` array and every `by_*` breakdown describe a 131-task snapshot, while
`counts.tasks` and `spreadsheet_runtime_verified.project_items` were advanced to 148 when
ATYA-132..148 were added. Those 17 tasks were never added to `tasks[]`.

This change did not repair that gap, which belongs to whoever added ATYA-132..148. It did
keep every counter moving in step with the thing it actually counts: `tasks[]` and the
`by_*` breakdowns advanced by one for ATYA-149, and `counts.tasks` and
`spreadsheet_runtime_verified.project_items` advanced by one for the new CSV row. The gap
is therefore unchanged at 17, not widened.

ATYA-149 **was** added to `tasks[]`, and had to be: ATYA-127..130 are in `tasks[]` and now
reference ATYA-149, so omitting it would have created a dangling reference inside the
manifest — the exact invariant this split exists to protect.

## References that are now stale and were left alone

These are outside the authorized scope of this amendment. They are recorded here so the
decision is visible rather than lost.

| Location | Issue | Suggested owner |
|---|---|---|
| `ATYA-040` metadata, line 17 | Hard-depends on ATYA-024, but its acceptance criterion needs a live dispatch. Same class of defect this split fixed for ATYA-127..130. | maintainer decision |
| `ATYA-040`, line 111 | "A successful ATYA-024 authenticated dispatch triggers refresh" — after the split ATYA-024 produces no dispatch. | maintainer decision |
| `ATYA-040`, lines 12 and 73 | Lists ATYA-024 as a child migration task; the migration is now ATYA-149. | maintainer decision |
| `ATYA-082` metadata, line 13 | Hard-depends on ATYA-024. Whether CLI onboarding needs a live broker or only the contract is a judgment the maintainer should make. | maintainer decision |
| `reports/ATYA-018-IMPLEMENTATION.md`, line 115 | States "ATYA-130 on ATYA-024". Now inaccurate, but it is a point-in-time completion record. | leave as history |

`reports/ATYA-024-IMPLEMENTATION.md` and `docs/ATYA-024-GITHUB-APP-DISPATCH.md` were both
annotated with a split notice rather than rewritten, for the same reason: they are records
of what was true when written.

## Compatibility, migration, and rollback

No package, public API, workflow, or credential is affected. This amendment changes roadmap
metadata only.

Rollback is a branch revert. Because ATYA-149 is referenced by four other tasks, a partial
revert — removing ATYA-149 while leaving ATYA-127..130 pointing at it — would produce
exactly the dangling reference `Test-RoadmapGraph.ps1` now catches. Revert the whole
amendment or none of it, and run the graph validator afterwards either way.

## What this does not do

No GitHub issue was created for ATYA-149; the spec file is the deliverable and issue
creation is the maintainer's. No board field was changed, no `status:*` label touched, and
issue #17 was not closed. ATYA-024's `Initial status` remains `Blocked` as an import-time
record.
