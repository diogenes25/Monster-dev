# `#070` — two runs are missing from their scenario's run log, and nothing checks the direction that matters

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none. It costs the *series*, not a mark: the run log is where a reader learns which runs a criterion has been scored under |
| Target file | `process/scenarios/nowhere-to-walk.md` run log; `process/tools/check-index.ps1` |
| Evidence | `2026-08-03-r18` (found while looking for `r16`'s row and finding none) |

**What happened.** `process/scenarios/nowhere-to-walk.md`'s run-log table has exactly one row,
`2026-08-03-r12`. Both later runs against that scenario are absent:

```
$ for r in r12 r13 r14 r15 r16 r17; do
    printf "%-4s scenarios:%s\n" $r "$(grep -l $r process/scenarios/*.md | wc -l)"; done
r12  scenarios:2
r16  scenarios:1     <- Provenance only, not the run log
r17  scenarios:0     <- nowhere at all
```

`r16`'s single hit is the *Provenance* paragraph about its pre-run audit, below the cut. `r17` — the
run `#061` Phase 1 rests on — appears in no scenario file at all.

The workshop skill's step 8b ends *"Then append the run to the scenario file's run-log table."* It is
the last line of the procedure, after the report and after the board, and it has now been skipped
twice in a row.

**Why nothing caught it.** `check-index.ps1` checks the citation direction that cannot silently rot:

```
foreach ($f in (git ls-files 'process/runs/*.md' 'process/scenarios/*.md' 'process/backlog/*.md')) {
    …  "NO RUN FOLDER: '$id' is cited in $where but process/runs/$id/ does not exist"
```

Every cited run id must have a folder. **The reverse is unchecked**: a folder with a report, an
envelope and a blind scoring can exist with nothing pointing at it from the scenario it was scored
against. That is the direction a forgotten closing step fails in.

This is the same shape as `hire.ps1`'s own argument about capture — *"a closing step is a step to
forget, and this repository has already lost a run that way"* — applied to bookkeeping instead of to
evidence. The cost is smaller and slower: the run log is what a future reader uses to decide whether
a criterion's history compares, and `#061` Phase 3 is about to be scored against a series whose log
is two runs short.

**Proposed change.** Two parts, and the first is the repair rather than the fix.

1. Append the missing rows to `nowhere-to-walk.md`'s run log — `r16`, `r17`, `r18`.
2. Add a check to `check-index.ps1`, in the section that already walks `process/runs/`: **every run
   folder holding a `report.md` must be cited by at least one `process/scenarios/*.md` run-log
   table.** Runs that are not scenario runs are the exception rather than the rule and need naming —
   `ph0-smoke` and `2026-08-03-local-floor` are the two on disk, neither of which has a `report.md`,
   so *has a report* may be a sufficient discriminator on its own. Check that before adding an
   allow-list, because an allow-list is a list of the exceptions somebody remembered (`#003`).

**Cost.** A run whose report is written but whose row is not yet appended fails the check between
those two edits, which is a few minutes of red in the ordinary workflow. That is the same trade
`check-index.ps1` already makes for §2/§5 and the reason it exits non-zero — it is meant to gate a
commit, and the commit is where both edits land together.

**Log.**

- `2026-08-04` `proven` — **part 2 is in, and no allow-list was needed.** `check-index.ps1` now walks
  `process/runs/` and fails any folder holding a `report.md` that no `process/scenarios/*.md`
  **run-log table** cites. The citation has to be in the table: a run named in a Provenance paragraph
  is not logged, which is exactly the half-presence `r16` had.

  **`report.md` is a sufficient discriminator, checked before an allow-list was considered** — `#003`'s
  rule that a list of exceptions is a list of the exceptions somebody remembered. The two folders on
  disk that are not scenario runs, `ph0-smoke` and `2026-08-03-local-floor`, have no report between
  them, so nothing is hardcoded. Fifteen scored runs, fifteen logged.

  **The reverse mismatch is deliberately not checked.** Four logged rows have no `report.md` of their
  own — `r13`, `r15`, `plan-opus`, `sonnet-base2` — because their results live inside another run's
  report. That is a real shape, and failing it would push a report into existence for the sake of a
  check.

  **Both directions exercised.** Green on the tree as it stands; with `r17`'s row removed it fails
  once, naming that run, and the file was restored to a byte-identical state afterwards. That negative
  test is the point — this project has four instruments on record that confirmed an expectation while
  measuring nothing.

  `Gate: none`, so `proven` is **applied and shown to be done, never to have helped**: the closing step
  it protects has been skipped twice and this check has caught it zero times, because part 1 already
  repaired both misses.

- `2026-08-04` — **part 1 of the proposed change is done, part 2 is not.** Every missing row is appended: `r16`, `r17` and `r18` to `nowhere-to-walk.md`, and `r19` and `r20` to `alt-a-left-to-right.md`. The `check-index.ps1` half — *every run folder holding a `report.md` must be cited by some scenario’s run log* — is still owed, and it is the half that stops this recurring. Both `2026-08-04` runs were appended by hand in the same sitting they were written, which is exactly the discipline that failed twice before.
- `2026-08-03` `intake` — from `2026-08-03-r18`. Filed while writing that run's report, because the
  first thing the report needed was `r16`'s row and there was none. Two consecutive misses, and the
  second is the run a `Gate: run` item's Phase 1 rests on.

- `2026-08-04` — **the check fired, correctly, on its first real occasion, hours after landing.**
  `2026-08-04-r21`'s `report.md` was written and `check-index.ps1` refused the tree: *"NOT IN ANY RUN
  LOG: process/runs/2026-08-04-r21/ has a report.md but no run-log table in process/scenarios/ cites
  it."* The row was then appended and the check went green.

  That is the closing step this item exists for, caught in the ordinary workflow rather than two runs
  later — and it is the red window the *Cost* paragraph above predicted, felt for the first time:
  a few minutes between writing the report and appending the row. The trade held. What `proven` still
  means here is **applied**, not *shown to have helped*: part 1 had already repaired both historical
  misses, so this firing prevented a third rather than repairing one.

- `2026-08-04` — **the discriminator this item chose has a blind spot, opened the same day by a new run
  class.** `report.md` was verified to separate scenario runs from everything else, and it did — on the
  tree as it then stood. `2026-08-04-p1`, `-p2` and `-p3` are **scenario-less probes**: one turn, no
  criteria, nothing to score, so nothing to cite them from a run log. Giving them a `report.md` would
  make `check-index.ps1` demand a run-log row that would be a lie, and the write-up went into `#050`'s
  log instead, where a finding without criteria belongs.

  So the rule the check enforces is still right and its proxy is now incomplete: *scored* runs must be
  in a run log, and `report.md` no longer means *scored*. **Not fixed and deliberately not**: the three
  probes carry `knowledge.md` and no report, so the check is green and the tree is honest. The moment a
  probe series wants a narrative document of its own, this is the item that has to decide what the
  discriminator becomes — `#003`'s warning applies to any allow-list written before then.
