# knowledge — `impl-01`

Stack: `dom-css`

Raw material. Nothing here is published, and nothing here reaches
`stacks/dom-css/README.md` without passing its gate — for a stack note that means an A/B against
an arm without the lines. Written down because it was observed, not because it is known to help.

Source: run `2026-08-01-plan-sonnet`, Sonnet, 2 rounds, 41 model turns, $1.84.

---

## 1. Stride is the one number the roster does not publish, and it decides whether the feet slide

The `§5` roster gives frames, cell size, cycle time and facing. It does not give **how far the
monster travels in one gait cycle**. That number is what locks ground speed to leg speed:

```js
const cycles = Math.max(1, Math.round((window.innerWidth + frameWidth) / stride));
```

`impl-01` set `--monster-stride: 130px` against a rendered frame width of 184px — roughly 0.7
frame-widths per cycle. It was estimated, and it looks right, and nothing in the material handed
to the hire could have told it whether it was.

Every implementation that derives duration from viewport width has to invent this number. That is
either a gap in the roster or a judgement call that belongs with the implementer; **this record
cannot tell which**, and one implementation is not the signal. Second data point needed before it
is worth writing anywhere a hire can read it.

## 2. Two nested elements, because one cannot carry two animations

The walk cycle animates `background-position`; the crossing animates `transform`. Both on one
element means one `transform` property serving two purposes. `impl-01` split them:
`.monster-walker` (translates) wrapping `.monster-sprite` (steps through frames).

This is not a discovery — it falls out of how CSS animations compose — but it is the shape every
`dom-css` implementation ends up in, and stating it saves deriving it.

## 3. Deriving duration from the viewport needs a *whole* number of cycles, not a ratio

The obvious version is `duration = distance / speed`. That leaves the crossing ending mid-stride,
which reads as a stumble at the far edge. Rounding the **cycle count** first and multiplying back
up is what makes the walk end on a complete step:

```js
crossing = Math.round(distance / stride) * cycleSeconds
```

## 4. Reduced motion: park it, don't hide it

`impl-01` reads `prefers-reduced-motion: reduce` as *stop moving*, not *stop existing* — the
monster appears, still, at `translateX(40vw)`. The easter egg still fires; it just does not
animate. Hiding it entirely would make Alt+A do nothing at all, which is a different feature.

Whether that is the right reading is genuinely open. It was not asked about and not flagged.

## 5. Three of five questions came back "no preference" — and the answers were still worth having

Only *one crossing per press* and *along the bottom edge* carried information. The other three
turned silent defaults into stated ones. The single most useful question was the one the customer
had not considered at all: **what does a second Alt+A do while the first crossing is running?**
Nothing in the brief implies that question exists, and the choice is invisible until someone
presses twice.

## 6. Prose follows the customer, comments follow the code

German handover, English code comments, in the same job. The fixture's own comments are English.
Both are correct and they point in opposite directions — worth stating because it looks like an
inconsistency until the rule is named.

---

## Open, and deliberately not answered here

- Is item 1 a roster gap? Needs a second implementation on a different surface to tell whether
  the number is stack-specific or universal.
- Item 4 has no second opinion at all.
