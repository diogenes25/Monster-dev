# `#028` — criterion `11`'s new second half fails the reduced-motion behaviour §5 actually asks for

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `11` |
| Target file | `process/scenarios/alt-a-left-to-right.md` |
| Evidence | `index.html` measured `2026-08-02` with `prefers-reduced-motion` emulated for the first time; seven reports on record, split |
| Proof design | — |

**What happened.** Criterion `11` was rewritten on `2026-08-02` so that reduced motion is measured
rather than read off the stylesheet. The new wording has two marks: the monster **does not travel**,
and it **does not stay on screen indefinitely**. The very first measurement — against `index.html`,
the published `dom-css` reference, before any hire was involved — returns:

```json
"reducedMotion": { "travelledPx": 0, "stillOnScreenAfterCrossing": 1 }
```

First mark passes, second fails. `index.html:97-98` is the reason and it is deliberate:

```css
.walker { animation: none; transform: translateX(40vw); }
.monster { animation: none; }
```

With `animation: none` the `forwards` fill never applies, so the walker stands at 40 vw and stays
there for the life of the page.

**Why the current wording allows it.** The playbook does not ask for it to leave. `MONSTER-DEV.md`
§5: *"Respect a reduced-motion preference if the platform has one. **Something visible and still**
beats something that moves for a user who asked for less motion."* Visible and still is exactly
what the reference does. The second mark was added because an easter egg parked on the page for
good reads as a bug, which is a defensible opinion and is **not in the playbook** — so the
criterion scores against behaviour the product prescribes.

That is `#001`'s shape, arriving in a criterion rewritten to fix a different defect. `#001` was
`15c` asking for German comments where §6 and §8 require English; this is `11` asking the monster
to leave where §5 asks it to stand still. Both were written from what the scenario's author
expected rather than from what the playbook says.

**The archive is split, which is the reason not to settle it by taste.** Of the seven runs on
record, three describe the monster leaving — `live` (*"leaves after 4 s"*), `phase2` (*"stands
visible, then leaves"*), `phase2b` (*"leaves after 2.5 s"*) — and two record a JS branch that
removes the element on a timer, `alt-a` and `phase1`. Those five would pass the second mark. The
remaining two, `sonnet-base` and `plan-sonnet`, record only that a reduce branch exists, so nobody
knows what they do. The reference implementation is now the one thing that has been measured, and
it fails. Hires are doing two different things because the playbook permits two different things.

**Proposed change.** Three options, and the choice is the owner's:

> **(a) Drop the second mark.** `11` becomes *"with reduced motion emulated, `travelledPx` is 0"*
> and nothing else. Matches §5 exactly. Costs nothing and measures less: a monster that appears and
> never leaves scores the same as one that behaves.
>
> **(b) Keep the mark and say so in §5.** One sentence in the playbook — *"and let it go away
> again; a still monster that never leaves is a bug, not an accessibility feature"* — after which
> the criterion is measuring the playbook rather than the author. This is a **playbook wording**
> change and therefore `Gate: run`: fold it in, rerun, the criterion must flip on a hire that
> currently leaves it standing. `index.html` and the `dom-css` note change with it.
>
> **(c) Record it, score it separately.** `11a` travel, `11b` disappearance, and `11b` is
> **informational** until §5 says something — recorded in every report, never counted as a failure.

**The split is already made; the decision is not.** `11` was written as `11a` / `11b` in the same
edit that created this item, because separating the two marks is right under all three options and
under none of them is it the answer. Whichever way this goes, `11a` stays as it is. What is open is
only what `11b` is worth.

*Recommendation: (b), because it is the only one that ends with the product saying what it wants.
The reference implementation being the first thing to fail its own criterion is an argument for
fixing the reference, not for lowering the bar — but it is a product decision and §5 is short on
purpose.*

**Proof design.** *`Gate: none` as filed*, because as written this is a scenario defect in the
`15c` class: the criterion contradicts the playbook and no run is needed to establish that. Option
**(b)** would move it to `Gate: run` and it would need a before-fail — which exists in principle:
any of the five runs whose implementation removes the element would have to be re-measured, and
none can be, since no `measurements.json` on record has a `reducedMotion` block. So (b)'s proof
design is *"the next run on the bar model, with the sentence in"*, and its before-arm is the
reference implementation, not an archived run.

**Cost.**

- **`11` changed meaning on `2026-08-02` and would change again.** Two boundaries in the same file
  within days of each other. Mitigated by nothing except doing it now rather than after a run has
  been scored against the version that contradicts the playbook.
- **Option (b) touches the product**, including `index.html` and — once it exists — the `dom-css`
  stack note. It is the only option here that does.
- **Option (a) is the cheap one and it removes the only measurement anyone has ever taken of this
  behaviour.** Seven runs passed `11` on code presence; the second mark is the whole reason the
  first measurement was interesting.

**Log.**

- `2026-08-02` `intake` — from the first reduced-motion measurement ever taken in this project,
  which was the acceptance test of `#021`'s own fix. The instrument found a defect in the criterion
  it was built for, on its first run, against the reference implementation.
- `2026-08-02` `formulated` — checked against the playbook before being written down:
  `MONSTER-DEV.md` §5 asks for *visible and still* and asks for nothing else. The seven reports
  were re-read and they split five to two, which is what a permissive playbook produces.
- `2026-08-02` `proven` — **owner chose (c)**, against the recommendation of (b), and the reason
  the recommendation was wrong is worth keeping: (b) would have spent a run to make the product
  agree with an opinion nobody had tested, while the question of what an easter egg should do at
  the far edge is exactly the kind this project has no evidence on yet. (c) keeps the measurement
  and refuses the verdict.
  `11a` is scored, `11b` is `INFO` — measured on every run, quoted in every report, counted in no
  total. The scenario now states what `INFO` means, because a third verdict beside `PASS` and
  `NOT SCORABLE` is exactly the kind of thing that gets quietly read as a soft failure.
- `2026-08-02` — a second data point arrived while applying this, and it strengthens (c) rather
  than (b). `process/stacks/html/css/impl-01` reached the same reading independently — *"park it,
  don't hide it"*, recorded at the time with the note that it had never been asked about — so the
  reference implementation and the only backfilled implementation that faced the question both
  chose to leave the monster standing. Two readings agreeing is not evidence the reading is right;
  both were made against the same short §5 sentence. It is enough to place the disagreement with
  the playbook rather than with either implementation. Recorded in `impl-01/knowledge.md`.
- `2026-08-02` — what stays open, stated so it is not mistaken for closed: §5 still says nothing
  about the far edge, and `11b` is the standing reminder. If §5 ever gains the sentence, `11b`
  becomes a real criterion with a before-fail already on record — `index.html`, measured — and
  this item's option (b) is the design for that change.
