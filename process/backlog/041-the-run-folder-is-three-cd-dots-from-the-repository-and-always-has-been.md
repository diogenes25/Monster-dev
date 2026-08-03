# `#041` — the run folder is three `cd ..`s from the repository, and has been for all eleven runs

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | potentially all of them, for every run on record — the scenario, the criteria and nine implementations are all reachable |
| Target file | `process/tools/lib/run-root.ps1` (new), `check-reach.ps1` (new), `new-run.ps1`, `build-dist.ps1`, `score-bundle.ps1`, `check-isolation.ps1`, `CLAUDE.md`, `process/README.md`, `SKILL.md`, the report template |
| Evidence | measured `2026-08-03` immediately after `#040`'s archive move, by looking one level further up than `#040` did |
| Blocked on | nothing. **Resolved by the second option below, not the first** — see the log |
| Proof design | — |

**What happened.** `#040` fixed the sideways look at two levels and moved twenty stale directories
into `../monster-dev-archive/`. The check went green. Looking one level further up — `ls ..\..\..`
from the hire's working directory — returns this:

```
monster-dev-archive              the twenty just moved: an implementation with its sprite,
                                 nine mirrors carrying the root README.md
monster-dev-rescue-2026-08-02    rescue copies of the implementations, plus transcripts
monster-dev-scoring              a blind-scoring bundle, holding criteria.md verbatim
monster-dev-testruns             this run
MonsterLib                       the repository: CLAUDE.md, process/, and
                                 process/scenarios/nowhere-to-walk.md — this run's own criteria
pugling                          unrelated
```

Three `cd ..` from where a hire starts is the acceptance criteria of the run it is being scored by.

**This is the shape `#040` was filed about, repeated by `#040`'s own fix.** `#040` says of `#019`:
*"a fix that relocated its own subject."* The archive move did the same thing one level out — it
was still worth doing, because it emptied the level the check now reads and that level is the one a
hire actually walks, but it must not be written up as having closed anything. What it closed is the
`..\..` listing. What was always there is the `..\..\..` one.

**Why nothing caught it.** `check-isolation.ps1` does two different things and neither reaches
here. The **ancestry** walk looks for `CLAUDE.md` in directories *on the path* to the target —
`monster-dev-testruns\<id>\target`, `monster-dev-testruns\<id>`, `monster-dev-testruns`, `priv`,
… — and `MonsterLib` is not on that path, it is a *sibling* of one of them. The **sideways** look
reads children, now at two levels, and stops at the testruns root on purpose: the level above is a
general source directory holding unrelated projects, so requiring it to contain only the run would
be absurd.

So the defect is not in the check. **It is in the convention.** `..\monster-dev-testruns\` is a
sibling of the repository by nothing more than prose — `CLAUDE.md` states the path and
`new-run.ps1` derives it with `Join-Path (Resolve-Path '..')`. That places every run inside the
same directory as its own answer sheet, and no arrangement of sideways checks can fix a location.

**What is and is not known.** The exposure is structural and **unmeasured**, and it should not be
written up as a leak that happened:

- Every run on record ran inside it, and none is known to have walked up three levels. `#019`
  established a hire *does* run `ls` on the parent — that is one level.
- `2026-08-01-live`'s transcript audit found five fetched URLs, all pointed at, and no reach for
  `CLAUDE.md`. That is `n = 1` and about URL fetches, not about directory listings.
- `#018` is the counter-evidence and the reason not to be relaxed: when the root `README.md` was
  *in the mirror*, eight of the first ten hires read it. Reach plus a reason is enough.

**Proposed change.** The run root moves out of the repository's neighbourhood entirely, so that
nothing above the run is related to the run. One decision, then mechanical:

> Run folders live under a root that holds nothing else and is not a sibling of the repository —
> `C:\monster-dev-runs\<id>\{target,dist}` or an equivalent. `new-run.ps1`, `build-dist.ps1` and
> `hire.ps1` take it from **one** place rather than each deriving `..`, and `check-isolation.ps1`
> gains the third level for free, because that root's parent then holds nothing of ours.

The alternative is to accept it and attach a detector, the way `#031` accepted the public harness:
after every run, read the captured transcript for directory listings and reads above the run folder
and say in the report that you did. That is strictly weaker — it measures contamination instead of
preventing it — but it is honest, and it is what should happen for the runs already on record,
since their location cannot be changed retroactively.

**Cost.**

- **The path convention is load-bearing in seven places** and is quoted in `CLAUDE.md`,
  `process/README.md`, `SKILL.md` and every scenario. `#003` is the item about exactly this: a list
  of sites is a list of the sites somebody found. Changing it means grepping, not remembering.
- **An absolute root is machine-specific**, which `#029` and `#037` both complain about already —
  `..\monster-dev-testruns\` at least travels. A contributor needs this to be configurable, not
  hard-coded to one laptop's `C:\`.
- **`monster-dev-scoring` has the same problem and is not the same fix.** The blind bundle is built
  beside the repository too, and `score-bundle.ps1 -AncestryOnly` checks its ancestry for
  `CLAUDE.md` and nothing sideways. A scorer that walks up finds the repository as easily as a hire
  does.
- **Doing nothing is defensible for one more run.** No run on record is known to be contaminated,
  the `..\..` level is now clean and checked, and `#022` has been waiting since `2026-08-02`. What
  is not defensible is hiring while believing the problem is solved.

**Log.**

- `2026-08-03` `formulated` — found by looking one level further up than the fix that had just gone
  in, immediately after it. Recorded that way round on purpose: the archive move was authorised and
  carried out on the understanding that it closed the exposure, and it does not. The person who
  found `#040`'s relocation defect then committed the same one inside the hour.
- `2026-08-03` — the reusable form, which is now the fourth instance in two days (`#003`, `#036`,
  `#040`, this): after changing where a thing lives, **re-ask what the check points at** — and after
  moving something out of reach, **ask what reach it moved into**. Emptying a level is not the same
  as closing a path.
- `2026-08-03` `proven` — **resolved by the second option, the detector, and the location was left
  alone.** The owner decision this was blocked on was taken that way for three reasons, in order of
  weight:

  1. `CLAUDE.md` already answers this for a structurally identical case. Of the real-URL run class it
     says: *"that is not a hole to plug by hiding things — it is a validity condition of that run
     class, and the way to hold it is to measure it."* A directory three levels up is the same case,
     and the detector is strictly better evidence than a move: it reports what the hire touched
     rather than what we believe it could not reach.
  2. This item is the fourth instance in two days of a fix relocating its own subject, and its own
     log says whoever found `#040`'s relocation defect committed the same one within the hour. A
     third relocation the same day, with nothing measured in between, would have been the fifth.
  3. Nothing had been measured in two days of harness work, and `#022` has been waiting since
     `2026-08-02`. `THESIS.md` is explicit about which way that trade runs.

  What was actually applied, all of it demonstrated:

  - **`lib/run-root.ps1`** — the runs root and the scoring root in one place, dot-sourced by
    `new-run.ps1`, `build-dist.ps1`, `score-bundle.ps1` and `check-isolation.ps1`. This is the part
    of the cost section that was decidable without deciding where: the convention was load-bearing in
    seven places, which is `#003`'s shape. Moving the root later is now a one-line edit. Verified to
    return byte-identical paths to the three derivations it replaced, and `new-run.ps1` was run
    end-to-end through `MONSTER_DEV_RUN_ROOT` pointed at a scratch directory.
  - **The override refuses a root inside the repository.** The env var is the answer to `#029` and
    `#037`'s complaint about machine-specific paths, and it introduces a failure mode a literal did
    not have: a contributor pointing a root into their own working copy. Demonstrated both ways.
  - **`check-reach.ps1`** — the detector. Four sections, exits non-zero on any reach, and section D
    turns the URL audit `CLAUDE.md` prescribed as a habit into a tool. Added as **step 7b** of the
    procedure and as a **required section of the report template**, because the failure mode of a
    measurement is nobody being told to take it: a report that omits the section and one that says
    "no reach" read identically.
  - **The scoring-root boundary is closed rather than noted.** This item's cost section says
    `monster-dev-scoring` has the same problem and is not the same fix. It turned out not to need a
    location either: a bundle is transient, and `check-isolation.ps1` — which already runs before
    every turn of every hire — now refuses to start while any bundle exists, with
    `score-bundle.ps1 -Remove` as the deliberate close. "Delete it after scoring" as a habit was
    rejected for the reason `hire.ps1` gives about itself: a closing step is a step to forget.
    **There was a stale bundle on disk at that moment**, from `2026-08-01-index-sonnet`, holding
    19,638 bytes of `criteria.md` whose third line reads *"The hired agent must never see this
    file"*, plus a transcript and a finished worktree. It had been reachable from every run assembled
    since `2026-08-01` and nothing had ever looked. Deleted after verifying every byte of it is
    derivable from tracked material — worktree content-identical to `impl-10/step-4-result/`, sprite
    byte-identical by hash — which is the check `#040` could *not* satisfy for its twenty
    directories and the reason that clean-up was left to the owner and this one was not.
  - **What was not done, deliberately:** the relocation. `..\..\..` still returns this repository.
    That is now a stated, measured boundary rather than an unexamined one, and the option above stays
    written down rather than deleted, because the argument for it does not get weaker with time.
- `2026-08-03` — the detector's first sweep found something this item explicitly did not predict.
  `#041` says *"none is known to have walked up three levels"*, and that is still true. `#042` is a
  hire that did not need to: turn 1 handed it an entry-point path through a session scratchpad, and a
  scratchpad segment is a CLI project slug — this repository's absolute path with the separators
  turned into dashes. It decoded it and listed the repository root. The lesson is narrower than this
  item's and was not reachable from it: **a path handed to a hire is part of the mirror surface**, and
  no location fixes a prompt.
