# `#027` — a criterion does not say what would measure it, so it is scored off whatever the instrument happened to emit

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `10` and `13` directly; the rule covers all of section B |
| Target file | `process/scenarios/alt-a-left-to-right.md`, `process/tools/verify-run.mjs`, `.claude/skills/monster-dev-workshop/references/` |
| Evidence | `#020` and `#021`, both found `2026-08-02` by the blind second scoring; criteria `10` and `13` read against `measurements.json` and `git status --porcelain` the same day |
| Proof design | — |

**The rule this item is for.** Section D criteria name their instrument. Section B criteria do not,
and section B contains behavioural and numeric claims — so each of them is scored against whatever
the harness happened to produce, by a reader deciding on the spot what would count. Four instances
are now known and two of them were found by a reader who had never seen the run.

| # | Says | Scored from | The gap |
|---|---|---|---|
| `10` | *"duration derived from stride and viewport"* | nothing | `measurements.json` has no stride, no viewport, no duration |
| `11` | reduced motion is handled | reading the CSS | the verifier cannot emulate it (`#021`) |
| `13` | *no `"MonsterLib"` reference* | `git status --porcelain` | that reports paths and never content |
| `14b` | the implementation's numbers | the sheet's numbers (`#020`) | `measurements.json` records the catalog's geometry |

`#020` and `#021` stay as filed and are the evidence for this one. They are the two that were found
by *measurement* rather than by inspection, and collapsing them into this item would delete the
provenance that makes the rule credible.

**The two unfiled cases, measured.**

*Criterion `10` is the serious one, and not because of its wording.* It is one of the four **risk
criteria** that must hold in every A/B, so every comparison on record leans on it. Read
`2026-08-01-plan-sonnet-measurements.json`: it holds `url`, `trigger`, the four visibility counts,
`keyPath`, `spriteUrl`, `spriteHttpStatus`, `spriteNaturalSize`, `spriteSlug`, and a `samples` array
of `t` / `x` / `y` / `mirrored` / `bg`. No stride. No viewport width. No duration. A stride *could*
be recovered from consecutive `x` values, and no report does that — every one records
*"duration derived"* with no number on either side of the derivation. A risk criterion that cannot
be evaluated has been passing by assent.

*Criterion `13` is the mild one and is wrong twice over.* It is scored from `git status
--porcelain`, which lists paths and never opens a file, so a `MonsterLib` string inside a modified
file passes. And it still names the product from before the rename — the string a hire could
plausibly leave is `Monster-Dev`, which is what `MONSTER-DEV.md` §8 and every sign-off comment use.
No wrong verdict has been shown; `#015` records that `13` survived ten runs *"by luck"*, because no
hire touched the file that would have exposed it.

**Why the current wording allows it.** No rule is broken, and that is the finding. Nothing in the
scenario format says a criterion has to name what would settle it. Section D acquired instruments
because it was written after the verifier existed and had one to name; section B predates it and
was written as prose about behaviour. Four items in, the pattern is not four accidents.

**Proposed change.**

> **Every criterion names the artifact that settles it** — `measurements.json` and the field,
> `transcript.jsonl`, the worktree and the file, `git status`, or *"read by a human, and here is
> what to look at"*. The last is a legitimate answer and has to be written down as one, because a
> criterion whose instrument is a reader is a criterion two readers can score differently, which is
> exactly what `#016` was built to catch.
>
> A criterion whose named instrument does not exist is **`NOT SCORABLE`**, not `PASS`. That verdict
> already exists in the scorer's output format and has never been used on these four.
>
> `10` and `13` are rewritten under that rule in the same edit as `#020` and `#021` (**D2**), and
> `verify-run.mjs` records stride and viewport in the same pass (**D3**). `13`'s product name is
> corrected to `Monster-Dev` and its instrument becomes a content grep over the worktree, not
> `git status`.
>
> The rule goes in the scenario template under `references/`, so the next scenario is written with
> it rather than audited against it.

**Proof design.** *`Gate: none`.* A scenario defect in the class `15c` established: no criterion to
flip, no run to spend, `proven` when applied.

**Criterion `10` should be re-scored across the runs on record before the next A/B leans on it
again.** The `samples` arrays are on disk, so a stride is recoverable after the fact for every run —
which means this is one of the few boundaries this project can close rather than merely record.
Whether the re-scoring changes any verdict is unknown, and that is the reason to do it.

**Cost.**

- **Four criteria change meaning at once**, on top of `#001`'s `15c`. That is five in one boundary
  line. The alternative is five boundary lines, which is worse — but the honest statement is that
  runs before `2026-08-02` and after it compare on section A and section E cleanly and on section B
  with a footnote.
- **`NOT SCORABLE` will be used, and a report will read worse.** A run whose verifier lacks a field
  now scores `NOT SCORABLE` where it used to score `PASS`. That is the archive getting more accurate
  and looking less good, which is the same trade `#015` made.
- **Naming a human as an instrument invites naming one too often.** The escape hatch is real and it
  is also the cheap answer for whoever is writing the next scenario at speed. `#016`'s blind second
  pass is what keeps it honest, and that pass costs about $1.15 per run.

**Log.**

- `2026-08-02` `formulated` — filed as answer **E2**, after `#020` and `#021` turned out to be the
  same defect at two depths and two more instances were found by reading the criteria against the
  files that score them. Both new instances verified against the artifacts:
  `2026-08-01-plan-sonnet-measurements.json` has none of `10`'s three inputs, and `git status
  --porcelain` cannot see file content.
- `2026-08-02` — **E2** also settled the shape: this item states the rule and carries `10` and `13`;
  `#020` and `#021` stay open as its evidence and land in the same sitting under **D2** and **D3**.
- `2026-08-02` — found while verifying this file, and worth someone's attention: the table above
  originally opened with a `| Criterion |` column, and `board.ps1` rendered this item's Criterion as
  *"Says | Scored from | The gap"*. Its field parser matches **any** table row whose first cell is a
  word, so a body table whose first column is named `Status`, `Gate`, `Criterion` or `Evidence`
  silently overwrites the header field — no failure, just a wrong column. Worked around by renaming
  the column to `#`. Not filed: it is one line to fix properly (anchor the parse to the rows above
  the first blank line) and this item is not about the board's own tooling.
- `2026-08-02` `proven` — all three target files. Every criterion in `alt-a-left-to-right.md` that
  makes a behavioural or numeric claim now names the artifact that settles it; the rule and the
  `NOT SCORABLE` verdict are in the scenario template under `references/`, so the next scenario is
  written with it rather than audited against it, and in Half B step 7, which is where a scorer
  reads. Six criteria moved, not four: `#007`'s `16` came along in the same boundary because it is
  the same defect from the harness side.
- `2026-08-02` — `10` and `13`, this item's own two, as applied. **`10`** splits into three marks
  and is scored from `derivation`, `durationVsViewport` and `implementation.customProperties`. The
  instrument had to be invented, not just named: §5's arithmetic ends on a *whole number of gait
  cycles*, so `travelSeconds / cycleSeconds` being an integer is the tell a single measurement can
  give — and because that is reproducible by copying, the verifier reads the duration at a second
  window width as well. Both marks are required. **`13`** becomes `13a` (`git status --porcelain
  -uall`, the file list) and `13b` (a case-insensitive content search over the worktree), with the
  product name corrected from `MonsterLib` alone to both names.
- `2026-08-02` — the re-scoring of `10` across the runs on record, which this item asks for, is
  **not** done and is not silently dropped. It is now cheaper than when it was written: the whole
  cycle can be recovered from any `measurements.json` that records the samples, but
  `travelSeconds` cannot — no run on record captured the implementation's declared duration, only
  positions over time. A stride is still recoverable from consecutive `x` values, and that is the
  half worth doing.
