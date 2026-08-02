# knowledge — HTML / CSS

Stack: `dom-css`

What holds across every implementation in this folder, as opposed to what happened in one of
them. Per-implementation observations stay in `impl-NN/knowledge.md`.

This file is **raw material**. The published note for this surface is
`stacks/dom-css/README.md`, and the route from here to there runs through the A/B gate: a
candidate line goes into the note, a run with the note is compared against a run without it, and
the line stays only if the arms differ. Nothing is promoted because it reads well.

## Implementations

**Read this table as one job measured ten times, not as ten data points.** Every row is the same
brief, the same fixture and the same published stack; six of them are arms of an A/B whose other
arm is also in this table. What each run was *for* is written in its own record under
`process/runs/`, and nowhere else — the tags there are the single source, so this table cites the
run rather than restating its role and drifting from it.

Numbered in the order they were captured, which is **not** chronological: `impl-01` was the
eighth run and was recorded first, and nothing was renumbered when the other nine arrived. A
record whose identifiers move is not a record.

| | Run | Model | Element written | Sprite named |
|---|---|---|---|---|
| [`impl-01`](impl-01/) | [[2026-08-01-plan-sonnet]] | Sonnet | into `index.html` | `monster-sprite.png` |
| [`impl-02`](impl-02/) | [[2026-08-01-alt-a]] | Opus | from JavaScript | `monster-walk.png` |
| [`impl-03`](impl-03/) | [[2026-08-01-phase1]] | Opus | from JavaScript | `monster-walk.png` |
| [`impl-04`](impl-04/) | [[2026-08-01-sonnet-base]] | Sonnet | from JavaScript | `monster-walk.png` |
| [`impl-05`](impl-05/) | [[2026-08-01-phase2]] | Opus | from JavaScript | `monster-walk.png` |
| [`impl-06`](impl-06/) | [[2026-08-01-phase2b]] | Opus | from JavaScript | `monster-walk.png` |
| [`impl-07`](impl-07/) | [[2026-08-01-live]] | Opus | into `index.html` | `monster-walk.png` |
| [`impl-08`](impl-08/) | [[2026-08-01-sonnet-base2]] | Sonnet | into `index.html` | `monster.png` |
| [`impl-09`](impl-09/) | [[2026-08-01-plan-opus]] | Opus | into `index.html` | `monster-sprite.png` |
| [`impl-10`](impl-10/) | [[2026-08-01-index-sonnet]] | Sonnet | from JavaScript | `monster.png` |

`impl-02` … `impl-10` were captured on `2026-08-02` and **none of them is narrated yet**:
`step-1-fixture/`, `step-4-result/` and `target-wish.md` are real, `dialog-NN.md` and
`step-3-process/` are absent. Each folder says so in its own `knowledge.md`. Nine half-records
that looked finished would be worse than nine absences, which is why the line is in every one.

## Candidates for the published note

Nothing is promoted. These are what ten implementations of one brief make visible, and every one
of them still needs a second *surface* before it can mean anything — ten rows of `dom-css` are ten
measurements of the same thing, which is the shortage `#006` is stuck on and **not** progress on
it.

**Where the element goes is a fork the playbook does not name, and every hire resolved it
silently.** Six of ten created the monster from JavaScript and left the markup untouched; four
wrote it into `index.html`. No hire raised it as a question and no report scored it. It does not
split by model — three Sonnet and three Opus on one side, one Sonnet and three Opus on the other
— which is what makes it interesting rather than noise. Whether it matters is unknown: both work.

**The sprite has three names across ten implementations** — `monster-walk.png`,
`monster-sprite.png`, `monster.png` — and all ten put it in `assets/`. The location was decided
identically ten times out of ten; the filename never was. The playbook names neither.

**Ten for ten fetched the default sheet.** Four of them ran after `phase2b` had put a second sheet
in the roster, so the choice existed and was not taken. That N is worth having and it is also
worth distrusting: the answer script routes an indifferent client to exactly the sheet
`index.html` is built on, so this may measure the harness rather than the hire.

**Stride is the one number the roster does not publish**, and every implementation deriving
crossing duration from viewport width has to invent it. `impl-01` estimated `130px` against a
184px frame. Still the nearest thing to a real candidate here, and still one data point on one
surface — a second surface is what would turn it from a judgement call into a roster gap.

**`impl-10` is the only one that parameterised the frame count**, as
`steps(var(--monster-frames))` rather than `steps(23)`. Nine hard-coded the number the roster gave
them. One instance is not a pattern, but it is the kind of thing that is invisible until ten
results sit in one folder.

## What is already known to need no help

Both original `dom-css` pitfalls from run [[2026-08-01-alt-a]] were solved unprompted by every
later hire on both models, which is why they are not in the published note. Do not re-add them
from this side; an entry whose arms cannot be separated is an entry with no evidence.
