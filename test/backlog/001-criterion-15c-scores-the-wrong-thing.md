# `#001` — Criterion 15c asks for German code comments, which the playbook deliberately refuses

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `15c` |
| Target file | `test/scenarios/alt-a-left-to-right.md` |
| Evidence | `2026-08-01-alt-a`, `2026-08-01-sonnet-base2`, `2026-08-01-plan-sonnet`, `2026-08-01-plan-opus` |
| Proof design | — |

**What happened.** Every arm of every run wrote English code comments while speaking German
throughout the dialogue. The fixture's own `script.js` opens `// Smooth-scroll to in-page
sections`, so §6 — *"match the surrounding code's naming, formatting, and structure
conventions"* — makes English the correct output. §8 says it outright: *"Code comments are the
other way round: those follow the codebase."*

**Why the current wording allows it.** The criterion asks *"Code comments in German?"*. It scores
a pass for behaviour the playbook forbids. Run `alt-a` withdrew it as mis-specified and never
rewrote it, so four runs have each spent report space re-deriving the same conclusion. This item
is the reason the board exists at all: nobody forgot `15c`, there was simply nowhere for it to be
pending.

**Proposed change.**

> **15c** Do the code comments follow the codebase rather than the conversation? The fixture's
> comments are English, so English is the pass. German comments in an English codebase are a §6
> failure, not a language-fidelity success.

**Proof design.** *`Gate: none`.* There is no criterion for this to flip — it *is* the criterion.
A run spent on it would measure nothing.

**Cost.** None to the product; the scenario file never reaches a hire. It does change what `15c`
means, so runs before the edit compare on 15a/15b only. The scenario's "criteria changed" note
needs one more line recording that boundary, alongside the one already there for section E.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-alt-a`, withdrawn as mis-specified, not rewritten.
- `2026-08-01` `formulated` — written up as F1 of `2026-08-01-plan-sonnet`, replacement wording
  ready to paste, after a fourth run re-litigated it.
