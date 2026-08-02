# `#012` — nine implementations were carried out before there was a record tree to put them in, and nobody has written them down since

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `process/stacks/html/css/`, `process/runs/` |
| Evidence | `2026-08-01-alt-a`, `phase1`, `phase2`, `phase2b`, `sonnet-base`, `sonnet-base2`, `plan-sonnet`, `plan-opus`, `live`, `index-sonnet`, `ph0-smoke` — inventory `2026-08-02` |
| Proof design | — |

**Depends on `#023` and `#013`, and runs after both.** Those two own the machinery — `#023` the
`runs/<id>/` layout, `#013` the capture on `hire.ps1` and the scrubber. (`#024` owns the metadata
convention and does not gate this: a backfilled run whose `knowledge.md` predates OKF is corrected
by that item, not by this one.) This item is the one-off backfill of everything that ran before the
machinery existed, and it is deliberately run *with* that machinery rather than by hand: ten
differently-aged real cases are the sharpest test the capture will ever get.

**What happened.** `#008` built the record tree and filled exactly one folder,
`html/css/impl-01/`, from run `2026-08-01-plan-sonnet`. Nine other hires had already run the same
job by then, plus one smoke test. What remains of them inside the repository is
`runs/<id>.report.md` — a verdict, which is the shortage `process/stacks/README.md` names:

> They exist because `runs/` keeps *verdicts* and throws away the *course*.

Every hire on record worked the same scenario (`alt-a-left-to-right`), the same fixture
(`fixtures/static-site/`) and the same published stack (`dom-css`). Ten independent implementations
of one requirement:

| Run | Model | In the record | Files touched | Sprite named |
|---|---|---|---|---|
| `alt-a` | Opus | — | `script.js`, `style.css` | `monster-walk.png` |
| `phase1` | Opus | — | `script.js`, `style.css` | `monster-walk.png` |
| `phase2` | Opus | — | `script.js`, `style.css` | `monster-walk.png` |
| `phase2b` | Opus | — | `script.js`, `style.css` | `monster-walk.png` |
| `sonnet-base` | Sonnet | — | `script.js`, `style.css` | `monster-walk.png` |
| `sonnet-base2` | Sonnet | — | `index.html`, `script.js`, `style.css` | `monster.png` |
| `plan-sonnet` | Sonnet | **`impl-01`** | `index.html`, `script.js`, `style.css` | `monster-sprite.png` |
| `plan-opus` | Opus | — | `index.html`, `script.js`, `style.css` | `monster-sprite.png` |
| `live` | Opus | — | `index.html`, `script.js`, `style.css` | `monster-walk.png` |
| `index-sonnet` | Sonnet | — | `script.js`, `style.css` | `monster.png` |

Three things in that table are visible without opening a transcript, and none of them is in any
report:

- **Six of ten never touched `index.html`** — they created the element from JavaScript. Four wrote
  it into the markup. Same surface, same fixture, same playbook: a fork the playbook does not name
  and every hire silently resolved.
- **The sprite has three different names** across ten implementations.
- **All ten fetched the byte-identical sheet** (`md5 ca22cefb…`, `green-fuzz-classic`), four of them
  after `phase2b` had put a second sheet in the roster. Ten for ten on the default is an N worth
  having.

`ph0-smoke` is the eleventh and is not an implementation at all — a harness smoke test whose brief
was *"Antworte nur mit dem Wort OK. Aendere keine Dateien."* Its run folder is already gone. It gets
a `runs/ph0-smoke/` holding its transcript and nothing else, which is exactly why `#013` separates
runs from implementations.

**Why the current wording allows it.** Nothing is wrong with the playbook or with the rules in
`process/stacks/README.md`. `#008` was applied to the tree it created and to the run that was fresh
at the time; the prior runs were never in its scope. This is unfinished work, not a defect.

**Where the material is.** All of it was copied out of harm's way on `2026-08-02` — `#013` Phase 0,
`C:\Users\TjarkOnnen\source\repos\priv\monster-dev-rescue-2026-08-02\`: ten run folders with `.git`
intact, eight `.dist` mirrors, eleven transcripts, 65.4 MB. Each run folder's single commit **is**
`step-1-fixture` and its dirty worktree **is** `step-4-result`; `git diff` is the whole
implementation, 96 to 127 inserted lines. The transcript is the only source for
`step-2-requirement/dialog-NN.md` and `step-3-process/`, and the only artifact that could not be
reconstructed from anything else.

**Proposed change.**

> `impl-02` … `impl-10` are appended in chronological run order and **nothing is renumbered**.
> `impl-01` stays `plan-sonnet`; it is cited from `#008`'s log and from `html/css/knowledge.md`, and
> a record whose identifiers move is not a record.
>
> An A/B arm is still an implementation and is captured like any other. What must not happen is the
> tree reading as ten independent data points when it is one job measured ten times — so
> `html/css/knowledge.md`'s implementation table gains a column naming what each run was *for*
> (baseline, control, no-change arm, proof arm), and each `impl-NN/knowledge.md` names its run in
> OKF `resource`.
>
> Nothing moves out of `fixtures/` or `scenarios/`. `step-1-fixture/` is a frozen **copy** of the
> fixture by explicit design, and the scenario is the living source of the requirement. This item
> copies; it does not consolidate.

Order within the backfill: capture all eleven first, in one commit, **before** any narrative is
written. The perishable half is the half the script can do; the narratives can be written at any
pace, and a captured-but-not-yet-narrated `impl-NN` is honest as long as its `knowledge.md` says so.

**Proof design.** *`Gate: none`.* Reaches `proven` by being applied, like `#008` and `#013`. It
proves nothing about hire quality and claims nothing about it.

The three divergences above are **candidate observations, not findings**. They go into
`html/css/knowledge.md` under *Candidates*, where `#006` can reach them, and no further.

**Cost.**

- **~17 MB of working tree.** Each `step-4-result/` carries a 1.9 MB sprite, all ten byte-identical
  to the already-tracked `monsters/green-fuzz-classic.png`, so git stores one blob and only the
  checkout grows. The alternative — a pointer instead of the file — breaks the one thing a
  `step-4-result/` is for: being the project as it was handed back, openable in a browser.
- **Not a cost, recorded because it was booked as one.** This item first claimed the nine new
  21.2-ratio PNGs would load-test `check-index.ps1`'s stray-sheet scan. They will not.
  `check-index.ps1:162` filters `process/*` out of `git ls-files '*.png'` *before* any geometry is
  measured, so nothing under this tree is ever opened by that scan. The exclusion `#008` fixed is
  therefore untested by this item, and `#014` — whose PNGs land under `docs/` and are **not**
  filtered — is where that scan actually gets exercised, in the failing direction.
- **Nine hand-written `step-3-process/` narratives** is the real price and it is not small.
  `impl-01`'s is four files of prose read off a transcript. Capturing without ever narrating leaves
  nine half-records, which is worse than nine absences because it looks finished.
- **The record tree becomes one surface with ten of the same job.** That is a genuine downside for
  `#006`, which needs a *second surface*, and must not be mistaken for progress on it.
  `html/css/knowledge.md` says so today; the sentence has to survive this item.
- **No comparability is affected.** Nothing in `scenarios/` or `fixtures/` changes, no earlier run is
  invalidated, and board citations are run ids rather than paths.

**Log.**

- `2026-08-02` `intake` — owner request: bring the material still sitting in `runs/`, `fixtures/`
  and `scenarios/` into the record tree that `#008` created.
- `2026-08-02` `formulated` — inventory taken rather than assumed: all ten run folders and eleven
  transcripts verified present, `hire.json` present for four. Scope settled as *copy into the
  record*, not *consolidate the harness*.
- `2026-08-02` — rescoped to the backfill arm of `#013`, which took over the capture machinery, the
  scrubbing, the `runs/` restructure and the boundary. Grew by one case: `ph0-smoke`, an eleventh
  session with no run folder and no report, which is a run record without an implementation. Phase 0
  of `#013` secured all of the material the same day.
- `2026-08-02` — two answers from the PM pass. **B4** upholds this item against `#013`: ten
  captures of one surface are not the fingerprint `#006` needs, and `#013`'s contrary sentence is
  withdrawn. **B7** makes `process/runs/<id>/` the source for *what a run was for*; the column
  proposed here is rendered from it rather than typed, so it cannot disagree with `#014`'s README
  line or with the run folder itself.
- `2026-08-02` — one cost withdrawn during the PM pass over the board. The stray-sheet load test
  this item booked cannot happen: `check-index.ps1:162` filters `process/*` before any PNG is
  opened. `#008`'s exclusion fix is therefore still untested, and `#014` is where that scan gets
  exercised — in the failing direction.
- `2026-08-02` — **C1**: `#013` split three ways, so *"is its Phase 4"* no longer names anything.
  This item runs after `#023` (the layout) and `#013` (the capture); `#024` does not gate it, and a
  backfilled `knowledge.md` written before that convention lands is that item's to convert.
- `2026-08-02` `proven` — applied. `#024` was taken **first** after all, though it does not gate
  this: landing the convention before the backfill means none of the twenty new `knowledge.md`
  files needs converting later, which costs nothing and removes a step.
- `2026-08-02` — what was captured. Eleven transcripts scrubbed into `process/runs/<id>/` and each
  one independently re-checked afterwards for a surviving home directory and for the account name:
  **zero hits in all eleven**, 1,186 records. Ten `base.txt`. Eleven OKF run records.
  `impl-02`…`impl-10` with `step-1-fixture/` taken from the run folder's single commit via
  `git archive` — not copied from today's `process/fixtures/`, which has since been rewritten and
  is no longer what any of them started from — and `step-4-result/` from the worktree as handed
  back. Nine `target-wish.md`, verbatim from each transcript's first user message.
  `process/stacks` is 18.7 MB and `process/runs` 12.5 MB in the checkout.
- `2026-08-02` — **three claims in this item were verified from the captured files rather than
  carried forward.** All ten sprites hash to one blob, `CA22CEFB…`, so git stores it once and only
  the checkout grows. Six of ten wrote the element from JavaScript and four into `index.html`,
  and it does not split by model. The sprite has three names and all ten put it in `assets/` —
  the location was decided identically ten times, the filename never was.
- `2026-08-02` — **a fourth divergence nobody had seen**, and it only exists because ten results
  now sit in one folder: `impl-10` is the only implementation that parameterised the frame count,
  `steps(var(--monster-frames))` against nine hard-coded `steps(23)`. It is in *Candidates* with
  everything else and is promoted nowhere.
- `2026-08-02` — two deviations from the item as written, both recorded rather than absorbed.
  **`resource` in OKF frontmatter is wrong for `impl-NN/knowledge.md`.** This item predates
  answer **C2**, which gave `process/stacks/` no frontmatter at all; the run is named in the
  existing `Source:` line instead, which is what `impl-01` already did.
  **No `worktree/` in the backfilled run folders.** For these ten the project as handed back is in
  `impl-NN/step-4-result/`, the folder designed for it, and a second byte-identical copy would add
  1.9 MB of sprite each to the checkout and no information. Each `base.txt` says so and points at
  the impl folder. A run captured by `hire.ps1` still gets both.
- `2026-08-02` — **B7 answered without building a renderer.** The role of each run lives in the
  tags of its own record under `process/runs/` and nowhere else; `html/css/knowledge.md` cites the
  run with a wikilink instead of restating the role in a column. That is a stricter reading of
  *"there is no second place for it to drift"* than rendering a duplicate would have been, and it
  is the first real use of the link graph `#024` had just built. `check-index.ps1` now reports
  `record tree: 51 file(s), 38 link target(s)` and renders the tag overview — `opus (6)`,
  `sonnet (5)`, `proof-arm (3)` — which is the archive answering a question for the first time.
- `2026-08-02` — **nine half-records exist and every one of them says so.** `dialog-NN.md` and
  `step-3-process/` are absent from `impl-02`…`impl-10`; the line naming that absence is in each
  folder's `knowledge.md` and in `html/css/knowledge.md`. That was the real price this item booked
  and it has been paid in disclosure, not in prose. The narratives remain outstanding.
  The sentence protecting `#006` survived, and is sharper: the table now opens by saying it is one
  job measured ten times, not ten data points.
