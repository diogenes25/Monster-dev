# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not a library**. It's the source for **Monster-Dev**, an AI-developer persona distributed as GitHub-hosted instructions: a hiring agent WebFetches `START.md` (and then `MONSTER-DEV.md`) directly from the raw GitHub URL and thereby takes on the role of a freelance contractor whose one job is to implement a walking-monster easter egg into whatever codebase it's pointed at — idiomatically, in that project's own language/framework/conventions. Nothing from this repo gets cloned or installed into the target project; only the resulting implementation and the sprite-sheet asset do.

This scope is deliberately narrow and closed: the AI-developer-persona packaging applies **only** to this one monster feature. Do not generalize it into a reusable multi-feature pattern, and do not repackage it as a locally-installed Claude Code Skill (`.claude/skills/...`) — both were explicitly considered and rejected in favor of the "nothing installed, always fetched live from `main`" model.

Target publish location: `https://github.com/diogenes25/monster-dev` (pushed; `main` is the published branch, and §0's base URL resolves against it).

## Two features, not one

1. **Monster-Dev** — the contractor. Fetches the playbook, plus the accumulated notes and tooling for *its* rendering surface if any exist.
2. **The Monster-Dev developer** — the loop that produces those notes and that tooling and *proves* they help: test run → board item → fold in → rerun. Lives in the `monster-dev-workshop` skill and in `process/`.

Three layers grow with every run — the playbook (general), stack notes (per surface), tooling (spares a hire derivation and measuring). None of them grows on a hunch; see "The proof gates" below.

**`THESIS.md` says why feature 2 is worth the trouble**, and it is the only document here that argues rather than instructs: the monster is a *fixture*, and what is being tested is whether a narrow AI developer measurably improves — the premise of a roster of specialists that would be a company's real asset. Read it before any decision that trades measurement away for a better easter egg, because it says plainly that this is the wrong trade. It changes no rule in this file; in particular the narrow-scope lock above stays, and `THESIS.md` §4 argues *for* it. Like `README.md`, it is kept out of the mirror by hand.

## Repository layout — who fetches what

| Path | Role | Fetched by a hire? |
|---|---|---|
| `START.md` | Entry point pasted as a raw URL. **Keep it short and stable** — method changes belong in `MONSTER-DEV.md` | yes |
| `MONSTER-DEV.md` | The playbook: analysis framework, onboarding questions, the surface-agnostic technique, sign-off, cleanup | yes |
| `stacks/<name>/README.md` | One rendering surface: orientation above the `---` rule, measured pitfalls below it, each pitfall traceable to the run that produced it | yes, the matching one |
| `stacks/<name>/tools/` | Tooling for that surface only | yes, with it |
| `tools/hire/` | Cross-stack hire tooling | yes |
| `monsters/<slug>.png` | The sprite sheets — shell download, never WebFetch, since WebFetch is unreliable for raw binary bytes | yes, the chosen one |
| `monsters/catalog.json` | Machine-readable record of each sheet's geometry, tempo and provenance, written by the generator | no — the roster a hire reads is the table in `MONSTER-DEV.md` §5 |
| `index.html` | A working `dom-css` implementation. **No longer the universal reference** — reachable via `stacks/dom-css/` | via that stack |
| `tools/provenance/` | Offline sprite-sheet pipelines | never |
| `sources/` | The footage the sheets were cut from, kept so they stay regenerable | tracked, so technically yes — but nothing points a hire at it |
| `process/backlog/` | One file per open problem, carried across runs — a run's brief comes from here and its findings go back here | **never** — it is full of acceptance criteria and model dispositions |
| `process/stacks/<lang>/<lib>/` | The implementation record: one folder per job actually carried out, as fixture → requirement → process → result, plus `knowledge.md`. Documentation and raw material, created once | **never** |
| `process/`, `.claude/` | Measurement and procedure of feature 2 — the workshop skill, and the two check roles in `.claude/agents/` that sit either side of a hire | **never** |

Stacks are keyed by **rendering surface + animation primitive**, not by language: a TypeScript React app and a plain HTML page can be the same job, while two Python projects can be entirely different ones. `MONSTER-DEV.md` §2 lists **only stacks that actually exist** — `raw.githubusercontent.com` serves no directory index, so an unlisted stack is unreachable, and a listed-but-absent one is a dead pointer.

### Two trees called `stacks/`, and the one-way street between them

`stacks/` at the root is **published** and keyed by surface + primitive. `process/stacks/` is **never fetched** and keyed by language → library, because that is how an implementation record is actually looked up. Both keys are workable only because every `impl-NN/knowledge.md` opens with a `Stack: <name>` line naming the published stack it belongs to; without it, nobody can say where an observation goes.

Material flows one way and through a gate:

```
process/stacks/**/knowledge.md  →  A/B run  →  stacks/<name>/README.md  →  a hire
     raw, created once            the gate        published, measured
```

**Nothing in a `knowledge.md` reaches a published stack note without passing its gate.** The record is created once, so it has no second arm by definition — which is exactly why it may be collected freely and may not be published from directly. This tree makes writing untested advice *easier*, not harder, so the rule is stated rather than assumed. Full reasoning in `process/stacks/README.md`.

### The one invariant that silently invalidates everything

`process/`, `.claude/`, `CLAUDE.md` and the root `README.md` are all **tracked**, and all four are kept out of the `<dist>` mirror by hand. The first two used to drop out because git ignored them; now every exclusion is deliberate. Miss one and every hire reads its own acceptance criteria — or, in `README.md`'s case, reads that it is a fresh agent in a scored test run, which is what eight of the first ten hires did.

Each name is written by hand in **two** places in `build-dist.ps1` — the exclusion glob and the backstop that verifies it. Renaming one breaks both in the same moment and in the same direction: the filter matches nothing, and the check hunts a file that no longer exists and reports clean. That is what the `test/` → `process/` rename on 2026-08-02 walked into. Rename one again and you must change both lines *and* build a mirror and look inside it; a green script is not evidence.

**Two further mirror checks name no path at all**, because a path list only ever excludes the leaks somebody already found. Every `.md` in the assembled mirror is grepped for a short harness vocabulary (`acceptance criteria`, `test run`, `A/B`, …), and every file in it is checked for a reference to a sprite sheet under `monsters/` — the first catches prose that describes the experiment, the second catches a finished solution to the brief, which contains none of those words. A vocabulary term that fires on legitimate playbook prose is **removed from the list**, never accommodated by rewording the playbook; `harness` is out for exactly that reason, since §7 tells a hire to build a scratch one.

Never hand-roll the mirror. `process/tools/build-dist.ps1` builds and verifies it in one step and deletes the mirror rather than return a leaking one. For the same reason, **nothing that encodes the acceptance criteria may live under `tools/`** — the run verifier belongs in `process/tools/`, which is excluded already.

### The mirror is a blindfold, not a vault — and the difference decides every question about it

**Nothing here is secret, and nothing here may become secret.** This is open source, and the thing it distributes is a *stranger's AI developer working inside your codebase*. That asks an unusual amount of trust, and the only currency it can be paid in is legibility: how the contractor works, what it is scored on, what has already been measured and what went wrong. A user who cannot read the acceptance criteria cannot judge whether the thing is any good. A contributor who cannot read them cannot do the thing this project wants contributors to do — clone it, pose their own requirement, and push back another test.

So `process/`, `.claude/` and this file being world-readable on `main` is **the design**, not an exposure. Measured unauthenticated on `2026-08-02`, `process/scenarios/alt-a-left-to-right.md`, `process/backlog/README.md`, `.claude/agents/run-scorer.md` and this file all answer HTTP 200. That is correct and stays correct.

What the mirror exists for is something else entirely: **a hire that reads its own acceptance criteria mid-run stops being a measurement.** Not because it learned a secret, but for the same reason a subject is not told what is being scored while it is being scored. The exclusions are a blindfold worn for the duration of an experiment, by one participant, and they say nothing about who else may look.

Read every question about the mirror that way and it answers itself. Two immediate ones:

- **`build-dist.ps1`'s exclusions cover exactly one run class.** A hire fetching over real `raw.githubusercontent.com` URLs reads `main` and never sees a mirror at all, so nothing blindfolds it. That is not a hole to plug by hiding things — it is a **validity condition of that run class**, and the way to hold it is to measure it: after a real-URL run, list every URL the hire fetched out of the captured transcript and check it against the playbook's own pointers. Say in the report that you did. `2026-08-01-live` fetched five, all of them pointed at, and never reached for this file. If a future one reaches further, that run is contaminated — the repository is not.
- **The demos live on `gh-pages` and not on `main`** for the same reason and not for a secrecy one. Visitors and contributors *should* see ten finished results; a hire being measured on the identical brief should not be able to copy one. Off `main`, both hold at once.

Do not reach for the sentence about `raw.githubusercontent.com` serving no directory index when reasoning about any of this. It is true of that one endpoint and of nothing else — `github.com/<owner>/<repo>/tree/main/process/scenarios` returns an HTML listing to the same `WebFetch` the playbook hands the hire, and one unauthenticated call to `api.github.com/repos/<owner>/<repo>/git/trees/main?recursive=1` returned **397 paths**, every file named, in one request. Nothing is hidden by obscurity here, and nothing should be built as though it were.

### One run, one parent

A run folder and its mirror are `../monster-dev-testruns/<run-id>/target/` and `.../<run-id>/dist/`. They used to be direct children of `../monster-dev-testruns/`, which put every previous run one `ls ..` away from the hire — dated folders in `<name>`/`<name>.dist` pairs with the model in the name, holding ten finished, already-scored implementations of the identical brief. One hire ran that listing. `check-isolation.ps1` now looks sideways as well as up: any directory beside the run folder that is not its own mirror fails the check.

**The sideways look is two levels, and that second level is there because the first fix moved its own subject out of reach.** `#019` nested the run one deeper *and* added the sibling test — but the test follows the run folder, so it began inspecting a parent that by construction holds only `target` and `dist`, while the dangerous listing moved to `..\..` where nothing looked. On `2026-08-03` the check reported `isolation OK — parent holds 1 other directory: dist` while `ls ..\..` returned twenty directories, nine of them mirrors still carrying the root `README.md`. A check that relocates an exposure and then reports clean is worse than the exposure. Both levels are now checked and named separately in the failure (`#040`).

**Nobody may say that closes it.** One level higher, `ls ..\..\..` returns the repository itself — the runs root is a sibling of the working copy, so `CLAUDE.md`, `process/` and the run's own scenario are three `cd ..` from where a hire starts, and were for all eleven runs on record. That is `#041`. It is a **location** problem and no arrangement of sideways checks fixes a location; the level above the runs root is a general source directory holding unrelated projects, so it cannot be required to hold only the run. Two things follow, and the first is the one to internalise:

- **The location was deliberately not changed, and the reason is in this file already.** Of the real-URL run class §"blindfold, not a vault" says: *that is not a hole to plug by hiding things — it is a validity condition of that run class, and the way to hold it is to measure it.* The same answer applies here. `check-reach.ps1` reads a finished run's transcript and reports what the hire actually walked to; a report that says nothing about reach has not checked. That is strictly better evidence than a relocation, which only ever supports *"we believe it could not get there."*
- **Where the runs root is now lives in exactly one place** — `process/tools/lib/run-root.ps1`, dot-sourced by `new-run.ps1`, `build-dist.ps1`, `score-bundle.ps1` and `check-isolation.ps1`, overridable by `MONSTER_DEV_RUN_ROOT`, and refusing any root that resolves inside this repository. Three scripts used to derive `..` separately and agreed by coincidence. Moving the root later is a one-line edit there; that is the part of `#041` which was decidable without deciding where.

**A blind-scoring bundle left on disk blocks the next hire.** Each one holds `criteria.md` in full and the scoring root is a sibling of the runs root, so the same walk reaches both — and being buried among unrelated folders is obscurity, which this file forbids relying on. Deleting it after scoring is a closing step, and a closing step is a step to forget, so `check-isolation.ps1` refuses to start a hire while any bundle exists. Close one deliberately with `score-bundle.ps1 -RunId <id> -Remove`. A bundle for the run *being hired* is the sharpest case rather than an exemption: it means an earlier attempt was already scored.

**And a path handed to a hire is part of the mirror surface.** `2026-08-01-alt-a` — the first run, the one whose criteria the whole series is scored against — was given an entry-point path running through a session scratchpad, and a scratchpad segment is a CLI project slug: this repository's absolute path with the separators turned into dashes. The hire decoded it and listed the repository root. It never walked up; it was handed the address (`#042`). Check what turn 1 *says*, not only where it runs.

### The proof gates

- **Playbook wording** → regression: fold in, rerun the same scenario, the failing criterion must flip.
- **Stack notes** → A/B: precautionary knowledge usually has no prior failure to flip, so compare a run with the lines against one without. No difference means the lines go.
- **Tooling** → A/B with cost: `total_cost_usd` / `num_turns` must drop measurably *and* no criterion may regress. Neither, and the tool goes.

The bar is a **Sonnet**-class hire. Opus solves the known pitfalls unaided, which leaves nothing to measure; a Haiku failure is explicitly not a finding.

**One exemption, and it is capped.** A stack note holds two classes of thing. *Orientation* — am I in the right stack, what is the idiom here, where do assets live — is the stack's definition: without it the §2 line points at nothing. It is **gate-free**, because there is no prior failure for it to flip and no honest A/B arm that omits it. In exchange it is **everything above the note's first `---` rule and at most 40 lines**; uncapped, the exemption is a back door for untested advice that calls itself orientation. Pitfalls, fragments and tools live below the rule and stay gated.

### The shape of published knowledge

Full rules and the entry template are in the `monster-dev-workshop` skill, Half D. The four that decide whether something may be written at all:

- **Decision-shaped, not solution-shaped.** An entry names a fork and what settles it; the resolution stays with the hire, who is the only party looking at the actual project.
- **Citation is an identifier, never a locator** — the bare run id in parentheses. `process/` is tracked, so a path becomes a live URL after the push: a 404 and a burnt turn in a test run, a pointer into the acceptance criteria in production. **No YAML frontmatter and no `[[wikilinks]]` on anything a hire fetches** — the rule is about fetched files, not about Markdown, and inside `process/` both are used. `build-dist.ps1` enforces it against the finished mirror rather than by path, because the road in is a paragraph promoted through the gate out of a tree that has them.
- **Fragments live inside a prose entry**, shorter than the prose, and deleting one must leave the entry true — that last test is what gives a fragment its own A/B arm. Never a `snippets/` directory.
- **A tool starts inline**, and output that is identical for every hire is not a tool but a table cell in §5.

## Developing Monster-Dev itself

Use the **`monster-dev-workshop` skill** (`.claude/skills/monster-dev-workshop/`) for any work *on* the product: editing `START.md`/`MONSTER-DEV.md`, changing `index.html` or the sprite sheet, adding a stack or a tool, or running and scoring a test hire. It carries the playbook invariants, the full run procedure, and the scenario/report/board-item templates.

That skill is dev-side tooling *about* Monster-Dev — it is not, and must not become, a packaging of the product itself.

## Commands

There is no build/lint/test tooling for this repo (static HTML/CSS/JS + Markdown + standalone PowerShell scripts).

**Preview `index.html`:** `.vscode/launch.json` is set up to launch Chrome against `http://localhost:8080` with the repo root as web root — serve the repo root with any static file server on port 8080, or simply open `index.html` directly in a browser.

**Build the `<dist>` mirror for a test hire** (never by hand — it builds *and* verifies, and deletes a leaking mirror instead of returning it):
```powershell
.\process\tools\build-dist.ps1 -RunId 2026-08-02-alt-a
```

**Create the run folder** — also never by hand. It copies the fixture, refuses one that names the
product anywhere in the target, runs the fixture's setup recipe if one exists
(`process/tools/setup/<fixture>.ps1`, kept out of the fixture so it cannot be copied into the
target and pollute the §9 diff surface), commits exactly once, and deletes the folder rather than
hand back one that fails isolation or starts dirty. Dependencies are installed here rather than by
the hire: inside the session they would land in `num_turns` and `total_cost_usd`, two of the three
numbers the gates are stated in:
```powershell
.\process\tools\new-run.ps1 -RunId 2026-08-02-alt-a -Fixture static-site
.\process\tools\check-isolation.ps1 -Target ..\monster-dev-testruns\2026-08-02-alt-a\target   # standalone; new-run already ran it
```
A fixture folder holds **only what the target project would hold**. What a fixture is *for* — the
marks it exists to turn on, and what a correct run looks like — goes in `process/fixtures/<name>.md`,
a sibling of the folder, for the same reason the setup recipe does. Every fixture README said the
opposite until 2026-08-02, and the string reached six of the first ten transcripts.

**Check the indexes against the working tree** — the same question one step earlier, so a
disagreement is caught while it is still an edit. Run it after touching §2, §5, a stack note or
the catalog; it exits non-zero, so it can gate a commit:
```powershell
.\process\tools\check-index.ps1
```
It goes further than the mirror check in three ways the mirror check cannot: §5's figures are
compared against `catalog.json` row by row (the catalog is the authority, §5 the only published
copy, and a regenerated sheet leaves them disagreeing), the 40-line orientation cap on stack
notes is enforced rather than trusted, and any PNG *shaped like a sprite sheet* — one horizontal
row of cells, so aspect ratio ≥ 5 — living outside `monsters/` is reported. The geometry test is
deliberate: keying on the folder alone flags `monster.png`, which is the README's banner.

It verifies the mirror against the playbook's own indexes too — §2 for stacks, §5 for sheets —
and refuses one where they disagree. `-Without` on a whole stack therefore fails by design:
§2 would still send the hire after a file that is gone, costing a turn on a 404 in the metric
the tooling gate reads.

**Read the board before a run and before scoring one** — `process/backlog/` is one file per problem,
carried across runs. A run's brief is an item in `grilled`; no item, no run. The script reads the
item files themselves, so there is no index to drift, and it enforces the state rules — exits
non-zero, so it can gate a commit:
```powershell
.\process\backlog\board.ps1 -Open -Full
```

**Hire through the wrapper, never `claude -p` directly** — it keeps the cost/turn envelope and
snapshots the target's worktree between turns, which is what makes "asked before building"
a measurement rather than a recollection:
```powershell
.\process\tools\hire.ps1 -RunId 2026-08-02-alt-a -Target ..\monster-dev-testruns\2026-08-02-alt-a\target `
  -Dist ..\monster-dev-testruns\2026-08-02-alt-a\dist -Model sonnet -BriefFile .\process\scenarios\alt-a.brief.txt
.\process\tools\hire.ps1 -RunId 2026-08-02-alt-a -Target ..\monster-dev-testruns\2026-08-02-alt-a\target -Answer 'keine Präferenz'
```

**Two check roles sit around the hire**, in `.claude/agents/`, because every failure this project
has found late was a single unopposed reader — three verifier defects, three misattributions, and a
leak that survived ten runs.

Before the hire, the **`leak-auditor`** reads the run folder, the mirror and the scenario and asks
the one question no path check asks: *does this setup already answer what the run is trying to
measure?* It reports and does not gate. It is told not to read `process/backlog/` — a reader that
knows the leaks already filed produces a restatement instead of a finding.

After the hire, the **`run-scorer`** scores the run a second time, blind. `score-bundle.ps1` builds
what it sees, and what it cannot see is the point: not the board item that was the run's brief, not
an earlier report, not `CLAUDE.md`. Like a hire, it runs as a separate `claude -p` session with the
bundle as its working directory — an in-process subagent can read this repository, so asking it to
be blind is not a control:
```powershell
.\process\tools\score-bundle.ps1 -RunId 2026-08-02-alt-a -Scenario process\scenarios\alt-a-left-to-right.md
.\process\tools\score-bundle.ps1 -RunId 2026-08-02-alt-a -Remove   # once the second scoring is written up
```
Every disagreement with the first scoring is resolved in the report with a reason, or filed on the
board. Keeping your own verdict quietly is the outcome the second pass exists to prevent.

**Measure what the hire reached, and say in the report that you did** — the standing answer to
`#041`, and the same move this file already prescribes for the real-URL run class. It reads the
captured transcript for paths outside the run folder, `..` traversal, what those calls printed back,
and every URL fetched. Section D is the URL audit that used to be a habit. It exits non-zero on any
reach, so a run whose report is silent about this cannot have been checked:
```powershell
.\process\tools\check-reach.ps1 -RunId 2026-08-03-r12
```
For an archived run, pass the path the run **used**, not where the files sit today — it matches
strings in a transcript, so the current location matches nothing and everything reads as a reach.
Its first sweep over all eleven transcripts reproduced `#019`'s finding on `sonnet-base2` and found
`#042` in the oldest run on the board, which no item had predicted.

**Publish the results as runnable demos** — every `impl-NN/step-4-result/` onto an orphan
`gh-pages` branch, with a banner stating what the customer asked for. They are kept **off `main`**
deliberately: ten finished implementations of the exact job are the answer sheet, and a mirror
exclusion does not contain them, because a run over real URLs never reads a mirror and §0's base
URL points at `main`. The script prints the README's *See it running* table instead of writing it,
and it neither pushes nor switches Pages on — both are outward-facing and stay deliberate:
```powershell
.\process\tools\publish-demos.ps1 -WhatIf   # render and report, touch no branch
.\process\tools\publish-demos.ps1
```

**Add or regenerate a sprite sheet from a video** (requires `ffmpeg` on PATH, Windows PowerShell with `System.Drawing`) — full recipe and the checks that follow it are in `monsters/README.md`:
```powershell
.\tools\provenance\New-SpriteSheetFromVideo.ps1 -VideoPath walk.mp4 `
  -OutputPath .\monsters\<slug>.png `
  -CatalogPath .\monsters\catalog.json -Slug <slug> -Faces left
```
Key tunables: `-DarkThreshold` (outline luminance cutoff), `-NoTealFill` (disable growing into dark-teal-filled limbs), `-TailFadePx` / `-TopTrimMinWidth`, and `-Period` / `-StartFrame` to override the detected gait cycle. Full parameter docs are in the script's comment-based help.

Writing the sheet is not the same as publishing it: `MONSTER-DEV.md` §5 is the only roster a hire can see, so a sheet that isn't in that table is unreachable no matter what `catalog.json` says.

**Check that a sheet loops** — the gate before a sheet is published, and a regression check over the whole roster. Exits non-zero if any wrap exceeds the sheet's own adjacent-cell step:
```powershell
.\tools\provenance\Test-SheetLoop.ps1
```
The generator's own loop-closure figure ranks candidate periods but does not predict the shipped seam: a period it rated an acceptable `1.06x` produced a sheet that hitches at `1.39x`. This script measures the artifact, so it decides.

**Rebuild a sprite sheet from a flat, multi-pose image** (e.g. AI-generated pose sheets with uneven spacing):
```powershell
.\tools\provenance\New-SpriteSheetFromImage.ps1 -ImagePath sheet.png -OutputPath ..\..\walk.png -Background Dark -FrameCount 11
```
`-Background Light` vs `Dark` changes the cutout strategy (flood-fill from a neutral background vs. synthesizing an outline around detected body color, since a black-on-black outline can't be recovered directly). `-FrameCount` must match the actual number of figures — the script keeps only the N largest connected components.

## Working on `START.md` / `MONSTER-DEV.md`

These are prompts, not code — read them in full before editing, since their instructions are internally cross-referencing (e.g. `START.md` tells the agent to derive the repo's raw base URL from the URL it was just fetched from, rather than hardcoding an owner/repo, so the instructions keep working across forks/renames). Preserve that pattern in any edit. Also preserve the sign-off rule in `MONSTER-DEV.md` §8: Monster-Dev must never commit or add a commit trailer on its own initiative — only when the host agent is already committing at the human developer's explicit request.
