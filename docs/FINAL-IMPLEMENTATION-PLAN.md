# Final Implementation Plan — Public Edition

## Program goal

Modernize the AtyaLibraries ecosystem through the authoritative task graph while preserving repository ownership, compatibility, security, and auditable execution.

## Execution rules

- Hard dependencies alone determine Ready or Blocked.
- Advisory prerequisites do not block execution and require a documented caveat when bypassed.
- No task starts In Progress during import.
- Package implementation remains in the declared owning repository.
- Security-sensitive implementation uses private maintainer evidence and publishes only sanitized verification.
- Cleanup work remains gated by its declared audit dependencies.

## Phase overview

| Phase | Name | Tasks |
|---:|---|---:|
| 0 | Authoritative inventory and evidence |  |
| 1 | Source-of-truth policy and architecture decisions |  |
| 2 | Security, compatibility, and release blockers |  |
| 3 | Build, workflow, and release consolidation |  |
| 4 | Foundation and cross-cutting contracts |  |
| 5 | Messaging, data, web, and diagnostics hardening |  |
| 6 | Migration, documentation, templates, and adoption |  |
| 7 | Issue, PR, branch, and repository cleanup |  |
| 8 | Final fleet validation and closure |  |

## Complete task list

| ID | Title | Repository | Priority | Phase | Initial status | Hard dependencies |
|---|---|---|---|---:|---|---|
| [ATYA-001](../github/issues/ATYA-001-inventory-repositories-and-establish-the-machine-readable-ecosystem-ma.md) | Inventory repositories and establish the machine-readable ecosystem manifest | Atya.Roadmap | P0 | 0 | Ready | None |
| [ATYA-002](../github/issues/ATYA-002-phase-0-verification-batch-for-contested-findings.md) | Phase-0 verification batch for contested findings | Atya.Roadmap | P0 | 0 | Ready | None |
| [ATYA-003](../github/issues/ATYA-003-repair-the-release-graph-tree-parity-tag-ancestry-minver-provenance.md) | Repair the release graph: tree parity, tag ancestry, MinVer provenance | Atya.Roadmap | P0 | 0 | Blocked | ATYA-002 |
| [ATYA-004](../github/issues/ATYA-004-reconcile-the-constitution-with-the-live-portfolio-and-roadmap.md) | Reconcile the constitution with the live portfolio and roadmap | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-005](../github/issues/ATYA-005-publish-a-framework-target-and-support-policy-by-package-archetype.md) | Publish a framework-target and support policy by package archetype | Atya.Roadmap | P1 | 1 | Blocked | ATYA-001; ATYA-004 |
| [ATYA-006](../github/issues/ATYA-006-decide-the-strategic-time-model-timeprovider-vs-iclock.md) | Decide the strategic Time model (TimeProvider vs IClock) | Atya.Roadmap | P1 | 1 | Blocked | ATYA-005 |
| [ATYA-007](../github/issues/ATYA-007-resolve-iresult-and-narrow-foundation-abstractions.md) | Resolve IResult and narrow Foundation.Abstractions | Atya.Roadmap | P1 | 1 | Blocked | ATYA-004 |
| [ATYA-008](../github/issues/ATYA-008-canonicalize-result-error-paging-retire-the-orphan-primitives-system.md) | Canonicalize Result/Error/paging; retire the orphan Primitives system | Atya.Roadmap | P1 | 1 | Blocked | ATYA-003; ATYA-007; ATYA-042 |
| [ATYA-009](../github/issues/ATYA-009-define-the-framework-neutral-versioned-http-error-validation-wire-cont.md) | Define the framework-neutral versioned HTTP error/validation wire contract | Atya.Roadmap | P1 | 1 | Blocked | ATYA-008 |
| [ATYA-010](../github/issues/ATYA-010-ratify-the-test-platform-direction-mtp-vs-vstest.md) | Ratify the test-platform direction (MTP vs VSTest) | Atya.Roadmap | P3 | 1 | Ready | None |
| [ATYA-011](../github/issues/ATYA-011-decide-the-fluentassertions-7-x-end-of-life-strategy.md) | Decide the FluentAssertions 7.x end-of-life strategy | Atya.Roadmap | P3 | 1 | Ready | None |
| [ATYA-012](../github/issues/ATYA-012-decide-opentelemetry-package-decomposition-from-adopter-evidence.md) | Decide OpenTelemetry package decomposition from adopter evidence | Atya.Roadmap | P2 | 1 | Blocked | ATYA-066; ATYA-067; ATYA-032 |
| [ATYA-013](../github/issues/ATYA-013-repository-topology-adr-repo-per-package-vs-grouped-repos.md) | Repository-topology ADR (repo-per-package vs grouped repos) | Atya.Roadmap | P3 | 1 | Blocked | ATYA-026; ATYA-035 |
| [ATYA-014](../github/issues/ATYA-014-redact-result-based-5xx-problemdetails-by-default.md) | Redact Result-based 5xx ProblemDetails by default | ProblemDetails | P0 | 2 | Blocked | ATYA-002 |
| [ATYA-015](../github/issues/ATYA-015-make-health-responses-minimal-and-safe-by-default.md) | Make health responses minimal and safe by default | HealthChecks | P0 | 2 | Blocked | ATYA-002 |
| [ATYA-016](../github/issues/ATYA-016-split-the-publisher-trust-boundary-and-bind-packageid-repository.md) | Split the publisher trust boundary and bind PackageId→repository | publisher | P0 | 2 | Blocked | ATYA-001 |
| [ATYA-017](../github/issues/ATYA-017-remove-the-nuget-template-s-second-publishing-path.md) | Remove the NuGet template's second publishing path | Atya.Templates.NuGetPackage | P0 | 2 | Blocked | ATYA-002 |
| [ATYA-018](../github/issues/ATYA-018-make-release-artifacts-atomic-complete-and-attested-before-push.md) | Make release artifacts atomic, complete, and attested before push | publisher | P0 | 2 | Blocked | ATYA-016 |
| [ATYA-019](../github/issues/ATYA-019-one-immutable-workflow-reference-policy-fix-the-drift-audit-validator.md) | Define one immutable workflow and action reference policy | Atya.Roadmap | P1 | 2 | Blocked | ATYA-001 |
| [ATYA-020](../github/issues/ATYA-020-enforce-release-path-authorization-controls-solo-adapted.md) | Enforce release-path authorization controls (solo-adapted) | Atya.Roadmap | P1 | 2 | Blocked | ATYA-002 |
| [ATYA-021](../github/issues/ATYA-021-make-backgroundservices-consume-per-worker-validated-options.md) | Make BackgroundServices consume per-worker validated options | BackgroundServices | P1 | 2 | Blocked | ATYA-002; ATYA-006 |
| [ATYA-022](../github/issues/ATYA-022-unify-correlation-one-owner-bounded-policy-wired-end-to-end.md) | Unify correlation: one owner, bounded policy, wired end-to-end | Atya.Roadmap | P1 | 2 | Blocked | ATYA-019; ATYA-034 |
| [ATYA-023](../github/issues/ATYA-023-harden-http-client-protocol-and-payload-handling.md) | Harden Http.Client protocol and payload handling | Client | P1 | 2 | Blocked | ATYA-002; ATYA-022; ATYA-009; ATYA-052 |
| [ATYA-024](../github/issues/ATYA-024-replace-the-pat-dispatch-chain-with-a-github-app.md) | Replace the PAT dispatch chain with a GitHub App | Atya.Roadmap | P0 | 2 | Blocked | ATYA-016 |
| [ATYA-025](../github/issues/ATYA-025-codequality-overhaul-modern-analyzers-async-rules-packed-verification.md) | CodeQuality overhaul: modern analyzers, async rules, packed verification, charter | CodeQuality | P1 | 3 | Blocked | ATYA-002 |
| [ATYA-026](../github/issues/ATYA-026-roll-pinned-workflows-and-security-baselines-across-the-fleet.md) | Roll pinned workflows and security baselines across the fleet | Atya.Roadmap | P1 | 3 | Blocked | ATYA-019; ATYA-001; ATYA-124; ATYA-036 |
| [ATYA-027](../github/issues/ATYA-027-add-self-tests-for-reusable-workflows-and-composite-actions.md) | Add self-tests for reusable workflows and composite actions | github-workflows | P1 | 3 | Blocked | ATYA-019 |
| [ATYA-028](../github/issues/ATYA-028-test-and-harden-the-renovate-preset-verify-fleet-realization.md) | Test and harden the Renovate preset; verify fleet realization | renovate-config | P1 | 3 | Blocked | ATYA-002; ATYA-019 |
| [ATYA-029](../github/issues/ATYA-029-restore-release-notes-tag-nuget-api-baseline-traceability.md) | Restore release-notes/tag/NuGet/API-baseline traceability | Atya.Roadmap | P1 | 3 | Blocked | ATYA-003; ATYA-018 |
| [ATYA-030](../github/issues/ATYA-030-build-atya-build-sdk-conformance-fixtures-archetype-aware.md) | Build Atya.Build.Sdk conformance fixtures (archetype-aware) | Atya.Build.Sdk | P1 | 3 | Blocked | ATYA-027; ATYA-005; ATYA-025 |
| [ATYA-031](../github/issues/ATYA-031-bring-build-sdk-s-own-publishing-and-metadata-into-policy.md) | Recover Build.Sdk publishing and bring its release metadata into policy | Atya.Build.Sdk | P0 | 2 | Blocked | ATYA-020; ATYA-121 |
| [ATYA-032](../github/issues/ATYA-032-define-and-verify-dependency-range-and-packed-nuspec-policy.md) | Define and verify dependency-range and packed-nuspec policy | Atya.Roadmap | P1 | 3 | Blocked | ATYA-002; ATYA-030; ATYA-005 |
| [ATYA-033](../github/issues/ATYA-033-standardize-review-time-publicapi-governance.md) | Standardize review-time PublicAPI governance | Atya.Roadmap | P1 | 3 | Blocked | ATYA-030 |
| [ATYA-034](../github/issues/ATYA-034-repair-dependency-matrix-csproj-drift-and-machine-check-it.md) | Repair dependency-matrix ↔ csproj drift and machine-check it | Atya.Roadmap | P1 | 3 | Blocked | ATYA-001; ATYA-008 |
| [ATYA-035](../github/issues/ATYA-035-build-the-fleet-sdk-pin-roll-mechanism.md) | Build the fleet SDK-pin roll mechanism | Atya.Roadmap | P1 | 3 | Blocked | ATYA-003; ATYA-025; ATYA-030 |
| [ATYA-036](../github/issues/ATYA-036-fix-build-pack-nuget-for-root-csproj-template-packs.md) | Fix build-pack-nuget for root-csproj template packs | github-workflows | P1 | 3 | Blocked | ATYA-027 |
| [ATYA-037](../github/issues/ATYA-037-reusable-ci-multi-test-project-support-nuget-cache-drop-legacy-input.md) | Reusable CI: multi-test-project support, NuGet cache, drop legacy input | github-workflows | P2 | 3 | Blocked | ATYA-026; ATYA-027 |
| [ATYA-038](../github/issues/ATYA-038-repair-the-cli-archetype-aware-scanning-real-coverage-fail-safe-checks.md) | Repair the CLI: archetype-aware scanning, real coverage, fail-safe checks; release | Cli | P1 | 3 | Blocked | ATYA-001; ATYA-002 |
| [ATYA-039](../github/issues/ATYA-039-replace-platform-drift-javascript-with-cli-fleet-audits.md) | Replace platform drift JavaScript with CLI fleet audits | Atya.Roadmap | P1 | 3 | Blocked | ATYA-038; ATYA-019; ATYA-001; ATYA-124 |
| [ATYA-040](../github/issues/ATYA-040-make-the-public-site-truthful-reproducible-and-auto-deployed.md) | Make the public site truthful, reproducible, and auto-deployed | AtyaLibraries.github.io | P1 | 3 | Blocked | ATYA-001; ATYA-024; ATYA-019; ATYA-126 |
| [ATYA-041](../github/issues/ATYA-041-add-site-schema-component-accessibility-and-link-tests.md) | Add site schema, component, accessibility, and link tests | AtyaLibraries.github.io | P2 | 3 | Blocked | ATYA-040 |
| [ATYA-042](../github/issues/ATYA-042-make-foundation-results-deeply-immutable-and-nullability-honest.md) | Make Foundation.Results deeply immutable and nullability-honest | Results | P1 | 1 | Ready | None |
| [ATYA-043](../github/issues/ATYA-043-add-async-result-combinators.md) | Add async Result combinators | Results | P1 | 4 | Blocked | ATYA-042 |
| [ATYA-044](../github/issues/ATYA-044-define-the-result-serialization-stance.md) | Define the Result serialization stance | Results | P2 | 4 | Blocked | ATYA-042; ATYA-009 |
| [ATYA-045](../github/issues/ATYA-045-add-transport-relevant-errorkinds-unavailable-timeout-toomanyrequests.md) | Add transport-relevant ErrorKinds (Unavailable, Timeout, TooManyRequests) | Results | P2 | 4 | Blocked | ATYA-009 |
| [ATYA-046](../github/issues/ATYA-046-harden-primitives-invariants-and-stronglytypedid-serialization.md) | Harden Primitives invariants and StronglyTypedId serialization | Primitives | P1 | 4 | Blocked | ATYA-008 |
| [ATYA-047](../github/issues/ATYA-047-resolve-the-jsonserializerdefaults-bcl-name-collision.md) | Resolve the JsonSerializerDefaults BCL name collision | Serialization | P1 | 4 | Ready | None |
| [ATYA-048](../github/issues/ATYA-048-add-a-source-generation-and-aot-safe-serialization-path.md) | Add a source-generation and AOT-safe serialization path | Serialization | P2 | 4 | Blocked | ATYA-047; ATYA-005; ATYA-044; ATYA-046 |
| [ATYA-049](../github/issues/ATYA-049-make-enumerable-guards-non-destructive.md) | Make enumerable guards non-destructive | Guards | P1 | 4 | Blocked | ATYA-002 |
| [ATYA-050](../github/issues/ATYA-050-complete-guards-numeric-coverage-via-generic-math.md) | Complete Guards numeric coverage via generic math | Guards | P2 | 4 | Blocked | ATYA-049 |
| [ATYA-051](../github/issues/ATYA-051-make-governance-testing-fakes-implement-real-contracts.md) | Make Governance.Testing fakes implement real contracts | Testing | P1 | 4 | Blocked | ATYA-006; ATYA-008; ATYA-022 |
| [ATYA-052](../github/issues/ATYA-052-migrate-validation-problemdetails-and-client-to-the-one-validation-sch.md) | Migrate Validation, ProblemDetails, and Client to the one validation schema | Atya.Roadmap | P1 | 4 | Blocked | ATYA-009; ATYA-014 |
| [ATYA-053](../github/issues/ATYA-053-problemdetails-symmetric-customization-deterministic-mapping-configure.md) | ProblemDetails: symmetric customization, deterministic mapping, ConfigureAwait fix | ProblemDetails | P1 | 4 | Blocked | ATYA-009; ATYA-014; ATYA-045 |
| [ATYA-054](../github/issues/ATYA-054-exceptions-default-error-codes-validated-items-metadata-policy.md) | Exceptions: default error codes, validated items, metadata policy | Exceptions | P2 | 4 | Blocked | ATYA-052; ATYA-026 |
| [ATYA-055](../github/issues/ATYA-055-middleware-preserve-mapped-shapes-success-policy-idempotent-registrati.md) | Middleware: preserve mapped shapes, success policy, idempotent registration | Middleware | P1 | 4 | Blocked | ATYA-002; ATYA-053; ATYA-034 |
| [ATYA-056](../github/issues/ATYA-056-http-client-ergonomics-verb-conveniences-propagation-errorkind-map.md) | Http.Client ergonomics: verb conveniences, propagation, ErrorKind map | Client | P2 | 4 | Blocked | ATYA-023; ATYA-022; ATYA-045 |
| [ATYA-057](../github/issues/ATYA-057-idempotency-fenced-leases-abandon-on-exception-completion-policy-bound.md) | Idempotency: fenced leases, abandon-on-exception, completion policy, bounded store | Idempotency | P1 | 5 | Blocked | ATYA-006; ATYA-122; ATYA-051 |
| [ATYA-058](../github/issues/ATYA-058-outbox-atomic-claiming-stable-identity-backoff-diagnostics-hosting-rec.md) | Outbox: atomic claiming, stable identity, backoff, diagnostics, hosting recipe | Messaging.Outbox | P1 | 5 | Blocked | ATYA-059; ATYA-057; ATYA-006 |
| [ATYA-059](../github/issues/ATYA-059-evolve-messaging-abstractions-for-stable-durable-contracts.md) | Evolve Messaging.Abstractions for stable, durable contracts | Messaging.Abstractions | P1 | 5 | Blocked | ATYA-004; ATYA-033 |
| [ATYA-060](../github/issues/ATYA-060-define-messaging-inmemory-semantics-and-bound-its-history.md) | Define Messaging.InMemory semantics and bound its history | Messaging.InMemory | P2 | 5 | Blocked | ATYA-059 |
| [ATYA-061](../github/issues/ATYA-061-deepen-outbox-messaging-idempotency-scenario-tests.md) | Deepen Outbox/Messaging/Idempotency scenario tests | Atya.Roadmap | P2 | 5 | Blocked | ATYA-057; ATYA-058 |
| [ATYA-062](../github/issues/ATYA-062-fix-mediator-generator-discovery-lifetimes-and-packed-analyzer-verific.md) | Fix Mediator generator discovery, lifetimes, and packed-analyzer verification | Mediator | P1 | 5 | Blocked | ATYA-002; ATYA-033 |
| [ATYA-063](../github/issues/ATYA-063-mediator-pipeline-behaviors.md) | Mediator pipeline behaviors | Mediator | P1 | 5 | Blocked | ATYA-062; ATYA-043 |
| [ATYA-064](../github/issues/ATYA-064-mediator-notifications-feature-or-ratified-non-goal.md) | Mediator notifications: feature or ratified non-goal | Mediator | P2 | 5 | Blocked | ATYA-063 |
| [ATYA-065](../github/issues/ATYA-065-make-data-pagination-internally-coherent-and-immutable.md) | Make Data.Pagination internally coherent and immutable | Pagination | P1 | 5 | Blocked | ATYA-008; ATYA-042 |
| [ATYA-066](../github/issues/ATYA-066-normalize-observation-and-opentelemetry-options-exactly-once.md) | Normalize Observation and OpenTelemetry options exactly once | Atya.Roadmap | P1 | 5 | Blocked | ATYA-002 |
| [ATYA-067](../github/issues/ATYA-067-opentelemetry-remove-silent-options-add-production-controls.md) | OpenTelemetry: remove silent options, add production controls | OpenTelemetry | P1 | 5 | Blocked | ATYA-066 |
| [ATYA-068](../github/issues/ATYA-068-define-the-shared-telemetry-semantic-and-cardinality-policy.md) | Define the shared telemetry semantic and cardinality policy | Atya.Roadmap | P1 | 5 | Blocked | ATYA-066 |
| [ATYA-069](../github/issues/ATYA-069-correct-tracing-propagation-leakage-and-no-listener-cost.md) | Correct Tracing propagation, leakage, and no-listener cost | Tracing | P1 | 5 | Blocked | ATYA-068; ATYA-022 |
| [ATYA-070](../github/issues/ATYA-070-reduce-metrics-hot-path-allocations-and-unsafe-cardinality-defaults.md) | Reduce Metrics hot-path allocations and unsafe cardinality defaults | Metrics | P2 | 5 | Blocked | ATYA-068 |
| [ATYA-071](../github/issues/ATYA-071-make-logging-s-factory-and-scope-api-truthful.md) | Make Logging's factory and scope API truthful | Logging | P2 | 5 | Blocked | ATYA-033; ATYA-068 |
| [ATYA-072](../github/issues/ATYA-072-aot-trim-readiness-for-the-foundation-wave.md) | AOT/trim readiness for the Foundation wave | Atya.Roadmap | P3 | 5 | Blocked | ATYA-008; ATYA-007; ATYA-048; ATYA-005 |
| [ATYA-073](../github/issues/ATYA-073-fleet-readme-documentation-uplift-with-executable-checks.md) | Fleet README/documentation uplift with executable checks | Atya.Roadmap | P1 | 6 | Blocked | ATYA-004; ATYA-029 |
| [ATYA-074](../github/issues/ATYA-074-publish-the-starter-stack-guides.md) | Publish the starter-stack guides | Atya.Roadmap | P2 | 6 | Blocked | ATYA-022; ATYA-073 |
| [ATYA-075](../github/issues/ATYA-075-composition-readiness-gate-golden-reference-applications-admission-gat.md) | Composition readiness gate + golden reference applications + admission gates | Atya.Roadmap | P1 | 6 | Blocked | ATYA-013; ATYA-008; ATYA-009; ATYA-052; ATYA-014; ATYA-015; ATYA-017; ATYA-021; ATYA-022; ATYA-025; ATYA-051; ATYA-063 |
| [ATYA-076](../github/issues/ATYA-076-verify-the-nuget-template-from-its-packed-artifact.md) | Verify the NuGet template from its packed artifact | Atya.Templates.NuGetPackage | P1 | 6 | Blocked | ATYA-017; ATYA-026; ATYA-030 |
| [ATYA-077](../github/issues/ATYA-077-make-uiautomation-profile-options-real-or-remove-them.md) | Make UiAutomation profile options real or remove them | Atya.Templates.UiAutomation | P1 | 6 | Blocked | ATYA-025; ATYA-026; ATYA-036 |
| [ATYA-078](../github/issues/ATYA-078-make-ui-actor-leasing-fair-atomic-fenced-and-outcome-aware.md) | Make UI actor leasing fair, atomic, fenced, and outcome-aware | Atya.Templates.UiAutomation | P1 | 6 | Blocked | ATYA-077 |
| [ATYA-079](../github/issues/ATYA-079-deliver-atya-api-and-atya-microservice-templates-from-the-golden-compo.md) | Deliver atya-api and atya-microservice templates from the golden compositions | Atya.Roadmap | P1 | 6 | Blocked | ATYA-013; ATYA-075; ATYA-036; ATYA-037; ATYA-076; ATYA-010; ATYA-011 |
| [ATYA-080](../github/issues/ATYA-080-deliver-the-api-automation-and-integration-test-templates.md) | Deliver the API-automation and integration-test templates | Atya.Roadmap | P2 | 6 | Blocked | ATYA-013; ATYA-079; ATYA-078; ATYA-010; ATYA-011; ATYA-037 |
| [ATYA-081](../github/issues/ATYA-081-atya-api-gateway-decision-then-maybe-template.md) | atya-api-gateway: decision, then (maybe) template | Atya.Roadmap | P3 | 6 | Blocked | ATYA-004; ATYA-079 |
| [ATYA-082](../github/issues/ATYA-082-cli-atya-new-automated-repo-onboarding.md) | CLI atya new + automated repo onboarding | Cli | P2 | 6 | Blocked | ATYA-013; ATYA-038; ATYA-039; ATYA-024; ATYA-079; ATYA-080 |
| [ATYA-083](../github/issues/ATYA-083-openapi-admission-decision-and-delivery-from-the-reference-api.md) | OpenAPI: admission decision and delivery from the reference API | Atya.Roadmap | P2 | 6 | Blocked | ATYA-004; ATYA-009; ATYA-052; ATYA-075; ATYA-079 |
| [ATYA-084](../github/issues/ATYA-084-entity-framework-core-adapters-behind-provider-conformance-tests.md) | Decide admission and scope for Entity Framework Core adapters | Atya.Roadmap | P2 | 6 | Blocked | ATYA-058; ATYA-065; ATYA-075 |
| [ATYA-085](../github/issues/ATYA-085-resolve-exception-and-audit-middleware-without-duplicating-web-middlew.md) | Resolve exception and audit middleware without duplicating Web.Middleware | Middleware | P2 | 6 | Blocked | ATYA-052; ATYA-053; ATYA-022; ATYA-075 |
| [ATYA-086](../github/issues/ATYA-086-evaluate-a-provider-neutral-openfeature-integration.md) | Evaluate a provider-neutral OpenFeature integration | Atya.Roadmap | P3 | 6 | Blocked | ATYA-068; ATYA-075; ATYA-079 |
| [ATYA-087](../github/issues/ATYA-087-define-the-multitenancy-isolation-model-before-any-package.md) | Define the multitenancy isolation model before any package | Atya.Roadmap | P3 | 6 | Blocked | ATYA-022; ATYA-068; ATYA-075; ATYA-123 |
| [ATYA-088](../github/issues/ATYA-088-prove-signalr-integration-as-a-distinct-transport-adapter-or-template.md) | Prove SignalR integration as a distinct transport adapter (or template content) | Atya.Roadmap | P3 | 6 | Blocked | ATYA-009; ATYA-022; ATYA-075; ATYA-079 |
| [ATYA-089](../github/issues/ATYA-089-maintainer-continuity-and-account-recovery-plan.md) | Maintainer continuity and account-recovery plan | Atya.Roadmap | P2 | 6 | Ready | None |
| [ATYA-090](../github/issues/ATYA-090-audit-every-branch-and-default-branch-policy.md) | Refresh and verify every branch and default-branch policy before action | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-091](../github/issues/ATYA-091-detect-and-classify-every-unmerged-commit.md) | Refresh and verify every unmerged-commit classification before action | Atya.Roadmap | P1 | 0 | Blocked | ATYA-090 |
| [ATYA-092](../github/issues/ATYA-092-classify-every-open-pull-request.md) | Refresh and verify every open pull-request classification before action | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-093](../github/issues/ATYA-093-classify-every-failed-or-stale-ci-run.md) | Classify every failed or stale CI run | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-094](../github/issues/ATYA-094-inventory-and-classify-every-open-issue.md) | Refresh and verify every open-issue classification before migration | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-095](../github/issues/ATYA-095-audit-rulesets-branch-protection-and-release-controls.md) | Verify effective rulesets, branch protection, and release controls | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-096](../github/issues/ATYA-096-audit-tags-releases-and-nuget-publication-state.md) | Audit tags, releases, and NuGet publication state | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-097](../github/issues/ATYA-097-audit-security-and-dependency-alerts.md) | Audit security and dependency alerts | Atya.Roadmap | P1 | 0 | Blocked | ATYA-001 |
| [ATYA-098](../github/issues/ATYA-098-migrate-useful-existing-issues-into-standalone-atya-tasks.md) | Migrate useful existing issues into standalone ATYA tasks | Atya.Roadmap | P1 | 7 | Blocked | ATYA-094 |
| [ATYA-099](../github/issues/ATYA-099-close-duplicate-issues-with-canonical-links-and-reasons.md) | Verify that no duplicate issues require closure | Atya.Roadmap | P2 | 7 | Blocked | ATYA-094; ATYA-098 |
| [ATYA-100](../github/issues/ATYA-100-resolve-stale-and-superseded-issues-safely.md) | Resolve stale and superseded issues safely | Atya.Roadmap | P2 | 7 | Blocked | ATYA-094; ATYA-098 |
| [ATYA-101](../github/issues/ATYA-101-complete-or-migrate-relevant-pull-request-work.md) | Complete or migrate relevant pull-request work | Atya.Roadmap | P1 | 7 | Blocked | ATYA-092; ATYA-093 |
| [ATYA-102](../github/issues/ATYA-102-merge-or-migrate-relevant-branch-work.md) | Merge or migrate relevant branch work | Atya.Roadmap | P1 | 7 | Blocked | ATYA-003; ATYA-091; ATYA-101 |
| [ATYA-103](../github/issues/ATYA-103-delete-only-verified-merged-or-superseded-branches.md) | Delete only verified merged or superseded branches | Atya.Roadmap | P2 | 7 | Blocked | ATYA-091; ATYA-095; ATYA-102 |
| [ATYA-104](../github/issues/ATYA-104-enforce-the-master-development-and-default-branch-policy.md) | Enforce the master/development and default-branch policy | Atya.Roadmap | P1 | 7 | Blocked | ATYA-003; ATYA-090; ATYA-095; ATYA-103 |
| [ATYA-105](../github/issues/ATYA-105-resolve-every-classified-ci-failure.md) | Verify remediation of all eight audited repository failures | Atya.Roadmap | P1 | 7 | Blocked | ATYA-002; ATYA-031; ATYA-038; ATYA-093; ATYA-126; ATYA-127; ATYA-128; ATYA-129; ATYA-130 |
| [ATYA-106](../github/issues/ATYA-106-reconcile-tag-release-and-nuget-publication-discrepancies.md) | Coordinate and verify release-lineage discrepancy recovery | Atya.Roadmap | P0 | 2 | Blocked | ATYA-003; ATYA-018; ATYA-020; ATYA-031; ATYA-096; ATYA-131 |
| [ATYA-107](../github/issues/ATYA-107-remediate-or-accept-every-security-and-dependency-alert.md) | Remediate or accept every security and dependency alert | Atya.Roadmap | P1 | 7 | Blocked | ATYA-026; ATYA-028; ATYA-097; ATYA-125; ATYA-126 |
| [ATYA-108](../github/issues/ATYA-108-verify-issue-pr-and-branch-cleanliness.md) | Verify issue, PR, and branch cleanliness | Atya.Roadmap | P1 | 8 | Blocked | ATYA-099; ATYA-100; ATYA-101; ATYA-103; ATYA-104 |
| [ATYA-109](../github/issues/ATYA-109-validate-every-repository-for-release-readiness.md) | Validate every repository for release readiness | Atya.Roadmap | P1 | 8 | Blocked | ATYA-073; ATYA-105; ATYA-106; ATYA-107; ATYA-108 |
| [ATYA-110](../github/issues/ATYA-110-close-the-modernization-program-with-an-auditable-handoff.md) | Close the modernization program with an auditable handoff | Atya.Roadmap | P2 | 8 | Blocked | ATYA-075; ATYA-109 |
| [ATYA-111](../github/issues/ATYA-111-create-a-reproducible-read-only-audit-evidence-bundle.md) | Verify and import the reproducible read-only audit evidence bundle | Atya.Roadmap | P0 | 0 | Ready | None |
| [ATYA-112](../github/issues/ATYA-112-ratify-the-ecosystem-sensitive-data-classification-and-retention-model.md) | Ratify the ecosystem sensitive-data classification and retention model | Atya.Roadmap | P1 | 1 | Blocked | ATYA-111 |
| [ATYA-113](../github/issues/ATYA-113-drill-compromised-release-response-and-revocation.md) | Drill compromised-release response and revocation | Atya.Roadmap | P1 | 2 | Blocked | ATYA-016; ATYA-018; ATYA-112 |
| [ATYA-114](../github/issues/ATYA-114-enforce-dependency-license-compliance-in-release-evidence.md) | Enforce dependency-license compliance in release evidence | Atya.Roadmap | P1 | 3 | Blocked | ATYA-018; ATYA-032 |
| [ATYA-115](../github/issues/ATYA-115-rehearse-coordinated-major-upgrades-with-independent-adopters.md) | Rehearse coordinated major upgrades with independent adopters | Atya.Roadmap | P1 | 6 | Blocked | ATYA-052; ATYA-075; ATYA-112 |
| [ATYA-116](../github/issues/ATYA-116-complete-the-repository-by-dimension-evidence-matrix.md) | Complete the repository-by-dimension evidence matrix | Atya.Roadmap | P1 | 0 | Blocked | ATYA-111 |
| [ATYA-117](../github/issues/ATYA-117-establish-fleet-performance-baselines-and-regression-budgets.md) | Establish fleet performance baselines and regression budgets | Atya.Roadmap | P2 | 5 | Blocked | ATYA-030; ATYA-068 |
| [ATYA-118](../github/issues/ATYA-118-define-the-generated-project-update-lifecycle-and-atya-update-contract.md) | Define the generated-project update lifecycle and atya update contract | Atya.Roadmap | P2 | 6 | Blocked | ATYA-079; ATYA-082; ATYA-115 |
| [ATYA-119](../github/issues/ATYA-119-define-and-adversarially-test-the-golden-template-security-baseline.md) | Define and adversarially test the golden template security baseline | Atya.Roadmap | P1 | 6 | Blocked | ATYA-014; ATYA-015; ATYA-023; ATYA-075; ATYA-112 |
| [ATYA-120](../github/issues/ATYA-120-govern-readiness-classifications-and-adoption-claims.md) | Govern readiness classifications and adoption claims | Atya.Roadmap | P1 | 6 | Blocked | ATYA-001; ATYA-075; ATYA-116; ATYA-119 |
| [ATYA-121](../github/issues/ATYA-121-ratify-build-sdk-publisher-routing-and-exception-policy.md) | Ratify Build.Sdk publisher routing and release-recovery policy | Atya.Roadmap | P0 | 2 | Blocked | ATYA-016; ATYA-020; ATYA-036 |
| [ATYA-122](../github/issues/ATYA-122-decide-the-public-idempotency-completion-policy-default.md) | Decide the public idempotency completion-policy default | Idempotency | P1 | 5 | Blocked | ATYA-002; ATYA-008 |
| [ATYA-123](../github/issues/ATYA-123-implement-the-admitted-ef-core-outbox-adapter.md) | Implement the admitted EF Core outbox adapter behind provider conformance tests | Messaging.Outbox | P2 | 6 | Blocked | ATYA-084; ATYA-013 |
| [ATYA-124](../github/issues/ATYA-124-correct-and-fixture-test-platform-drift-sha-validation.md) | Correct and fixture-test platform drift SHA validation | platform | P1 | 2 | Blocked | ATYA-019 |
| [ATYA-125](../github/issues/ATYA-125-enable-and-govern-private-vulnerability-reporting.md) | Enable and govern private vulnerability reporting | Atya.Roadmap | P1 | 2 | Blocked | ATYA-112 |
| [ATYA-126](../github/issues/ATYA-126-remediate-the-public-site-s-vulnerable-vite-toolchain.md) | Remediate the public site's vulnerable Vite toolchain | AtyaLibraries.github.io | P0 | 2 | Ready | None |
| [ATYA-127](../github/issues/ATYA-127-migrate-and-verify-backgroundservices-release-dispatch.md) | Migrate and verify BackgroundServices release dispatch | BackgroundServices | P1 | 3 | Blocked | ATYA-018; ATYA-024 |
| [ATYA-128](../github/issues/ATYA-128-migrate-and-verify-idempotency-release-dispatch.md) | Migrate and verify Idempotency release dispatch | Idempotency | P1 | 3 | Blocked | ATYA-018; ATYA-024 |
| [ATYA-129](../github/issues/ATYA-129-migrate-and-verify-messaging-outbox-release-dispatch.md) | Migrate and verify Messaging.Outbox release dispatch | Messaging.Outbox | P1 | 3 | Blocked | ATYA-018; ATYA-024 |
| [ATYA-130](../github/issues/ATYA-130-migrate-and-verify-pagination-release-dispatch.md) | Migrate and verify Pagination release dispatch | Pagination | P1 | 3 | Blocked | ATYA-018; ATYA-024 |
| [ATYA-131](../github/issues/ATYA-131-recover-serialization-v1-0-1-release-lineage.md) | Recover Serialization v1.0.1 release lineage | Serialization | P0 | 2 | Blocked | ATYA-003; ATYA-018; ATYA-020 |

## Detailed specifications

Each linked issue specification is standalone. General tasks retain sanitized implementation prompts and acceptance criteria. Security-sensitive tasks use minimal public briefs and a private evidence reference.

## Program-level definition of done

- Every task reaches its accepted terminal state with evidence appropriate to its sensitivity.
- Declared compatibility, migration, testing, documentation, and rollback requirements are satisfied.
- No unresolved high-severity regression, ownership ambiguity, or untracked dependency remains.
- Public evidence contains no credential, private audit path, machine-specific data, or exploitable vulnerability reproduction.
