# Plan v2 (re-planned 2026-11-13)

Plan v2 supersedes `FINAL-IMPLEMENTATION-PLAN.md` for execution order. The earlier plan had 149 tasks, 8 closed, and was too heavy for one maintainer. Plan v2 keeps about 45 active tasks in three lanes. Small fixes are no longer blocked by ADRs or audits.

The live source of truth is the Project 5 **Status** field. The `status:*` labels mirror it.

## Rule

**No new packages or templates until ATYA-075 and ATYA-153 are done.**

## Lanes

| Lane | Priority | Tasks |
|---|---|---|
| NOW (P0, Ready, no hard dependencies) | P0 | 150, 151, 152, 017, 031, 131, 125, 089 |
| NEXT: FIXES | P1 | 021, 022, 023, 042, 047, 049, 053, 055, 057, 058, 062, 065, 069, 132–146 |
| NEXT: PROOF | P1 | 075, 148, 061, 153, 154, 013 |

NEXT: FIXES keeps only real code-order dependencies between tasks in the same repository. Those items are Blocked until that dependency is Done; the rest are Ready.

New tasks: ATYA-150 (release merged ATYA-014/015 fixes), 151 (credential-free release trigger), 152 (fleet hygiene sweep), 153 (first durable outbox and idempotency provider), 154 (revisit ADR-09).

## Disposition table

| Disposition | Status | Tasks |
|---|---|---|
| Recorded as decided (ADR-01, 02, 03), closed Done | Done | 005, 006, 007, 008 |
| Decision not in the register, kept open for the owner | Ready, P1 | 010, 011, 122 |
| Superseded by ATYA-151, closed not planned | Rejected | 127, 128, 129, 130, 024 (design retained for reference, not deployed) |
| Superseded by ATYA-031 | Rejected | 121 |
| Superseded by ATYA-152 | Rejected | 026, 028, 035, 124 |
| Superseded by ATYA-153 | Rejected | 084, 123 |
| Rejected: process overhead for a solo-maintained fleet; reopen on need | Rejected | 090–105, 108–118, 120 |
| Deferred: revisit when the reference API (ATYA-075) or an external adopter needs it | Deferred | 003, 004, 009, 012, 020, 025, 027, 029, 030, 032–034, 036–041, 043–046, 048, 050–052, 054, 056, 059, 060, 063, 064, 066–068, 070–074, 076–083, 085–088, 106, 107, 119, 147 |

ATYA-149 was never an issue; it existed only in pull request #85. ATYA-151 replaces the broker deployment.

Superseded items use Status Rejected and the `status:rejected` label. Deferred and Rejected items carry a link to this record as their decision-register reference.
