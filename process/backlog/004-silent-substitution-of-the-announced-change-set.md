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

**Proposed change.** None applied, and that is unchanged: under the scenario's own rule — *fail 20a
**with** 18 = an implementation error, **without** 18 = a playbook gap* — this is an implementation
error. §4 was followed and all four marks of 18 landed. The substitution itself is defensible and
matches what `sonnet-base2` did unprompted; the problem is only that it was announced and then not
done. **One sighting is not a finding**, and acting on it would put a sentence in §6 to correct
behaviour two of four hires already get right unprompted.

*Drafted, not proposed (answer **E4**).* `#002` also edits §6, in the opposite direction, and §6
should be edited once by someone holding both intentions. So the sentence this item would want is
written down now, to be picked up whole if a second hire substitutes silently — replacing §6's
current *"If an answer overturns part of what you said in step 4, build the changed thing and name
the change in one line"*:

> If what you build differs from what you said in step 4 — because an answer overturned it, or
> because you found a better way once you were in the code — say **that it changed**, not just what
> you did. One line: what you announced, what you built instead, why. The client cannot notice a
> substitution they have to diff turn 1 to find.

Two things in that draft are wider than the sentence it replaces, and both come from the evidence
above rather than from taste. The current clause fires only when *an answer* overturns the plan;
`index-sonnet` changed its own mind, which the clause does not cover. And *"name the change"* is
satisfied by *"`index.html` bleibt unverändert"* — a true statement about the end state that never
says a plan was departed from, which is exactly the `20b` qualification recorded above.

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
- `2026-08-02` — **E4**: the sentence is drafted above and the item does **not** move. §6 is edited
  once, with `#002`'s arm B, by whoever holds both intentions. Drafting it found a second gap in the
  current clause that the original write-up did not name: it fires only when *an answer* overturns
  the plan, and `index-sonnet` overturned its own.
