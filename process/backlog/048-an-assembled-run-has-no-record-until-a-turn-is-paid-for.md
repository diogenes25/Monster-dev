# `#048` — an assembled run has no record until money is spent on it

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/new-run.ps1` (write the stub), `process/tools/hire.ps1` (stop assuming it creates the folder) |
| Evidence | `2026-08-03-r12`, whose `knowledge.md` was written by hand for exactly this reason |
| Proof design | — |

**What happened.** `hire.ps1` creates `process/runs/<id>/` on its first turn. So everything that
happens to a run **before** the first paid turn has nowhere to be written:

- `new-run.ps1` assembling the folder and what the fixture's setup recipe did
- `build-dist.ps1`'s mirror, its file count, and which variant if any
- `check-isolation.ps1`'s verdict
- the `leak-auditor`'s findings and the corrections made in response

`2026-08-03-r12` is the case that makes it concrete. Three audit passes, six corrections and a defect
in `check-isolation.ps1` (`#040`) happened before a turn was bought, and one of those passes refused
the run outright — so for a while the entire product of that run id was pre-run work with no home.
Its `knowledge.md` was written **by hand** to hold it, and says so at the bottom.

**Why it happened.** The order is historical. The wrapper was built when a run was a thing you hired
and then wrote up, and the pre-run audit is newer than that arrangement. Nothing is defective; the
record simply starts one step too late.

**Why it matters more than tidiness.** A refused or abandoned setup is exactly the run whose lessons
are worth keeping and whose folder somebody deletes. `#013` is the same failure one stage later — a
run that ended in two directories nobody backed up — and its evidence line reads *"a run whose folder
no longer exists."*

**Proposed change.**

> `new-run.ps1` creates `process/runs/<RunId>/` and writes `assembly.md` into it: the run id, the
> fixture, the base commit, the mirror path and file count once `build-dist.ps1` has run, the
> isolation verdict, and an empty `## Pre-run audit` heading for the auditor's findings. `hire.ps1`
> stops creating the directory and appends to what is there.
>
> Nothing else moves. `knowledge.md` stays hand-written and stays the place where a run is *narrated*;
> `assembly.md` only records what a tool already knows and currently prints to a console.

**Cost.** A run folder now exists for setups that are never hired, so `process/runs/` will accumulate
records with no transcript. That is the point rather than the cost — but `check-index.ps1` should not
start reporting them as incomplete, and whoever implements this owes that check a look.

**Log.**

- `2026-08-03` `formulated` — noted in `2026-08-03-r12`'s `knowledge.md` as *"not yet filed"* while the
  run was still refused; filed when the run was scored.
- `2026-08-03` — two more instances the same day, both written by hand because there was nowhere for them
  to go. `2026-08-03-r15/audit.md` holds the `leak-auditor`'s nine findings and their triage, produced
  **before** the first paid turn of a two-arm A/B; and `2026-08-03-r13/knowledge.md` documents a run that
  was assembled, hired for two model turns, refused by the hire, and archived. Both would have been a
  folder somebody deleted.

  One correction to this item as filed: `hire.ps1` *does* write a `knowledge.md` stub with frontmatter
  on the first turn, so the gap is narrower than the body implies — it is everything before that turn,
  not the record as a whole. The proposed `assembly.md` is unaffected.
- `2026-08-03` `proven` — applied, and in one place rather than three. `process/tools/lib/assembly.ps1`
  holds `Add-MonsterDevAssemblyNote`, dot-sourced by `new-run.ps1`, `build-dist.ps1` and `hire.ps1`,
  the same shape `run-root.ps1` already uses for the runs root and for the same reason: three scripts
  deriving the same fact separately agree by coincidence.

  **Append-only from the bottom, so neither tool owns the file.** The human sections — `## Pre-run
  audit`, `## Notes` — are pinned above a `## Tool log` heading and every machine entry goes
  underneath it. That is what makes the order of `build-dist.ps1` and `new-run.ps1` irrelevant;
  `CLAUDE.md` documents them mirror-first, nothing enforces it, and nothing now needs to. Verified by
  building a probe run mirror-first and reading the file: `build-dist.ps1` created it, `new-run.ps1`
  appended, and the audit heading stayed where a person will look for it.

  Three departures from the item as written, each deliberate:

  - **`hire.ps1` keeps its `New-Item -Force`.** The item says it should stop creating the directory.
    It is idempotent on a directory, and a run folder assembled some other way must not make the
    wrapper throw *before* it has captured anything — a turn that has been paid for must not be lost
    to bookkeeping. What changed is the comment saying the folder normally already exists and why the
    line stays.
  - **`hire.ps1` writes one entry too**, on turn 1 only: model, fixture, the mirror path as handed
    over, and the entry point parsed out of the brief. That gives the record a property the item did
    not ask for and which is worth more than the rest — **an `assembly.md` with no `hire.ps1` entry is
    a setup that was never hired**, which is the case this item exists for, now legible without
    reading anything else.
  - **The entry point is checked, not just recorded.** `Test-MonsterDevEntryPointLeak`, in the same
    lib, looks in turn 1's prompt and the mirror path for this repository's absolute path, for the
    dash-encoded slug a CLI project directory is named after, and for a scratchpad segment — `#042`,
    asked *before* the turn is bought rather than out of the transcript afterwards. It reports and
    warns; it does not gate, for the `leak-auditor`'s reason. It lives in the lib specifically so it
    can be exercised against strings instead of a paid turn, and it was: it fires on `alt-a`'s shape
    (slug + scratchpad) and is silent on `r14`'s, which `check-reach.ps1` independently cleared.

  On the cost the item names — `process/runs/` accumulating records with no transcript.
  `check-index.ps1` was read rather than assumed: its run check flags ids *cited with no folder*, never
  folders with no transcript, and its frontmatter rule keys on `knowledge.md` by name. So an
  `assembly.md`-only folder passes, which is the intended behaviour and not luck. `assembly.md` carries
  no `[[wikilinks]]`, because the record tree resolves them and a link to a run that was never scored
  would fail a check for something that is not a problem.
