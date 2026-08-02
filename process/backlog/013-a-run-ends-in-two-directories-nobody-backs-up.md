# `#013` — a run produces the only learning this project has, and leaves it in two directories that are outside the repository and outside every index

| | |
|---|---|
| Status | `grilled` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | — |
| Target file | `process/tools/hire.ps1`, `process/tools/build-dist.ps1`, `process/tools/check-index.ps1`, `process/runs/`, `process/stacks/`, `process/README.md`, `process/backlog/README.md` |
| Evidence | inventory `2026-08-02` over all ten runs on record; owner decision `2026-08-02`, refined by the grilling of the same date |
| Proof design | — |

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

The second gap is navigability. `process/stacks/` is prose with no links, no tags and no backlinks.
There is no way to ask *"everything we know about stride"* or *"which runs touched §4"*.

**Why the current wording allows it.** No rule is broken. `process/README.md` documents run folders
as living outside the repository and says why reports live beside them — but never what happens to
the run folder afterwards, because until `#008` there was nowhere for it to go. The record tree now
exists; the procedure that would fill it does not.

**Proposed change — five parts.**

*Part 1 — the run ends in the repository, and nothing has to be remembered for that to happen.*

> `hire.ps1` already rewrites its whole record after every turn (`hire.ps1:191`) and already holds
> `-Target` and the `sessionId`. The capture rides on that same write: after each turn it refreshes
> `process/runs/<run-id>/` with the scrubbed transcript, the worktree, and the envelope, idempotently.
> There is no "end of the run" to miss.
>
> A backstop lives in `check-index.ps1`: a run folder under `../monster-dev-testruns/` with no
> `process/runs/<id>/` beside it is an error. It exits non-zero, so it gates a commit.

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
bytes and hold the prose, but *what the hire read, and in what order* sits in the tool results —
which is the exact trace `#006` is short of.

*Part 3 — a run and an implementation are different units, and both get a home.*

> `process/runs/` changes from flat files to one folder per run and takes everything a run produced,
> whatever its outcome — including declines (§3) and smoke tests, which have no implementation at
> all and no `<language>/<library>` folder they could honestly live in.
>
> `impl-NN/` stays exactly as `#008` defined it and names its run in OKF `resource`. It remains
> deliberate, hand-written, created once.

This split is what makes automatic capture safe: the automation never produces a half-written
implementation, because it never produces an implementation. A run abandoned after turn 1 leaves an
honest raw record.

*Part 4 — the record becomes traversable, in OKF.*

> `process/stacks/**` and `process/runs/**/knowledge.md` adopt the **Open Knowledge Format** (Google
> Cloud, v0.1, `2026-06-12`): Markdown with YAML frontmatter, required `type`, optional `title`,
> `description`, `resource`, `tags`, `timestamp`. Four `type` values, and no more without an item:
> `run`, `implementation`, `surface`, `observation`.
>
> Tags are **free-form**, not a controlled vocabulary. `check-index.ps1` enforces the form
> (lowercase-kebab) and nothing else, and **renders** a tag overview from the files themselves — it
> does not write one. That is `board.ps1`'s doctrine applied unchanged: the index *is* the folder,
> and there is no second place for it to drift. Synonyms are therefore not prevented; they are made
> visible — `stride` and `schrittlaenge` appear next to each other and someone merges them.
>
> Cross-references are `[[wikilinks]]` in the body. `check-index.ps1` fails on a link with no
> target, as it already does on a `DEAD POINTER`.

A controlled vocabulary was considered and rejected: it is a second index that can drift, and
`process/backlog/README.md` has already reasoned this out once — *"There is no search key, and that
is deliberate."* That reasoning was about scenario-local criterion numbers and does not transfer
whole, but the hazard does.

*Part 5 — the boundary, enforced at the only place that cannot go stale.*

> **Nothing about what a hire fetches changes.** `stacks/<name>/README.md` stays the only exit from
> this tree, gate-controlled, frontmatter-free, 40-line orientation cap plus measured pitfalls. A
> fetched knowledge base and a generated public export were both considered and **rejected by owner
> decision on `2026-08-02`**: each costs a turn per fetch — the metric the tooling gate is stated in
> — and reopens the criteria leak `build-dist.ps1` exists to close.
>
> The enforcement lives in **`build-dist.ps1`, against the finished mirror**: every `.md` in it whose
> first line is `---`, or which contains `[[`, fails the build and the mirror is deleted rather than
> returned. No path is named, so the check cannot go stale when a new published path appears.

The wikilink half of that rule is a hazard this item found rather than inherited. A paragraph
promoted through the gate carries its `[[stride]]` with it, and a hire then reads a pointer into a
tree it cannot fetch — the same failure as *"citation is an identifier, never a locator"*, arriving
by a new road.

*Scripts, deliberately minimal.* A script is knowledge like prose: it lives with the run that
produced it, runnable and tagged. The route out is the one `CLAUDE.md` already states — start
inline, A/B with cost, and only then a file under `stacks/<name>/tools/`. No staging area is built,
because there is nothing to stage: `tools/hire/` is empty, `stacks/dom-css/tools/` does not exist,
and **none of the ten runs produced a script**. The tooling gate is in the same position §7 is in
under `#011` — written down, never exercised.

The frontmatter rule survives all of this intact, because it was never a rule about Markdown. Its
stated reason is in the workshop skill: *"It bills every hire for metadata only we read."* That is a
rule about **fetched** files, and `process/` is never fetched. The sentence in
`process/backlog/README.md` — *"For the same reason as everything else on this side: no YAML
frontmatter"* — is the one that has to change, because its "same reason" does not survive
inspection: the board's justification is consistency, not billing. The board itself does **not**
move to OKF; converting it would break `board.ps1`'s parser for no gain. Two metadata conventions in
one repository is the accepted cost, recorded here as a decision rather than left to be discovered.

**Proof design.** *`Gate: none`.* Developer-side procedure and format; no criterion to flip, no run
to spend, reaches `proven` by being applied. A wrinkle worth naming rather than leaving to be
found: `board.ps1` forbids `Gate: none` from entering the `grilled` state, so this item was grilled
without ever holding that label. The state machine and the activity are not the same thing.

One claim is deliberately **not** made: that a traversable record makes hires better. It is not
measured here and could not be. Only an A/B in front of `stacks/dom-css/README.md` can establish
that, and this item puts no line into that file.

**Cost.**

- **A rule gains an exception, which is the expensive kind.** "No YAML frontmatter" becomes "no YAML
  frontmatter on anything a hire fetches" — correct, and one reading away from someone adding
  frontmatter to a published note because *"the wiki has it"*. Part 5 is the mitigation, and it has
  to be mechanical for exactly that reason.
- **~11 MB of scrubbed transcripts** for ten runs, and roughly 0.5–3 MB per future run, permanently.
  That is the price of the only irreplaceable artifact.
- **`runs/` becomes folders**, which touches every file in it. Board citations survive untouched
  because they are run ids, not paths — *"citation is an identifier, never a locator"* pays for
  itself here.
- **The record tree duplicates bytes.** `runs/<id>/worktree/` and, where one exists,
  `impl-NN/step-4-result/` hold the same files. Git stores each identical blob once — all ten
  sprites are byte-identical to `monsters/green-fuzz-classic.png`, already tracked — so the pack
  barely grows and only the checkout does. Accepted deliberately: a self-contained run record and a
  self-contained implementation record are each worth more than the disk.
- **The wiki rots unless the link check lands with it, not after it.** This repository already treats
  index drift as a first-class hazard; a `[[wikilink]]` graph with no checker reintroduces exactly
  that under a nicer name.
- **The sharpest cost, and the least visible.** The better this tree reads, the more publishable it
  looks. The one-way street currently holds partly because `process/stacks/` is awkward prose nobody
  would think to ship. Making it navigable, tagged and pleasant removes that accidental friction,
  and then only the gate is left holding the line. Part 5 exists for this reason alone, and it is
  the part most likely to be quietly eroded.

---

## Execution plan

Written to be run by a fresh context. Read this section top to bottom before touching anything; the
phases are ordered by what breaks what.

### Read first

`CLAUDE.md`, `process/README.md`, `process/stacks/README.md`, `process/backlog/README.md`, this
item, and `#012`. Then `process/tools/hire.ps1`, `build-dist.ps1`, `check-index.ps1` in full — they
are short, and three of the five phases edit them.

### Invariants that must survive every phase

1. **`process/` and `.claude/` never reach the mirror.** The folder name is hand-written in two
   places in `build-dist.ps1` — the exclusion and the backstop that verifies it. Both break in the
   same direction and neither shouts.
2. **Nothing that knows the acceptance criteria moves out of `process/`.**
3. **A hire's working directory stays outside this repository.** No phase here changes where a run
   executes.
4. **`stacks/<name>/README.md` gains nothing.** Not a line, not a tag, not a link.
5. **Never hand-roll a mirror.** `build-dist.ps1` builds and verifies in one step.

### Phase 0 — done on `2026-08-02`, do not repeat

`C:\Users\TjarkOnnen\source\repos\priv\monster-dev-rescue-2026-08-02\` holds a plain copy of all ten
run folders (`.git` intact, one commit, dirty worktree verified), eight `.dist` mirrors and all
eleven transcripts — 65.4 MB, outside the repository, nothing committed. Every later phase may be
redone from it. If it is missing, recreate it before anything else.

### Phase 1 — `runs/` from flat files to folders

No behaviour changes here; do it first so later phases write into the final shape.

1. For each of the ten run ids, create `process/runs/<id>/` and `git mv` its files in, renaming to
   the stem: `<id>.report.md` → `report.md`, `<id>-measurements.json` → `measurements.json`,
   `<id>-measurements-midwalk.png` → `midwalk.png`, `<id>.hire.json` → `hire.json`,
   `<id>.brief.txt` → `brief.txt`, `<id>.findings.md` → `findings.md`,
   `2026-08-01-alt-a-verify.mjs` → `verify.mjs`.
   **The set is ragged and the mapping must not assume otherwise.** `alt-a` predates the wrapper:
   its midwalk is `2026-08-01-alt-a-midwalk.png`, without the `-measurements` infix every other run
   has, and it has no `hire.json` and no `brief.txt`. `plan-opus` and `sonnet-base2` have **no
   report at all**. Drive the move off the actual directory listing, not off this pattern, and let
   a run folder be missing a file rather than inventing one — the two absent reports are a real gap
   in the archive and Phase 1 is not the place to close it.
2. **`2026-08-01-plan-retro.md` is not a run.** It is a retrospective across the plan arms. It gets
   no run folder; leave it at `process/runs/plan-retro.md` and say so in `process/README.md`, or it
   will be mistaken for a run id by everything built later.
3. Fix the relative links inside the moved reports — several point at
   `../scenarios/alt-a-left-to-right.md`, now one level deeper.
4. Update `hire.ps1:75` to `process\runs\$RunId\hire.json`, creating the folder if absent.

**Check:** `.\process\backlog\board.ps1` still clean (it cites ids, not paths, so it must be);
every moved report opens with its links intact; `git status` shows renames, not deletes plus adds.

### Phase 2 — the scrubber and the capture

1. `process/tools/scrub-transcript.ps1 -In <jsonl> -Out <jsonl>`:
   - drop records whose `type` is `queue-operation`, `ai-title`, `last-prompt` or `mode`. The brief
     appears in both a `queue-operation` and a `user` record, so nothing is lost.
   - rewrite absolute paths, longest-prefix-first, to `<run>`, `<dist>`, `<repo>`, `<home>`. Match
     case-insensitively and handle both `\` and `\\` (JSON-escaped) forms.
   - **fail loudly** if `TjarkOnnen`, or the user profile path in any form, survives the rewrite.
     A scrubber that silently half-works is worse than none.
2. Extend `hire.ps1` so the write at line 191 also refreshes, into `process/runs/<RunId>/`:
   - `transcript.jsonl` — scrubbed. Locate the source by **globbing
     `~/.claude/projects/*/<sessionId>.jsonl`**, not by deriving the project-slug from the target
     path; the slug rule is the CLI's, not ours.
   - `worktree/` — the target folder minus `.git`.
   - `base.txt` — the single commit's sha, the fixture name, and the `git status --porcelain` at
     capture time.
   - `knowledge.md` — OKF `type: run`, `resource: <run-id>`, `timestamp`, empty body. The body is
     for a human later; the frontmatter is what makes it findable now.
3. Idempotent: running turn 2 overwrites turn 1's capture wholesale.

**Check:** run the scrubber over all eleven rescued transcripts;
`grep -ri tjarkonnen` over the outputs must return nothing. Compare record counts before and after
and confirm only the four dropped types are missing.

### Phase 3 — the checks

1. `check-index.ps1` gains, in this order of cheapness:
   - **capture backstop** — a directory under `../monster-dev-testruns/` (ignoring `*.dist`) with no
     `process/runs/<id>/` beside it → FAIL.
   - **OKF form** — every `.md` under `process/stacks/` and every `process/runs/*/knowledge.md` has
     frontmatter with a `type` from the four; every tag is lowercase-kebab → FAIL otherwise.
   - **link check** — every `[[target]]` resolves to a file in the record tree → FAIL otherwise.
   - **`-Tags`** — renders the tag overview to stdout, sorted by count, each tag with the files
     carrying it. It writes no file. `board.ps1` is the model.
2. `build-dist.ps1`, after the mirror is assembled and before it is handed back: every `.md` in the
   mirror whose **first line** is `---`, or which contains `[[`, fails the build and the mirror is
   deleted. Note the first-line restriction — `---` as a horizontal rule is legal and load-bearing
   in a stack note, where it separates orientation from pitfalls.

**Check:** build a mirror and confirm it passes today, *before* trusting the new rule — if any
current published file trips it, the rule is wrong, not the file. Then plant a frontmatter block in
a scratch copy of a published note, rebuild, and confirm the mirror is refused and deleted.

### Phase 4 — backfill (`#012`)

Now the tooling exists, so the ten old runs are captured with the same code that will capture the
eleventh. Run the capture against each rescued run folder, then write the nine
`impl-NN/knowledge.md` and `step-3-process/` narratives from the scrubbed transcripts, at whatever
pace. `#012` carries the detail; `ph0-smoke` gets a `runs/ph0-smoke/` folder holding only its
transcript, and no implementation.

### Phase 5 — documentation

`process/README.md` (the layout block, the harness list, the new closing step), `process/stacks/README.md`
(OKF, tags, links), `process/backlog/README.md` (the frontmatter sentence — its stated reason is
wrong, not merely out of date), `CLAUDE.md` (the `process/` row in the layout table, and the
frontmatter bullet, which must now say *on anything a hire fetches*), and the `monster-dev-workshop`
skill's run procedure.

Set this item to `proven` only after a mirror has been built and **looked inside** — a green script
is not evidence, and this repository has the scar to prove it.

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
  have no report to move. Four open questions from that pass are in `DISCUSSION-2026-08-02.md`:
  whether this item splits into three (**C1**), how OKF frontmatter coexists with the `Stack:`
  first-line rule (**C2**) and with the frozen fixture copies (**C3**), and how the capture backstop
  survives `#019`'s layout, which it currently does not (**C4**).
- `2026-08-02` `grilled` — the state this item has claimed in its own log since the morning and
  could not hold, because `board.ps1` refused `grilled` to the `none` lane. Answer **A6** lifted
  that: the lane says what *proves* an item, not whether it may be argued with first, and this item
  was the case that made the argument. `in-proof` stays closed to the lane, and the "no item in
  `grilled`, no run" rule now names `Gate: run` explicitly so this does not read as a run brief.
