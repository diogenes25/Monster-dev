# knowledge — HTML / CSS

Stack: `dom-css`

What holds across every implementation in this folder, as opposed to what happened in one of
them. Per-implementation observations stay in `impl-NN/knowledge.md`.

This file is **raw material**. The published note for this surface is
`stacks/dom-css/README.md`, and the route from here to there runs through the A/B gate: a
candidate line goes into the note, a run with the note is compared against a run without it, and
the line stays only if the arms differ. Nothing is promoted because it reads well.

## Implementations

| | Fixture | Requirement | Source |
|---|---|---|---|
| [`impl-01`](impl-01/) | plain five-file static site, no framework | Alt+A, monster crosses left → right | run `2026-08-01-plan-sonnet` (Sonnet) |

## Candidates for the published note

Nothing yet. One implementation is not a signal — the whole reason this folder exists is that
`stacks/dom-css/README.md` currently has an empty pitfall section, and filling it from a single
observation would be exactly the untested advice the gate is there to stop.

The nearest thing to a candidate is **stride**: the roster publishes frames, cell size, cycle
time and facing, but not distance travelled per gait cycle, and any implementation that derives
crossing duration from viewport width has to invent it. `impl-01` estimated `130px` against a
184px frame. If a second implementation on a different surface has to invent the same number, it
stops being a judgement call and becomes a roster gap — and *that* is a claim with an A/B behind
it.

## What is already known to need no help

Both original `dom-css` pitfalls from run `2026-08-01-alt-a` were solved unprompted by every
later hire on both models, which is why they are not in the published note. Do not re-add them
from this side; an entry whose arms cannot be separated is an entry with no evidence.
