# `#013` — a run produces the only learning this project has, and leaves it in two directories that are outside the repository and outside every index

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `process/tools/hire.ps1`, `process/tools/scrub-transcript.ps1` (new), `process/tools/check-index.ps1`, `process/README.md` |
| Evidence | inventory `2026-08-02` over all ten runs on record; owner decision `2026-08-02`, refined by the grilling of the same date |
| Blocked on | nothing — `#023` landed `2026-08-02` and `process/runs/<id>/` exists |
| Proof design | — |

**Narrowed by answer C1.** This item was eleven deliverables. The layout refactor is now `#023` and
the metadata convention is `#024`. What is left is the part the item is named for and the only part
that is losing data today: a run's transcript and its worktree are never brought into the
repository, and one set has already been destroyed.

**What happened.** Two different things are bundled inside "a run happens outside the repository",
and only one of them has a reason.

*Where the hire executes* **must** stay outside, and the reason is load-bearing. A hire whose
working directory sits under this repository inherits `CLAUDE.md`, which summarises the technique,
the sprite geometry, the WebFetch/curl split and the §8 rule; it passes every criterion without
reading anything. That is Constraint 1 in `process/README.md`, and it is why
`check-isolation.ps1` walks the whole ancestry before every hire. A run folder is also its own git
repo with exactly one commit, which inside this repository would be a nested repo. Nothing in this
item touches that.

*Where the artifacts end up* has **no** reason. It was never decided; it is where the files
happened to land. Measured on `2026-08-02`:

| What | Where it lives today | In the repo | Recoverable if lost |
|---|---|---|---|
| The implementation, before and after | `../monster-dev-testruns/<run-id>/` | no | no |
| The hire's transcript — the only record of *how* | `~/.claude/projects/C--…/<session>.jsonl` | no | **no** |
| Verdict, measurements, screenshot | `runs/<id>.*` | yes | — |
| `hire.json` envelope | `runs/<id>.hire.json`, 4 of 10 runs | yes | — |

`new-run.ps1 -Force` deletes an existing run folder before recreating it (`new-run.ps1:64-66`), so
reusing a run id destroys the only copy. **This is not hypothetical: it has already happened.**
`ph0-smoke` — a harness smoke test whose brief was *"Antworte nur mit dem Wort OK. Aendere keine
Dateien."* — has a surviving transcript, no run folder, no report and no entry anywhere in this
repository.

`#012` treats the shortage as a backlog to be caught up. That is the smaller half. The larger half
is that **nothing in the run procedure ever brings the material home**, so `#012` would be needed
again after the next ten runs.

**Why the current wording allows it.** No rule is broken. `process/README.md` documents run folders
as living outside the repository and says why reports live beside them — but never what happens to
the run folder afterwards, because until `#008` there was nowhere for it to go. The record tree now
exists; the procedure that would fill it does not.

**Proposed change — three parts.**

*Part 1 — the run ends in the repository, and nothing has to be remembered for that to happen.*

> `hire.ps1` already rewrites its whole record after every turn (`hire.ps1:191`) and already holds
> `-Target` and the `sessionId`. The capture rides on that same write: after each turn it refreshes
> `process/runs/<run-id>/` with the scrubbed transcript, the worktree, and the envelope, idempotently.
> There is no "end of the run" to miss.

A closing step in the written procedure was considered and rejected. This repository has lost a
remembered step twice — the `test/` → `process/` exclusion, and `ph0-smoke`, which was run outside
the wrapper and left nothing behind.

*Part 2 — the transcript is scrubbed on the way in, because `process/` is public.*

> `origin` is `https://github.com/diogenes25/Monster-dev.git` and the repository is pushed —
> `2026-08-01-live` proved it over real `raw.githubusercontent.com` URLs. `process/` is *published
> but never fetched*, so a committed transcript is world-readable.
>
> Raw, the ten transcripts are **12.29 MB** and contain the string `TjarkOnnen` **2,864 times** as
> absolute paths in `cwd`, in briefs and in tool output — one line reads
> `Shell cwd was reset to c:\Users\TjarkOnnen\source\repos\priv\MonsterLib`, inside a *hire*
> transcript. The scrubber rewrites absolute paths to `<home>` / `<repo>` / `<run>` / `<dist>` and
> drops the CLI's own bookkeeping records (`queue-operation`, `ai-title`, `last-prompt`, `mode`).
> `user`, `assistant`, `attachment` and `file-history-*` are kept.
>
> The result is not byte-faithful, which is the correct trade for an archive that people read.

Distilling to the `assistant` records alone was considered and rejected. They are 14.5 % of the
bytes and hold the prose, but *what the hire read, and in what order* sits in the tool results.

This item used to add *"which is the exact trace `#006` is short of."* It is not, and `#012:110`
said so first: `#006` needs a **second surface**, and ten captures of one job cannot produce one.
Answer **B4** settles it in `#012`'s favour. What the capture gives `#006` is an *instrument* —
once a second published stack note exists, the trace will show which one a hire fetched, which is
today unrecorded. It gives it no evidence, and this item claims none.

*Part 3 — the backstop, keyed inside the repository (answer **C4**).*

> `check-index.ps1` gains: **every run id cited by a report, a scenario or a board item must have a
> `process/runs/<id>/`.** It exits non-zero, so it gates a commit.
>
> The first draft keyed this on the neighbouring tree — *a directory under
> `../monster-dev-testruns/` (ignoring `*.dist`) with no `process/runs/<id>/` beside it*. Two things
> are wrong with that and only one of them was noticed. `#019` replaces that layout with
> `<run-id>/target/` and `<run-id>/dist/`, so *"ignoring `*.dist`"* would match nothing and the
> directory names would be run ids only by luck. Worse, and independent of `#019`: it makes a commit
> gate depend on the contents of a directory **outside** the repository, so the same commit passes
> on one machine and fails on another.

What that trades away is stated rather than hidden: a run that was executed and then cited nowhere
leaves no trace inside the repository, so no repo-internal check can miss it. The capture in Part 1
is what covers that case, and it covers it by construction — it happens per turn, not at the end.
The backstop is the second line, against a capture that silently failed, and a second line keyed to
a machine is not a second line.

*A run and an implementation stay different units.* `process/runs/<id>/` takes everything a run
produced whatever its outcome — including declines (§3) and smoke tests, which have no
implementation at all. `impl-NN/` stays exactly as `#008` defined it: deliberate, hand-written,
created once. This is what makes automatic capture safe: the automation never produces a
half-written implementation, because it never produces an implementation. A run abandoned after turn
1 leaves an honest raw record. `#023` builds the folder; this item fills it.

**Proof design.** *`Gate: none`.* Developer-side procedure; no criterion to flip, no run to spend,
reaches `proven` by being applied.

**Cost.**

- **~11 MB of scrubbed transcripts** for ten runs, and roughly 0.5–3 MB per future run, permanently.
  That is the price of the only irreplaceable artifact.
- **The record tree duplicates bytes.** `runs/<id>/worktree/` and, where one exists,
  `impl-NN/step-4-result/` hold the same files. Git stores each identical blob once — all ten
  sprites are byte-identical to `monsters/green-fuzz-classic.png`, already tracked — so the pack
  barely grows and only the checkout does. Accepted deliberately: a self-contained run record and a
  self-contained implementation record are each worth more than the disk.
- **A scrubber that half-works is worse than none.** It has to fail loudly rather than pass a
  transcript through with one surviving absolute path, because nothing downstream will look again.
- **`hire.ps1` grows a side effect on a hot path.** The per-turn write is what makes the capture
  unmissable, and it is also what makes a bug in the capture able to interrupt a run in progress.

---

## Execution plan

Written to be run by a fresh context, and now covering this item only. `#023` runs before it and
`#024` after it; `#012` is the backfill and runs last.

### Read first

`CLAUDE.md`, `process/README.md`, `process/stacks/README.md`, this item, `#023` and `#012`. Then
`process/tools/hire.ps1` and `check-index.ps1` in full — they are short, and both are edited here.

### Invariants that must survive every phase

1. **`process/` and `.claude/` never reach the mirror.** The folder name is hand-written in two
   places in `build-dist.ps1` — the exclusion and the backstop that verifies it. Both break in the
   same direction and neither shouts.
2. **Nothing that knows the acceptance criteria moves out of `process/`.**
3. **A hire's working directory stays outside this repository.** Nothing here changes where a run
   executes.
4. **`stacks/<name>/README.md` gains nothing.** Not a line, not a tag, not a link.
5. **Never hand-roll a mirror.** `build-dist.ps1` builds and verifies in one step.

### Phase 0 — done on `2026-08-02`, do not repeat

`C:\Users\TjarkOnnen\source\repos\priv\monster-dev-rescue-2026-08-02\` holds a plain copy of all ten
run folders (`.git` intact, one commit, dirty worktree verified), eight `.dist` mirrors and all
eleven transcripts — 65.4 MB, outside the repository, nothing committed. Every later phase may be
redone from it. If it is missing, recreate it before anything else.

### Phase 1 — the scrubber

`process/tools/scrub-transcript.ps1 -In <jsonl> -Out <jsonl>`:

- drop records whose `type` is `queue-operation`, `ai-title`, `last-prompt` or `mode`. The brief
  appears in both a `queue-operation` and a `user` record, so nothing is lost.
- rewrite absolute paths, longest-prefix-first, to `<run>`, `<dist>`, `<repo>`, `<home>`. Match
  case-insensitively and handle both `\` and `\\` (JSON-escaped) forms.
- **fail loudly** if `TjarkOnnen`, or the user profile path in any form, survives the rewrite.

**Check:** run it over all eleven rescued transcripts; `grep -ri tjarkonnen` over the outputs must
return nothing. Compare record counts before and after and confirm only the four dropped types are
missing.

### Phase 2 — the capture

Extend `hire.ps1` so the write at line 191 also refreshes, into `process/runs/<RunId>/`:

- `transcript.jsonl` — scrubbed. Locate the source by **globbing
  `~/.claude/projects/*/<sessionId>.jsonl`**, not by deriving the project-slug from the target path;
  the slug rule is the CLI's, not ours.
- `worktree/` — the target folder minus `.git`.
- `base.txt` — the single commit's sha, the fixture name, and the `git status --porcelain` at
  capture time.
- `knowledge.md` — `resource: <run-id>`, a timestamp, empty body. Its **format** is `#024`'s
  decision; until that lands, plain Markdown with those two facts, so nothing has to be remembered
  later about which runs predate the convention.

Idempotent: running turn 2 overwrites turn 1's capture wholesale.

### Phase 3 — the backstop

`check-index.ps1` gains the repo-internal rule from Part 3: every run id cited by a report, a
scenario or a board item has a `process/runs/<id>/`, or FAIL.

**Check:** it must pass on the current tree *before* it is trusted — the ten runs all have folders
after `#023`, so a failure means the citation scan is over-matching, not that the archive is short.
Then rename one folder in a scratch copy and confirm it fails and names the run id.

### Phase 4 — documentation

`process/README.md` (what a run leaves behind, and that it happens per turn rather than at the end)
and the `monster-dev-workshop` skill's run procedure.

**Log.**

- `2026-08-02` `intake` — owner: a test run is part of the learning process and produces knowledge
  and possibly scripts; at minimum that material has to be in the repository, held as a wiki /
  second brain rather than as loose files.
- `2026-08-02` `formulated` — attributed as an owner decision, same lane as `#008` and `#012`.
  Scope settled at the fork: process-side only, `stacks/<name>/README.md` remains the sole gated
  exit.
- `2026-08-02` grilled — seven decisions taken, and two of them corrected this item as first
  written. The transcript was to be committed verbatim, which would have published a real name 2,864
  times into a public repository; it is scrubbed on capture instead. The capture was to be a step in
  the written procedure, which is the failure mode this repository has already had twice; it rides
  on `hire.ps1` instead. Newly found: the wikilink leak through the gate, and with it the move of the
  boundary check from `check-index.ps1` to the mirror, where no path list can go stale. Refined
  against the board's own doctrine: the tag overview is *rendered*, not written to a `TAGS.md` that
  could drift. Phase 0 executed the same day.
- `2026-08-02` — Phase 1's rename mapping corrected against the actual directory during the PM pass:
  `alt-a` predates the wrapper and breaks the pattern three ways, and `plan-opus` and `sonnet-base2`
  have no report to move. That mapping now lives in `#023`.
- `2026-08-02` `grilled` — the state this item has claimed in its own log since the morning and
  could not hold, because `board.ps1` refused `grilled` to the `none` lane. Answer **A6** lifted
  that: the lane says what *proves* an item, not whether it may be argued with first, and this item
  was the case that made the argument. `in-proof` stays closed to the lane, and the "no item in
  `grilled`, no run" rule now names `Gate: run` explicitly so this does not read as a run brief.
- `2026-08-02` — **B4**: the claim that the capture is *"the exact trace `#006` is short of"* is
  withdrawn; `#012` was right that ten captures of one surface cannot make a fingerprint. Replaced
  with what the capture honestly gives `#006`, which is an instrument and not evidence.
  **B7**: `process/runs/<id>/` is the single source for *what a run was for*. `#012`'s column in
  the record tree and `#014`'s line in the root README are rendered from it, by the same argument
  this item used to make the tag overview rendered rather than a `TAGS.md` that could drift.
- `2026-08-02` — **C1**: split three ways. `#023` takes the `runs/` layout, `#024` takes OKF, tags,
  wikilinks and the mirror boundary check; this item keeps the capture and the scrubber, which is
  what it was named for and the only part that is losing data today. **C4**: the capture backstop is
  re-keyed inside the repository. Its first form read a sibling directory — which `#019` was about
  to make match nothing, and which made a commit gate machine-dependent either way.
- `2026-08-02` — **D4**: moved to the front of the queue with `#023`, which it is blocked on. The
  reason is not that this item is large but that it is the only one where the cost of waiting is
  paid in data: every run executed before it lands keeps its transcript and its worktree in one
  place, outside the repository, where `new-run.ps1 -Force` has already destroyed one set.
- `2026-08-02` `proven` — all four phases applied. Phase 1 `scrub-transcript.ps1`, Phase 2 the
  capture in `hire.ps1` (which also gained an optional `-Fixture`, because nothing else in a
  captured run says which fixture it came from and two fixtures both open with a commit called
  *"Initial site"*), Phase 3 the `check-index.ps1` backstop, Phase 4 `process/README.md` and
  Half B step 5.
- `2026-08-02` — **Phase 1, measured over all eleven rescued transcripts.** 1,186 records kept —
  exactly `user` 388, `attachment` 96, `assistant` 674, `file-history-snapshot` 10,
  `file-history-delta` 18 — and 11.53 MB out of 11.76 MB in. `grep -ric tjarkonnen` over the
  outputs returns nothing. It took **three** rounds to get there and each failure was the check
  doing its job:
  - the JSON-escaped path form emitted four backslashes instead of two, because .NET does not
    treat backslash as an escape on the *replacement* side of `-replace`. Nothing matched at all.
  - the account name appears as a file **owner**, `AzureAD+<name>`, in `ls -la` output in nine of
    eleven transcripts. No path rule can reach that, so it is a rule of its own — and because that
    rule always fires, the final check had to stop asking *"did the name survive"* and start
    asking *"is any home directory still named"*, which is a question it can still answer yes to.
  - `C:\Users\TJARKO~1`, the 8.3 short form, is what the CLI writes its own scratchpad, temp files
    and bundled-skill paths as. Eight of eleven. Nothing derives it from the long form.
- `2026-08-02` — **Phase 3's own check found the over-match the plan predicted.** First run
  reported six orphans, all of them old *filenames* quoted in prose: `2026-08-01-alt-a-midwalk.png`
  scanned as a run called `…-alt-a-midwalk`. Adding a negative lookahead for a file
  extension was not enough — the engine backtracked the id shorter until the lookahead passed and
  reported `2026-08-01-alt-a-` with a trailing dash. It needs an **atomic** group: matched whole
  or not at all. A run id that is not date-prefixed still escapes the scan entirely; `ph0-smoke`
  is the one such id on record.
  The negative test then behaved worse than a failure: removing a run folder made the block throw
  *"cannot find report.md"* instead of naming the orphan, because `git ls-files` lists the index
  and not the working tree. A check that fails for the wrong reason is indistinguishable from a
  broken check, so it now skips paths that are tracked but absent. Re-tested: it fails, names
  `2026-08-01-phase2b`, and names the three files that cite it.
  It then caught the log entry above: writing the bogus id out in full made *this file* cite a run
  that does not exist, and the check failed on the sentence describing it. Elided to `…-alt-a-…`.
  A citation scan cannot tell a citation from a quotation, and that is the price of not keying it
  to a directory outside the repository.
- `2026-08-02` — the capture was **dry-run end to end against `2026-08-01-plan-sonnet`** before
  this line was written: the session glob found exactly one transcript, the scrubber wrote it, the
  worktree copied without `.git`, and `base.txt` came out with the base commit
  `9679b8fc Initial site` and the four-line porcelain. 3.4 MB for that run, in line with the Cost
  section's estimate.
- `2026-08-02` — **the ten archived runs are not backfilled here.** That is `#012`, which runs
  last, and the material is in the Phase 0 rescue copy. What changed for it is that the two hard
  parts now exist: the scrubber is proven over all eleven transcripts, and the folders are there
  to put them in.
