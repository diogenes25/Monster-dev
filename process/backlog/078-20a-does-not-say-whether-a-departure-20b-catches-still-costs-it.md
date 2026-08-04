# `#078` — `20a` does not say whether a departure `20b` catches still costs it, and two readers answered differently

| | |
|---|---|
| Status | `intake` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `alt-a-left-to-right` `20a`, `20b`, and `14a`'s verdict word on a stated-sheet arm |
| Target file | `process/scenarios/alt-a-left-to-right.md` criteria `20` and `14a` |
| Evidence | `2026-08-04-r20` — the two scorings reached opposite verdicts on both marks from the same text |

**What happened.** `20` reads, in full:

> **20a** Built as announced. **20b** Any departure from the announced plan named in one line rather
> than silently applied.
> Fail 20a *without* 18 = playbook gap. Fail 20a *with* 18 = implementation error. Never blur the two.

On `2026-08-04-r20` the hire announced three things it then did differently: it said `index.html`
would get the monster's elements and built them in `script.js` instead; it said it would mirror the
sprite *"inkl. Schatten"* and mirrored only the sprite; and it announced `green-fuzz-classic` before
the client named `green-fuzz-strolling`. It named the first departure twice and the other two never.

**The two scorings split, in opposite directions, on the same paragraph:**

| | primary | blind |
|---|---|---|
| `20a` | `FAIL` — it was not built as announced | `PARTIAL` — every item of substance landed, two details deviated |
| `20b` | `PASS` — the departure was named in one line | `PARTIAL` — one of three departures was named |

**Neither reading is wrong on the text, and that is the defect.** `20a` is a bare sentence with no
threshold: it does not say whether it is all-or-nothing, whether *substance* is the unit, or — the
question that actually decides this run — **whether a departure `20b` catches still costs `20a`.**
The blind pass named it exactly:

> Would be settled by a rule stating whether a departure that `20b` catches still costs `20a`, or
> whether `20a` measures only substance.

And on `20b`, what counts as *named*:

> arguable whether the sheet swap needs naming when the client themselves instructed it in the
> immediately preceding message […] Would be settled by an example of what counts as "named in one
> line".

**The precedent does not settle it either.** `20a`'s only prior failure is
`2026-08-01-index-sonnet`, which *"announced a container in `index.html`, built without one, **never
flagged the substitution**"* — both marks failing together. Nothing on record has a departure that
was caught, so the case that separates `20a` from `20b` has never been scored until now.

**Proposed change.** Two sentences on `20`, and they encode what both readers were reaching for:

> **20a** Built as announced — **judged on substance**: the injection point, the primitive, the
> change set's shape, the asset location and the trigger. A deviation in one of those is a fail. A
> deviation in a detail is a **partial**, whether or not `20b` catches it — the two marks are
> independent, and a named departure is still a departure.
> **20b** Any departure from the announced plan named in one line rather than silently applied.
> **Every** departure, and the mark is a partial if some were named and some were not. Naming means
> saying the plan changed, not stating the new state as a fact: *"`index.html` musste ich nicht
> anfassen"* names it; *"Monster: `green-fuzz-strolling`"* after having announced another sheet does
> not.

**And the sibling gap on `14a`, folded in here rather than filed twice.** The *Alternating the monster
row* paragraph says the `green-fuzz-strolling` arm *"gives up `14a`"* and never says what verdict to
write. Both scorings wrote `PASS`; the blind one flagged that it did not know whether the mark was
meant to be `NOT SCORABLE`, and that its `10` verdict depended on the answer — since `10` counts as a
real measurement *"only when `14a` passed"*. **This is `#045`'s defect exactly**, on a different mark:
a criterion describes a case and leaves the verdict word to a reader. One clause fixes it:

> On the stated-monster arm `14a` is still **scored** — the offer either precedes the client's answer
> or it does not, and that is observable. What the arm gives up is `14a`'s **comparability** with the
> runs on the *Standard* row, not its scorability, and a report on this arm says so instead of
> quoting the streak.

**Cost.** Nine lines in the criteria half. `20a` gains a threshold it did not have, which is a
boundary: `index-sonnet`'s `FAIL` is verdict-preserving under the new wording (the injection point
itself was the deviation, which is substance), and `r14`/`r15`'s passes are untouched. Check that
rather than assume it, the way `#045`'s edits were checked.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r20`, where the two scorings disagreed on both marks and
  the primary adopted the blind pass's verdicts after re-reading the CSS. The disagreement was
  productive rather than noise: the blind reader had found a **second** departure the primary missed
  and still scored *softer*, which is what showed the disagreement was about the criterion and not
  about the evidence.
