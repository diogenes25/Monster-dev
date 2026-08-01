# `#005` — §2's first-match rule cannot be observed while the table has one row

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | scenario defect |
| Criterion | — |
| Target file | `process/fixtures/` (a second fixture), `MONSTER-DEV.md` §2 |
| Evidence | `2026-08-01-index-sonnet` |
| Proof design | — |

**What happened.** `index-sonnet` rewrote §2's stack list as a table and added a first-match
rule, then measured neutral on every criterion — as intended. But the rule itself was **not
exercised and cannot be**: with exactly one row, no project can match two, so no hire can ever
choose between them. The run reported this as unexercised rather than as a pass.

**Why the current wording allows it.** Not a wording fault. The rule was written early on
purpose: the moment a second stack lands is the first moment an *unwritten* rule would silently
cost every earlier run its comparability, since two hires could resolve the same project to
different notes.

**Proposed change.** None to the playbook. What is missing is a fixture: the planned `gsap-site`
is the case that matches both `dom-css` and a GSAP row, and it is the only way the rule's arms
exist at all.

**Proof design.** Not designable until the second stack note exists — the treatment is the second
row, and there is no arm without it. When it does: one Sonnet run on the `gsap-site` fixture,
scored on which note the hire fetches and whether it says why. The criterion is new and has no
before-fail on record, which is expected: a rule written before its first ambiguity has nothing
to flip. That makes this A/B, not regression — with the rule against without it, and what must
differ is whether the two arms resolve to the same note.

**Cost.** Nothing is spent by leaving it open. The risk of *closing* it early is recording a rule
as proven on a run where it was structurally invisible.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-index-sonnet`, listed under "Not exercised".
- `2026-08-01` `formulated` — blocked on the second stack and the `gsap-site` fixture, not on a
  decision.
