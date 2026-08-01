# Retro-scoring: criteria 18–21 against the six archived runs

Phase 2 of the knowledge-concept plan proposes a **plan step** in §4 — Monster-Dev says what it
found before it asks what it cannot know. Before spending anything on a run, the four proposed
criteria were scored against every transcript already on disk, under
`~/.claude/projects/*monster-dev-testruns-*/`.

Scored from the hire's **cli-turn-1 text only**, i.e. everything said before the customer's
second message. Where the hire edited files during turn 1, the plan marks score **fail**
regardless of content: an announcement after the build is a changelog, not a plan.

No money was spent producing this file.

## Two things the runs are not comparable across

**The dialogue protocol changed.** `alt-a`, `phase1`, `phase2` and `sonnet-base` ran under
„stell deine Fragen in der **Abschlussnachricht** und stoppe" — the harness sentence that reads
as *questions come after the work*. `phase2b` and `live` ran under the corrected wording. Any
before/after judgement about *timing* across that boundary measures the harness.

**The roster arrived mid-series.** `alt-a`, `phase1`, `phase2` and `sonnet-base` predate the §5
table, so 18d has nothing to score and is marked n/a rather than fail.

## Scores

| Run | Model | Protocol | 18a inject | 18b primitive | 18c change set | 18d sheet | 19 one round | 21 no notes talk |
|---|---|---|---|---|---|---|---|---|
| `alt-a` | Opus | old | ✗ | ✗ | ✗ | n/a | ✗ | n/a |
| `phase1` | Opus | old | ✗ | ✗ | ✗ | n/a | ✗ | n/a |
| `phase2` | Opus | old | ✗ | ✗ | ✗ | n/a | ✗ | n/a |
| `sonnet-base` | Sonnet | old | ✗ | ✓ | ✗ | n/a | ✓ | ✓ |
| `phase2b` | Opus | current | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| `live` | Opus | current | ✗ | ✓ | ✗ | ✗ | ✓ | ✓ |

The first three fail on the worktree rule, not on content. `phase1` in particular
produced *every* piece of information criterion 18 asks for — injection point, primitive, a
file-by-file change table, the derivation of the duration — in a closing report, after
`style.css` and `script.js` had already been edited. **The content was never the missing part.
The timing was.**

## The finding that changes the framing

The plan was written on the premise *"Opus writes the plan unprompted, Sonnet does not"*, which
would make this a model-disposition fix. The two runs under the current protocol refute it:

- `phase2b` scores **4/4** on 18. Verbatim: *"**Injection-Point:** es gibt nur eine Seite —
  `index.html` direkt, CSS nach `style.css`, Trigger-Logik nach `script.js`, genau wie der
  bestehende Smooth-Scroll-Handler."* and both sheets with *"23 Frames, 0,96 s Zyklus"* /
  *"17 Frames, 0,71 s Zyklus"*.
- `live` scores **1/4**. Same model, same fixture, same brief, three hours apart. It names the
  primitive and the asset folder, gives frame counts without cycle times, and never states an
  injection point or a change set.

So the spread is not between models — it is **within one model on identical wording**. §4 does
not ask for a plan, so whether a hire produces one, and how complete it is, is currently left to
chance. That is a weaker claim than "closing a hole on the bar model" and a stronger one than
"pinning down a disposition": the output is unspecified, and unspecified output varies.

**One alternative explanation, deliberately not dismissed.** `live` ran over real
`raw.githubusercontent.com` URLs while `phase2b` read a local mirror. Fetching over the network
may have consumed the effort that went into `phase2b`'s analysis. That confound is the reason
Phase 2's own runs use the **mirror**: it matches `phase2b`, the run they are compared against.

## Criterion 21 has a before-fail on record

`phase2b`: *"Das entspricht dem Stack `dom-css`, für den es Notizen aus früheren Jobs gibt
(gelesen)."* The `dom-css` note has no measured pitfalls, so this sentence reports that a file
was read. That is bookkeeping from this side of the fence, and it tells the client nothing.
`live` and `sonnet-base` did not do it.

## What this predicts for the run

- 18b is the one mark that already passes reliably (3/3 where scorable). The §4 rewrite should
  not expect to flip it, and a report claiming credit for it would be wrong.
- 18a, 18c and 18d are the marks with room. **18a and 18c fail on the bar model.**
- 19 already passes under the corrected protocol on both models — it is a **risk criterion**,
  there to catch a rewrite that accidentally buys completeness with a second round.
- 21 has a genuine before-fail, but on Opus only.

And Sonnet has **never** been measured under the corrected protocol — `sonnet-base` predates it,
so the one Sonnet row in the table above was scored under the biased harness sentence. That gap
is what `sonnet-base2` exists to close, and it has to be closed before the playbook moves.
