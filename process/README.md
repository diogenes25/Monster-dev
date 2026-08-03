# The process side

Monster-Dev is a prompt, not code. The only way to know whether an edit worked is to hire a
fresh agent and watch what it does — which makes this folder the closest thing the project has
to a test suite, and the reason it used to be called `test/`.

It holds two things now, and they are not the same kind of thing:

- **The measurement.** Fixtures, scenarios, the harness, the runs, the board. Everything with an
  acceptance criterion behind it, governed by the proof gates in `CLAUDE.md`.
- **The record** — `stacks/`. One folder per implementation actually carried out, kept as
  fixture → requirement → process → result. Created once, never re-run, never scored. Its purpose
  is documentation and raw material; see [`stacks/README.md`](stacks/README.md).

Nothing crosses from the second into anything a hire reads without passing through the first.

Everything here is **published but never fetched**. It ships with the repo so anyone can
reproduce a run, and it is excluded from the `<dist>` mirror a hire receives, because an agent
that has read the acceptance criteria passes them without reading the playbook.

This file is the **rationale**: why the harness is shaped the way it is. The **procedure** —
the exact sequence for building a mirror, creating a run folder, hiring, scoring, and the
report templates — lives in the `monster-dev-workshop` skill
(`.claude/skills/monster-dev-workshop/`). Keep it that way rather than duplicating steps here;
when the two disagree, the skill is what actually gets executed.

## Layout

```
process/
  fixtures/<name>/          target-project templates; a run never modifies one
  fixtures/<name>.md        what that fixture is for — a sibling, never copied
  scenarios/<name>.md       customer brief + answer script + acceptance criteria
  runs/<run-id>/            everything one run produced — see below
  runs/plan-retro.md        a retrospective across arms; not a run, so not a folder
  backlog/<nnn>-<slug>.md   one file per open problem, carried across runs
  tools/                    the harness itself — see below
  stacks/<lang>/<lib>/      the implementation record — see stacks/README.md

../monster-dev-testruns/<run-id>/target/   the project the hire actually works in
../monster-dev-testruns/<run-id>/dist/     what the hire is allowed to see
```

**One run, one parent**, and that is the second isolation rule rather than a tidier path. Both
used to be direct children of `../monster-dev-testruns/`, so `ls ..` from the hire's working
directory listed every run and every mirror to date — dated folders in `<name>` / `<name>.dist`
pairs with the model in the name. `2026-08-01-sonnet-base2` ran exactly that listing. What it
would have found is the point: ten worktrees holding a finished, already-scored implementation of
the identical brief against the identical fixture, one of them with
`/* walking monster easter egg — Monster-Dev (press Alt+A) */` at the top of its stylesheet.
Ancestry was checked from the first run because `CLAUDE.md` arrives *automatically*; a sibling
arrives only if you look, which is why nobody looked for ten runs.

`stacks/` here and `stacks/` at the repository root are different trees answering different
questions. This one is keyed by language → library and is never fetched; the root one is keyed by
rendering surface + animation primitive and is the only stack index a hire can see. The `Stack:`
line at the top of each `impl-NN/knowledge.md` maps one to the other.

Run folders live **outside this repository**, and reports live beside them rather than inside
them — a report inside the target project would itself violate the §9 cleanup rule it checks.

### `runs/<run-id>/` — one folder per run

Two different things are called a run folder and they must not be confused: the one
**outside** the repo is where a run *executes*, the one here is where a run is *recorded*.
Nothing executes in here.

```
runs/<run-id>/
  transcript.jsonl    the hire's session, scrubbed          ← written by hire.ps1, every turn
  worktree/           the target as handed back, minus .git ← written by hire.ps1, every turn
  base.txt            what the run started from             ← written by hire.ps1, every turn
  hire.json           the envelope: cost, turns, session id, per-turn worktrees
  knowledge.md        what this run was for — OKF frontmatter, prose filled in by hand
  report.md           criterion-by-criterion result, with evidence
  score-b.md          the blind second scoring, copied out of the bundle before it is deleted
  findings.md         only where a run produced findings worth their own file
  measurements.json   verify-run.mjs output
  midwalk.png         the screenshot it takes mid-crossing
  brief.txt           the customer brief the hire was given
  verify.mjs          only where a run needed a one-off verifier
```

**The first four arrive on their own, after every turn, not at the end of the run.** That is
deliberate and it is the second design here chosen against a remembered step: this repository has
lost the `test/` → `process/` mirror exclusion once, and lost a whole run — `ph0-smoke`, of which
nothing survives but a transcript — because the run was made outside the wrapper and nothing
brought it home. There is no end of the run to miss, and a run abandoned after turn 1 still leaves
an honest record. The capture runs *after* the envelope is on disk and never throws: a bug in it
must not cost a turn that has already been paid for. It writes `CAPTURE-FAILED.txt` instead.

**The transcript is scrubbed on the way in** by `tools/scrub-transcript.ps1`, because `process/`
is tracked and this repository is pushed. Raw, the eleven transcripts on record hold the machine
owner's name 2,864 times — in `cwd`, in briefs, in `ls -la` output as the file owner, and once in
a *hire* transcript as `Shell cwd was reset to …`. Paths become `<run>`, `<dist>`, `<repo>` and
`<home>`; the CLI's own bookkeeping records are dropped. The scrubber refuses to write a file it
could not fully anonymise, because nothing downstream will look again.

It holds **whatever that run produced, whatever its outcome** — including a §3 decline and a
smoke test, neither of which has an implementation or a `stacks/<language>/<library>/` folder it
could honestly live in. `impl-NN/` under `stacks/` is the other thing entirely: deliberate,
hand-written, created once, and it names its run.

**A folder is allowed to be missing a file.** The set is ragged and the gaps are real:
`2026-08-01-alt-a` predates the wrapper and has no `hire.json` and no `brief.txt`, and
`2026-08-01-plan-opus` and `2026-08-01-sonnet-base2` have **no report at all** — both were written
up inside `plan-sonnet`'s report as arms rather than on their own. That is a gap in the archive,
not a naming convention, and nothing here invents a file to cover it.

It was flat until 2026-08-02, keyed by the prefix of each filename. That worked while a run
produced three files; it stopped working when a run started producing a transcript, a worktree
and a second scoring, because a directory has no filename prefix.

**`knowledge.md` is the one file here a person writes, and the only one carrying metadata.** It
uses the Open Knowledge Format — YAML frontmatter with a required `type`, one of `run`,
`implementation`, `surface`, `observation` — and `hire.ps1` writes the block on the first turn and
never touches it again. `tags` arrives empty on purpose: tags are free-form, `check-index.ps1`
enforces only their shape, and an automatically invented tag would show up in the rendered
overview as though somebody had chosen it.

`process/stacks/` does **not** get frontmatter. That is not an oversight and the reasoning is in
[`stacks/README.md`](stacks/README.md): OKF makes the first line `---` and has no field for a
published stack, and the `Stack:` first line is the whole mapping between the two trees. Two
conventions inside `process/`, and the boundary between them is a directory name — which is at
least the kind of boundary a script can check.

Cross-references in both trees are `[[wikilinks]]`. They are body syntax, they need no
frontmatter, and `check-index.ps1` fails on one that resolves to nothing.

## Fixtures, and the stack each one exercises

| Fixture | Represents | Exercises | Stack |
|---|---|---|---|
| `fixtures/static-site/` | Plain HTML/CSS/JS, no framework, no existing animation | The baseline: DOM surface, no animation convention to conform to, pick injection point and asset location from scratch | `dom-css` |
| `fixtures/gsap-site/` | A site already animating with GSAP | Style conformance (§2.4): build the walk cycle with GSAP, matching `animations.js`, instead of introducing raw CSS keyframes | *(not yet created)* |
| `fixtures/python-cli/` | A pure Python CLI/report tool, no UI framework | The decline path (§3): no visible surface, so say so and stop instead of improvising | *(none — §3 covers it)* |

A stack has no notes file until a run has produced something worth writing down. That is the
point: a `stacks/` entry is a record of what was measured, not a collection of advice.

### A fixture holds only what the target project would hold

Everything in the table above used to be written *inside* the fixture, in its own `README.md`,
under the heading **Expected Monster-Dev behavior**. `new-run.ps1` copies the folder wholesale, so
the reader of that paragraph was the hire: it was present in all ten rescued run folders and the
string reached six of the ten transcripts — five read during analysis, two more surfaced by the
hire's own §9 cleanup grep. Criteria `8` and `9` were scored, in those six, against a hire holding
the answer. The two fixtures never yet run against were worse: both cited `MONSTER-DEV.md` by
section number, and `python-cli`'s named the exact improvisation §3 is scored on.

So the note about a fixture lives at **`fixtures/<name>.md`**, a sibling of the folder, for the
same reason and in the same shape as `tools/setup/<fixture>.ps1`. A fixture keeps a `README.md`
only where a real project of that kind would have one, written entirely in character — Acme Kite
Co.'s site, Nimbus Studio's house rule on motion, a cron-driven CSV report tool. None mentions a
monster, a sprite, the product or a playbook section, and `new-run.ps1` deletes the run folder if
one does.

The line to hold when writing one: a fixture may **be** whatever it is, and may not **say** what
should be done about it. `gsap-site`'s README states that motion goes through `animations.js`,
because a real studio's README would; it does not say "no CSS keyframes", because that would
measure instruction-following instead of §2.4.

## The harness — `process/tools/`

- `build-dist.ps1` — builds the mirror **and** verifies it, deleting it rather than returning
  one that leaked. Also builds A/B arms via `-Without`. Three checks follow the copy and only the
  first names a path: the four exclusions arrived nowhere; §2 and §5 agree with what is there; and
  nothing in the mirror describes the harness or references a sprite sheet. See below.
- `new-run.ps1` — creates the run folder from a fixture, refuses one that names the product
  anywhere in the target, runs its setup recipe if it has one, commits once, and deletes the folder
  rather than return one that fails isolation or starts dirty. Recipes live in
  `tools/setup/<fixture>.ps1` and are never copied into the target, where they would land in the
  §9 diff surface.
- `check-isolation.ps1` — walks the run folder's ancestry for `CLAUDE.md`, looks **sideways** for
  any directory beside it that is not its own mirror, and confirms the folder is a git repo with
  exactly one commit. `-AncestryOnly` drops the last two, for a folder that must be free of this
  repo's context but is not a run folder — the scoring bundle is one, and its parent is not
  reserved for it.
- `check-index.ps1` — the indexes against the working tree: §2 ↔ `stacks/`, §5 ↔ `catalog.json`,
  the 40-line orientation cap, any sheet-shaped PNG outside `monsters/`, the record tree's two
  conventions (OKF under `runs/`, the `Stack:` line under `stacks/`, tag *form* only, every
  `[[wikilink]]` resolving), and every run id cited
  by a report, a scenario or a board item having a `process/runs/<id>/`. That last one is keyed
  *inside* the repository on purpose: a check that reads a sibling directory makes the same commit
  pass on one machine and fail on another. What it cannot catch is a run that was executed and
  then cited nowhere — the per-turn capture covers that case by construction, and this is the
  second line against a capture that failed quietly.
- `score-bundle.ps1` — assembles the blind evidence bundle a run is scored against a second time:
  the criteria minus their run-log table, the transcript, the envelope, the measurements, the git
  surface and the worktree. Not the brief, not an earlier report, not `CLAUDE.md`. Deletes the
  bundle rather than return one where the cut failed.
- `publish-demos.ps1` — renders every `impl-NN/step-4-result/` as a runnable demo onto an orphan
  `gh-pages` branch, with a banner stating what the customer asked for. The demos are kept **off
  `main`** on purpose: ten finished implementations of the exact job are the answer sheet, and a
  mirror exclusion does not contain them — a run over real URLs never reads a mirror, and the base
  URL a hire derives in §0 points at `main`. It prints the README's *See it running* table rather
  than writing it, and it neither pushes nor switches Pages on.
- `scrub-transcript.ps1` — rewrites a session transcript so it can be committed to a public
  repository. Called by `hire.ps1` on every turn; standalone for an archived run. It fails rather
  than half-anonymises, and the check it fails on is *"is any home directory still named"*, not
  *"did the account name survive"* — the second question is one the rewrite always answers no to,
  so asking it would be a check that cannot fail.
- `verify-run.mjs` — drives headless Chrome over CDP to measure what the implementation
  actually does. Besides positions it records the implementation's own numbers against the sheet
  it really downloaded, the crossing duration at two window widths, and a reduced-motion pass with
  the media feature emulated — the three criteria that used to be scored off whatever the harness
  happened to emit.

**`verify-run.mjs` is exactly why the harness lives here and not in `tools/`.** It encodes the
acceptance criteria. Published under `tools/`, it would put "what is being measured" straight
into the mirror. `process/` is excluded already, so it is the only correct home — and nothing that
knows the criteria may move out of it.

## Three constraints, all learned the hard way

**1. A subagent cannot be isolated from `CLAUDE.md`.** An in-process subagent inherits the
session's working directory, so this repo's `CLAUDE.md` lands in its context — and that file
summarises the playbook: the technique by name, the sprite dimensions, the WebFetch/curl split,
the §8 rule. An agent so equipped passes every criterion without reading anything. So a hire is
always a **separate `claude` CLI session** whose working directory is the run folder, and
`check-isolation.ps1` runs before every hire, not just the first.

**2. `WebFetch` cannot reach a local server.** It rejects the hostname `localhost` outright and
force-upgrades `http://127.0.0.1` to HTTPS, so a plain local HTTP server answers a TLS handshake
with `WRONG_VERSION_NUMBER`. Serving this repo locally cannot stand in for
`raw.githubusercontent.com`, so a mirror is handed over as a **filesystem path** to `START.md`.
That makes the fetch path a choice rather than a limitation: the mirror is the default because
it holds the path constant across arms, and a real-URL run against `main` is the alternative.
A mirror run does not exercise §0 (base-URL derivation) or §5's WebFetch-for-text /
shell-download-for-binary split — but neither is *deferred*: `2026-08-01-live` proved both over
real URLs. Stack resolution is a separate question and is still open; see `#006`.

**3. Exclusion is now deliberate, and a path list only excludes what somebody already found.**
`process/` and `.claude/` used to drop out of the mirror because git ignored them. They are
tracked now, so the filter has to name them — which is why building and verifying happen in one
script rather than as a documented command someone might paste incompletely.

The list has four names on it: `process/`, `.claude/`, `CLAUDE.md` and the root `README.md`. The
last one joined on `2026-08-02`, after a section headed *"Monster-Dev gets better by being
tested"* was found in eight of the first ten transcripts as a Read tool result — all four Sonnet
runs among them, which is the arm the gates are read off. It is the repository's face for a human
on GitHub and that is the only reader it has; a hire's entry point is `START.md`, by design and
since the first run.

**What the list could never do is find the next one.** Two of the three leaks discovered that day
were in files written *in service of* keeping the criteria out of the mirror. So two further
checks run on the assembled mirror and neither names a path:

- every `.md` in it is grepped for a short **harness vocabulary** — `acceptance criteria`,
  `test run`, `test hire`, `test harness`, `criterion by criterion`, `what is being measured`,
  `comparability`, `A/B`. The check found a fourth leak on its first run, in
  `stacks/dom-css/README.md`, which is a file a hire is told to fetch.
- every file in it is checked for a reference to a sprite sheet under `monsters/`. A finished
  implementation of the brief is `.html`, `.css`, `.js` and a sprite and contains none of those
  words, so the worst thing that could reach a mirror is exactly what the vocabulary grep would
  miss. `MONSTER-DEV.md`, `index.html` and the `monsters/` folder are the named exceptions.
- every `.md` in it is refused if its **first** line is `---`, or if it contains `[[` anywhere.
  That is the record tree's own syntax arriving where it must not: frontmatter bills a hire for
  metadata only we read, and a `[[stride]]` is a pointer into a tree the mirror does not contain.
  The road in is a paragraph promoted through the A/B gate out of `process/stacks/`, which is
  exactly where wikilinks live. Only the first line — a horizontal rule further down is legal and
  load-bearing, since it separates a stack note's orientation from its pitfalls.

A vocabulary term that fires on legitimate playbook prose comes **out of the list**. It does not
get accommodated by rewording `MONSTER-DEV.md`, because a check that edits the product to stay
quiet has stopped being a check. `harness` is out on those grounds: §7 tells a hire to build a
scratch one.

Three checks now scan for words, and they are three lists on purpose rather than one shared one.
Each protects a different reader: `new-run.ps1`'s two product names protect **the hire's own
working copy** against being handed the answer; `build-dist.ps1`'s vocabulary protects **the
hire** against knowing it is measured at all; `score-bundle.ps1`'s criteria terms protect **the
blind scorer**. A shared list would be the union of all three and would make every one of them
noisier.

One consequence worth knowing before it is read as a defect: `monster.png` is still in the mirror
and now nothing references it, because the only file that did was `README.md`. It stays, because
it is genuinely public and the mirror is still meant to be the public surface minus the leaks.

The rename from `test/` to `process/` on `2026-08-02` is the sharpest form of the same hazard.
`build-dist.ps1` carried the literal `'test'` **twice**: once in the exclusion and once in the
backstop that verifies the exclusion. A rename breaks both at the same moment and in the same
direction — the filter matches nothing, and the check looks for a folder that no longer exists
and reports clean. Two layers, one string, no alarm. Anything that renames this folder again has
to change both lines and then *build a mirror and look inside it*; the script passing is not
evidence.

## Designing the customer

The customer is played from the scenario's answer script, never improvised, so a rerun is
identical. Two principles, both easy to violate:

- **Stay vague where a real customer would be.** Anything the script spells out is something
  the run can no longer measure. State the requirement and you only learn whether the agent
  follows instructions — not whether the playbook surfaces the requirement on its own.
- **Split "didn't ask" from "didn't build".** Score likely gaps twice: did Monster-Dev raise it
  (a §4 signal), and does it work (a §5/§6 signal)? Missing *without* asking is a playbook gap;
  missing *with* asking is an implementation error. A report must never blur the two.

## What a run has to clear

The bar is a **Sonnet**-class hire. Opus solves the known pitfalls unaided, which leaves an A/B
nothing to measure; a Haiku failure is explicitly not a finding.

**And one thing outside the harness that invalidates a comparison anyway:** changing
`catalog.json`'s `default` changes what every client with no preference receives, which is what
the answer script says in every run to date. Every earlier run becomes incomparable at that
moment. `monsters/README.md` used to carry this warning; it was moved here on `2026-08-02`,
because saying it in a published file told a hire both that its choice was being recorded and
which sheet the recorder expected — and criterion `14b` scores exactly that choice.
