# Final Source Traceability — Public Edition

## Authority and complete-read register

| Source | Role | Coverage mechanism |
|---|---|---|
| Initial Prompt.txt | Requested scope and deliverables | Read completely; it contains governing requirements rather than enumerated source-item IDs, so its constraints are enforced by the task schema, cleanup program, and validator rather than counted as ledger rows. |
| 5.6 SOL - ecosystem-assessment.md | Primary SOL baseline | Read completely; 10 named assessment findings are represented once as `SOL-REV-001`…`SOL-REV-010`, with broader assessment decisions recorded in the decision register. |
| 5.6 SOL - prioritized-backlog.md | Primary SOL baseline | Read completely; all 72 `ATYA-xxxx` backlog items are represented once in the source ledger. |
| Fable-ECOSYSTEM-REVIEW-2026-07-18.md | Fable supplementary evidence | Read completely; 9 named review findings are represented once as `F-REV-001`…`F-REV-009`, with broader assessment decisions recorded in the decision register. |
| Fable-ECOSYSTEM-BACKLOG-2026-07-18.md | Fable supplementary evidence | Read completely; all 45 `ATYA-xxxx` backlog items are represented once in the source ledger. |
| CODEX-CROSS-MODEL-REVIEW-2026-07-18.md | SOL/Codex cross-review synthesis | Read completely; all 15 `DIS-xxx` and 10 `MISS-xxx` items are represented once in the source ledger. |
| CODEX-CONSOLIDATED-ECOSYSTEM-PLAN-2026-07-18.md | SOL/Codex cross-review synthesis | Read completely; all 73 `ECO-xxx` items are represented once in the source ledger. |
| CLAUDE-CROSS-MODEL-REVIEW-2026-07-18.md | Claude cross-review validation | Read completely; all 20 `DIS-xxx` items are represented once in the source ledger. |
| CLAUDE-CONSOLIDATED-ECOSYSTEM-PLAN-2026-07-18.md | Claude cross-review validation | Read completely; all 89 `ECO-xxx` items are represented once in the source ledger. |

## Coverage arithmetic

- SOL assessment findings: 10/10 rows, each exactly once.
- SOL backlog: 72/72 rows, each exactly once.
- Fable review findings: 9/9 rows, each exactly once.
- Fable backlog: 45/45 rows, each exactly once.
- Codex consolidated plan: 73/73 `ECO` rows, each exactly once.
- Claude consolidated plan: 89/89 `ECO` rows, each exactly once.
- Codex cross-review: 15/15 `DIS` rows and 10/10 `MISS` rows, each exactly once.
- Claude cross-review: 20/20 `DIS` rows, each exactly once.
- Total: `10 + 72 + 9 + 45 + 73 + 89 + 15 + 10 + 20 = 343` ledger rows.

The Claude consolidated origin lines enumerate all 117 distinct SOL/Fable items and explicitly identify split items. The final ledger preserves those mappings, then maps both consolidated plans and both disagreement registers to the final ATYA catalog. Section-level assessment findings and the final architecture-policy resolutions are recorded through DEC-001…DEC-040 and the task evidence fields.

The architecture review did not add source rows. It split existing rows across stable implementation IDs and four new decision/child IDs: ATYA-121 (Build.Sdk publisher-route ADR), ATYA-122 (idempotency completion-default ADR), ATYA-123 (admitted EF Core adapter implementation), and ATYA-124 (platform SHA-validator implementation). The 343-row total therefore remains unchanged. Claude DIS-020 now maps to ATYA-075 as well as ATYA-017 because it supplies the hard-versus-advisory composition-gate semantics.

## Traceability keys

- `S-xxxx` is the stable source-order alias for the corresponding SOL `ATYA-xxxx` backlog item.
- `F-xxxx` is the stable source-order alias for the corresponding Fable `ATYA-xxxx` backlog item.
- `Codex/Claude consolidated-ECO-xxx` and disagreement aliases are file-qualified because IDs repeat between sources.
- A semicolon-separated final ID list means the source item was deliberately split across a governing decision, primary implementation, or independently executable downstream migration; the source row still appears exactly once.


## Private audit boundary

General source-to-task coverage is public. Private audit source files, evidence paths, environment diagnostics, and private maintainer links are excluded.
