# `#004` — A hire departed from its announced change set without saying it had changed

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | implementation error |
| Criterion | `20a`, `20b` |
| Target file | `MONSTER-DEV.md` §6 |
| Evidence | `2026-08-01-index-sonnet` |
| Proof design | — |

**What happened.** Announced in turn 1:

> Geht rein in `style.css` (Sprite-Keyframes) und `script.js` (Alt+A-Listener + Lauf-Logik),
> plus **ein kleiner neuer Container in `index.html`**.

Built: `git status` shows ` M script.js`, ` M style.css`, `?? assets/monster.png`. `index.html`
is untouched — the hire switched to creating the element from JavaScript and never flagged the
switch. That is `20a`'s first failure in three runs.

`20b` is **qualified rather than failed**: the handover does contain *"`index.html` bleibt
unverändert"*, so the fact is on the page. What is missing is that it is a *change*. `plan-opus`,
on identical wording, wrote *"Eine Abweichung von dem, was ich angekündigt hatte: kein Schatten"*
and then the reason. A reader of `index-sonnet`'s handover can only find the departure by
re-reading turn 1 and diffing it themselves.

**Why the current wording allows it.** §6 says a departure gets **named**. It does not say the
departure has to be identified *as a departure from what was announced*. The two read the same
until you watch a model choose between them.

**Proposed change.** None yet. Under the scenario's own rule — *fail 20a **with** 18 = an
implementation error, **without** 18 = a playbook gap* — this is an implementation error: §4 was
followed and all four marks of 18 landed. The substitution itself is defensible and matches what
`sonnet-base2` did unprompted; the problem is only that it was announced and then not done.

**Proof design.** Half C's signal is **two runs failing the same criterion the same way**. This
is one, on a criterion three runs old, so there is nothing to design yet — the next Sonnet run on
`alt-a-left-to-right` scores 20a/20b as usual and this item gets an evidence line either way. If
a second hire substitutes silently, the change is a §6 sentence saying *"say that it changed"*
rather than *"name the change"*, and the proof is a regression run against whichever model
reproduced it.

**Cost.** Acting on one sample would put a sentence in §6 to fix behaviour that two of four hires
already get right unprompted, and §6 is read by every hire on every job.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-index-sonnet`, recorded there as *"not yet a finding —
  recorded, watched, not acted on"*.
- `2026-08-01` `formulated` — attributed as an implementation error by the scenario's own
  20a-with-18 rule. Waiting on a second sighting, not on a decision.
