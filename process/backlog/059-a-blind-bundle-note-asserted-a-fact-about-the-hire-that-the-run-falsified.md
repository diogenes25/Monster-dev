# `#059` — a blind bundle's own note asserted a fact about the hire, and the run falsified it

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none. It sits in `MISSING.md`, which is the first thing the blind scorer reads |
| Target file | `process/tools/score-bundle.ps1` — `-NoVerifier`'s two note bodies and its help |
| Evidence | `2026-08-03-r16`; found while building that run's bundle, before the scorer read it |
| Blocked on | nothing |
| Proof design | `Gate: none` — applied. Verified by rebuilding the bundle and reading `MISSING.md` before the second scoring was run against it |

**What happened.** `-NoVerifier` exists so a decline run's missing `measurements.json` reads as *by
design* rather than as damage — `#038`, because a note that reads as damage invites a blind scorer to
hedge marks that were never measured that way. It wrote:

> No `measurements.json`, and **this run produced none by design.** There was no page for a headless
> browser to drive, so the verifier was never meant to run […]

And `midwalk.png`'s: *"nothing was rendered, so there was nothing to screenshot."*

`2026-08-03-r16` is a decline run whose hire **built an HTML page and a working animation**, verified
it in headless Chromium itself, and handed back a project with a `--html` flag. Both sentences were
false, in the one file the role's own instructions say to read first, in a bundle whose entire premise
is that the scorer cannot check anything against the outside.

**Why it is worse than a wrong comment.** `MISSING.md` is written *by us* and read *by a reader with
no other source*. Everything else in a bundle is evidence the scorer can cross-check — the transcript
against `git.txt`, `hire.json` against `worktree/`. A note is the one thing it has to take on trust,
and this one made a claim about the hire's behaviour while the transcript sitting beside it said the
opposite. A scorer that noticed would have had to conclude the bundle was broken; one that did not
would have carried a false premise into `6`, `8` and `12`.

**The class, which is the part worth keeping.** `-NoVerifier` conflated two different statements:

- *"No criterion in this scenario names that instrument"* — a property of the **scenario**, fixed
  before the run starts, and the actual reason the flag exists.
- *"There was nothing to render"* — a property of the **hire**, unknown until the run is over, and on
  a decline scenario it is precisely the thing under test.

The flag is set by whoever builds the bundle, from the scenario. It may only say things the scenario
knows. `#038` established that these notes must not name criteria; this adds that they must not
predict the hire.

**What was done.** Both bodies now say only that no criterion in the scenario names the instrument.
The `.PARAMETER` help says the same and records why the old wording went, so the next person to
reword it does not restore the explanation. Fixed **before** `r16`'s bundle was handed to the blind
scorer, so no scoring on record was done against the false note.

**Cost.** None. The note got shorter.

**Log.**

- `2026-08-03` `proven` — found and fixed in the same session, in the gap between building `r16`'s
  bundle and running the second scoring. Verified by rebuilding and reading `MISSING.md`, not by
  re-reading the diff: the whole defect was that a plausible sentence went unchecked.

  Filed rather than left in the run report, for `#047`'s reason inverted — a fix that lives only in a
  report is a fix nobody finds when the same wording gets proposed again. `#044` is the precedent for
  a `Gate: none` bundle defect closing in its own session.
