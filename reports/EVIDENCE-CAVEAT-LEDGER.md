# Evidence caveat ledger

Standing caveats recorded under the advisory-bypass convention in
`github/PROJECT-BOARD-SPEC.md`. Each entry records the missing evidence, the accepted
risk, the approver, and the follow-up. Tasks reference an entry here rather than
restating the caveat individually.

---

## CAVEAT-001 — `AUDIT-SEC-*` references are sanitization placeholders, not retrievable evidence

**Recorded:** 2026-07-26
**Approver:** maintainer (`aasulyan`)
**Status:** accepted, standing — applies to every affected task without re-approval

### Missing evidence

Generated issue specifications and imported issue bodies carry a line of the form
`Private evidence reference: AUDIT-SEC-NNN`, and an implementation-guidance step
instructing the implementer to "obtain the private evidence from an authorized
maintainer before changing the affected trust boundary."

These identifiers are **not retrievable artifacts**. They are placeholders emitted by the
roadmap publication pipeline at the points where detail was stripped during
sanitization. `reports/PUBLICATION-SANITIZATION-REPORT.md` records the mechanism
directly: *"Private evidence references removed or generalized: 8."* No private channel
exists from which an `AUDIT-SEC-NNN` reference can be obtained, because no underlying
document is indexed by that identifier.

### Accepted risk

Security-classified tasks are executed without cross-confirmation against a private
audit finding. The security facts for each task are established instead by reading the
repository source directly, and the implementer records what was verified. The residual
risk is that a defect present in the original private analysis, but not observable in
source, goes unaddressed. This risk is accepted.

### Standing rule

- No task is ever blocked on obtaining an `AUDIT-SEC` reference.
- No `AUDIT-SEC` reference is requested from the maintainer or routed to a worker.
- Every Work Order strips the instruction "obtain AUDIT-SEC-NNN through the private
  maintainer channel" and substitutes: *"No private evidence exists for this task.
  Establish the security facts by reading the repository source directly and record what
  you verified."*
- The acceptance criterion "the private evidence reference is updated by maintainers" is
  satisfied by this ledger entry and is not carried as an open item.

### Affected tasks (25)

ATYA-002, 014, 015, 016, 017, 018, 019, 020, 024, 026, 031, 097, 107, 109, 113, 119,
121, 124, 125, 126, 127, 128, 129, 130, 131.

### Follow-up

None. This caveat is terminal by maintainer ruling.

### First application

ATYA-015 (Make health responses minimal and safe by default) was implemented and merged
without `AUDIT-SEC-015`. The remediation was built against the public required outcome
and direct source inspection, verified by the Conductor against the merged commit, and
accepted by the maintainer on 2026-07-26. Issue closed 2026-07-26T19:24Z with an
evidence caveat; PR #6 merged to `development` as `d000a719`.
