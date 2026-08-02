# `#023` — `process/runs/` keys a run by filename prefix, and three things now need one folder per run

| | |
|---|---|
| Status | `grilled` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `process/runs/`, `process/tools/hire.ps1`, `process/README.md` |
| Evidence | inventory `2026-08-02` over all ten runs on record; split out of `#013` by owner decision `2026-08-02` (answer **C1**) |
| Proof design | — |

**Split out of `#013` (answer C1).** `#013` bundled a pure refactor, the run capture and a metadata
convention into eleven deliverables. This is the refactor: no behaviour changes, nothing is captured
that was not captured before, and no rule moves. It is separated because three items are waiting on
*only* this part, and as one item they were waiting behind two unresolved rule collisions.

**What happened.** `process/runs/` is flat, and a run is identified by the prefix of its filenames:

```text
2026-08-01-alt-a.report.md          2026-08-01-alt-a-measurements.json
2026-08-01-alt-a-midwalk.png        2026-08-01-alt-a-verify.mjs
2026-08-01-phase2.report.md         2026-08-01-phase2.hire.json …
```

That held while a run produced three files. It no longer does, and the pressure comes from three
directions at once:

- **`#016` writes a second, blind scoring per run.** Both `score-b.md` on record live in
  `../monster-dev-scoring/`, outside the repository — `#013`'s own complaint, reproduced by the fix
  for `#016`. Neither `run-scorer.md` nor the skill's step 8 names an output path at all.
- **`#013` captures a transcript and a worktree per run.** A worktree is a directory; there is no
  filename prefix that makes a directory of files a member of a flat set.
- **`#019` moves the run folder to `<run-id>/target/` + `<run-id>/dist/`.** It says in its own cost
  section that it collides with this restructuring and that the two should land in one sitting.

**Why the current wording allows it.** No rule is broken. `process/README.md` describes what a run
writes and where, and it describes it correctly. The layout was chosen when a run wrote a report
and a measurements file, and nothing has revisited it since; until `#008` there was no record tree
for it to be consistent with.

**Proposed change.**

> `process/runs/` becomes one folder per run, holding everything that run produced whatever its
> outcome — including declines (§3) and smoke tests, which have no implementation at all and no
> `<language>/<library>` folder they could honestly live in. `impl-NN/` stays exactly as `#008`
> defined it: deliberate, hand-written, created once, and naming its run.
>
> For each of the ten run ids, `process/runs/<id>/` with the files `git mv`'d in and renamed to the
> stem: `<id>.report.md` → `report.md`, `<id>-measurements.json` → `measurements.json`,
> `<id>-measurements-midwalk.png` → `midwalk.png`, `<id>.hire.json` → `hire.json`,
> `<id>.brief.txt` → `brief.txt`, `<id>.findings.md` → `findings.md`,
> `2026-08-01-alt-a-verify.mjs` → `verify.mjs`.
>
> **The set is ragged and the mapping must not assume otherwise.** `alt-a` predates the wrapper: its
> midwalk is `2026-08-01-alt-a-midwalk.png`, without the `-measurements` infix every other run has,
> and it has no `hire.json` and no `brief.txt`. `plan-opus` and `sonnet-base2` have **no report at
> all**. Drive the move off the actual directory listing, not off this pattern, and let a run folder
> be missing a file rather than inventing one — the two absent reports are a real gap in the archive
> and this item is not the place to close it.
>
> **`2026-08-01-plan-retro.md` is not a run.** It is a retrospective across the plan arms. It gets no
> run folder; it stays at `process/runs/plan-retro.md` and `process/README.md` says so, or everything
> built later will mistake it for a run id.
>
> Relative links inside the moved reports are fixed — several point at
> `../scenarios/alt-a-left-to-right.md` and are now one level deeper.
>
> `hire.ps1:75` writes `process\runs\$RunId\hire.json`, creating the folder if absent.

**Proof design.** *`Gate: none`.* A refactor of developer-side layout: no criterion to flip, no run
to spend, `proven` by being applied.

**Check:** `board.ps1` still clean — it cites run ids, not paths, so it must be, and that is the
first thing *"citation is an identifier, never a locator"* has ever been asked to pay for. Every
moved report opens with its links intact. `git status` shows renames, not deletes plus adds.

**Cost.**

- **It touches every file in `process/runs/`** and nothing gains a capability from it. That is the
  shape of a refactor, and the argument for doing it first is only that everything after it writes
  into the final shape rather than into a shape that then moves.
- **It has to land in one sitting with `#019`,** which moves the *other* directory — the one a run
  executes in. Doing both at once risks confusing *where a run executes* with *where a run is
  recorded*, which is the distinction `#013` opens by drawing. The mitigation is to state that
  distinction in the commit, not to separate them: separated, the second one reads as undoing the
  first.
- **The ten rescued run folders keep the flat layout.** They are an archive, they are not re-run,
  reshaping them buys nothing, and it would break the paths `#012`'s backfill was written against.

**Log.**

- `2026-08-02` `grilled` — split out of `#013` as answer **C1**(a), carrying `#013`'s Phase 1 whole,
  including the rename table as corrected during the PM pass. It arrives already grilled because it
  was grilled inside `#013` on the same day; nothing about the change is newly proposed here.
- `2026-08-02` — this is the part `#016` and `#014` are actually waiting on, and `#019` collides
  with. Their citations of *"`#013` Phase 1"* and *"`#013` Part 1"* now point here; `#019`'s said
  "Part 1" and meant Phase 1, which is the confusion the split removes.
- `2026-08-02` — **D4**: moved forward, out of the paths wave and alongside the scenario and
  verifier work, which touches no file this one does. It is not urgent in itself — it is a refactor
  and it blocks `#013`, which is the only item on the board where waiting costs data that cannot be
  recovered. It still lands in one sitting with `#019`, which moves the other directory.
