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
| `tools/project.md` § `hire/` | The **rules** cross-stack hire tooling would have to meet. No such folder exists and none ever has — git tracks no empty directory, so nothing was ever fetchable (`#055`) | the file, yes; the folder, there is none |
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

`process/`, `.claude/`, `CLAUDE.md` and the root `README.md` are all **tracked**, and all four are kept out of the `<dist>` mirror by hand — every exclusion deliberate, none of them inherited from `.gitignore` any more. Miss one and every hire reads its own acceptance criteria, or reads that it is a fresh agent in a scored test run, which is what eight of the first ten did (`#018`).

Each name is written by hand in **two** places in `build-dist.ps1` — the exclusion glob and the backstop that verifies it. Renaming one breaks both in the same moment and in the same direction: the filter matches nothing, and the check hunts a file that no longer exists and reports clean. That is what the `test/` → `process/` rename walked into (`#008`). Rename one again and you must change both lines *and* build a mirror and look inside it; a green script is not evidence.

**Two further mirror checks name no path at all**, because a path list only ever excludes the leaks somebody already found. Every `.md` in the assembled mirror is grepped for a short harness vocabulary (`acceptance criteria`, `test run`, `A/B`, …), and every file is checked for a reference to a sprite sheet under `monsters/` — the first catches prose describing the experiment, the second a finished solution to the brief, which contains none of those words. A vocabulary term that fires on legitimate playbook prose is **removed from the list**, never accommodated by rewording the playbook; `harness` is out for exactly that reason, since §7 tells a hire to build a scratch one.

Never hand-roll the mirror. `process/tools/build-dist.ps1` builds and verifies it in one step and deletes the mirror rather than return a leaking one. For the same reason, **nothing that encodes the acceptance criteria may live under `tools/`** — the run verifier belongs in `process/tools/`, which is excluded already.

### The mirror is a blindfold, not a vault — and the difference decides every question about it

**Nothing here is secret, and nothing here may become secret.** This is open source, and what it distributes is a *stranger's AI developer working inside your codebase*. That asks an unusual amount of trust, and the only currency it can be paid in is legibility: how the contractor works, what it is scored on, what has already been measured and what went wrong. A user who cannot read the acceptance criteria cannot judge whether the thing is any good; a contributor who cannot read them cannot do what this project wants contributors to do — clone it, pose their own requirement, push back another test. So `process/`, `.claude/` and this file being world-readable on `main` is **the design**, not an exposure.

What the mirror exists for is something else entirely: **a hire that reads its own acceptance criteria mid-run stops being a measurement.** Not because it learned a secret, but for the same reason a subject is not told what is being scored while it is being scored. The exclusions are a blindfold worn for the duration of an experiment, by one participant, and they say nothing about who else may look.

Read every question about the mirror that way and it answers itself. Two that follow — full argument and its measurements in `#031`:

- **The exclusions cover exactly one run class.** A hire fetching real `raw.githubusercontent.com` URLs reads `main` and never sees a mirror, so nothing blindfolds it. That is not a hole to plug by hiding things — it is a **validity condition of that run class**, and the way to hold it is to measure it (`check-reach.ps1` section D) and to say in the report that you did. If a run reaches further than the playbook pointed, that run is contaminated — the repository is not.
- **The demos live on `gh-pages` and not on `main`** for the same reason and not a secrecy one. Visitors and contributors *should* see ten finished results; a hire measured on the identical brief should not be able to copy one. Off `main`, both hold at once.

Do not reach for the sentence about `raw.githubusercontent.com` serving no directory index when reasoning about any of this. It is true of that one endpoint and of nothing else — `github.com/<owner>/<repo>/tree/main/...` returns an HTML listing to the same `WebFetch` the playbook hands the hire, and one unauthenticated `api.github.com/...git/trees/main?recursive=1` call names every file in the repository in a single request. Nothing is hidden by obscurity here, and nothing should be built as though it were.

### One run, one parent

A run folder and its mirror are `../monster-dev-testruns/<run-id>/target/` and `.../<run-id>/dist/`. They used to be direct children of the runs root, which put every previous run one `ls ..` away from the hire — dated folders with the model in the name, holding finished, already-scored implementations of the identical brief. One hire ran that listing (`#019`). Hence the nesting, and hence `check-isolation.ps1` looking sideways at **two** levels: the fix that nested the run also moved the dangerous listing from `..` to `..\..`, where the sibling test it added in the same change no longer looked, and it printed `isolation OK` over twenty directories (`#040`). **A check that relocates an exposure and then reports clean is worse than the exposure** — that is the sentence to remember before simplifying either level away.

**Nobody may say that closes it.** `ls ..\..\..` returns this repository — the runs root is a sibling of the working copy, so `CLAUDE.md`, `process/` and the run's own scenario are three `cd ..` from where a hire starts, and were for all eleven runs on record (`#041`). It is a **location** problem, and no arrangement of sideways checks fixes a location; the level above the runs root holds unrelated projects, so it cannot be required to hold only the run. Two things follow:

- **The location was deliberately not changed**, for the reason the section above already gives about the real-URL class: measure the exposure rather than hide it. `check-reach.ps1` reports what the hire actually walked to, and a report silent about reach has not checked — strictly better evidence than a relocation, which only ever supports *"we believe it could not get there."*
- **Where the runs root is lives in exactly one place** — `process/tools/lib/run-root.ps1`, dot-sourced by `new-run.ps1`, `build-dist.ps1`, `score-bundle.ps1` and `check-isolation.ps1`, overridable by `MONSTER_DEV_RUN_ROOT`, refusing any root inside this repository. Three scripts used to derive `..` separately and agreed by coincidence. Moving the root later is a one-line edit there.

**A blind-scoring bundle left on disk blocks the next hire.** Each holds `criteria.md` in full and the scoring root is a sibling of the runs root, so the same walk reaches both — and being buried among unrelated folders is obscurity, which this file forbids relying on. Deleting it after scoring is a closing step, and a closing step is a step to forget, so `check-isolation.ps1` refuses to start a hire while any bundle exists. Close one deliberately with `score-bundle.ps1 -RunId <id> -Remove`. A bundle for the run *being hired* is the sharpest case rather than an exemption: it means an earlier attempt was already scored.

**And a path handed to a hire is part of the mirror surface.** The first run was given an entry point running through a session scratchpad, whose slug is this repository's absolute path with the separators turned into dashes; the hire decoded it and listed the repository root. It never walked up — it was handed the address (`#042`, and `#057` for what the path itself still says). Check what turn 1 *says*, not only where it runs.

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

### The run harness — `process/tools/`

**The `monster-dev-workshop` skill is authoritative for the sequence** and `process/README.md` for
why the harness is shaped the way it is. What follows is the map, not the procedure: open the skill
before running or scoring a hire, and when the two disagree the skill is what actually gets
executed. Nothing here is ever done by hand — each of these refuses or deletes rather than hand back
something subtly wrong, which is the whole reason it exists.

| Command | What it does |
|---|---|
| `new-run.ps1 -RunId <id> -Fixture <name>` | Creates the run folder from a fixture **and opens the run's record** (`process/runs/<id>/assembly.md`, so an assembled-then-refused setup still leaves something behind — `#048`) |
| `build-dist.ps1 -RunId <id>` | Assembles the mirror, **verifies it, and fingerprints it** — a manifest under `process/runs/<id>/` so that a hire writing into the mirror afterwards is a finding rather than luck (`#075`). `-Without <path>` builds an A/B arm; a whole stack fails by design, because §2 would still point at a file that is gone |
| `check-isolation.ps1 -Target <path>` | Standalone; `new-run.ps1` has already run it. Up **and two levels sideways**, and refuses to start a hire while any scoring bundle is on disk |
| `check-index.ps1` | §2 and §5 against the working tree *and* the mirror — `catalog.json` row by row, the 40-line orientation cap, sheet-shaped PNGs outside `monsters/`. Run it after touching §2, §5, a stack note or the catalog |
| `backlog/board.ps1 -Open -Full` | The board, read from the item files so no index can drift, with the state rules enforced |
| `hire.ps1 -RunId <id> -Target <path> -Dist <path> -Model sonnet -BriefFile <file>`, then `-Answer '<text>'` | **The only way to hire.** Holds the cost/turn envelope, snapshots the target's worktree between turns, and re-checks the mirror against its manifest — a write inside the mirror is not a reach, so nothing else can see it |
| `score-bundle.ps1 -RunId <id> -Scenario <file>`, later `-Remove` | Builds what the blind `run-scorer` sees, and takes it back off disk |
| `check-reach.ps1 -RunId <id>` | What the hire walked to and every URL it fetched. For an **archived** run pass the path the run *used* — it matches strings, so today's location matches nothing and everything reads as a reach |
| `check-hire-records.ps1 [-RunId <id>]` | Sweeps every `hire.json`: `totals` recomputed from `turns[].envelope`, and whether each report quotes its **own** recorded cost. Reports rather than throws — most of what it finds is history. Three defects had accumulated in the gap where nothing compared the two (`#074`, `#077`, `#063`) |
| `publish-demos.ps1 [-WhatIf]` | Every `impl-NN/step-4-result/` onto an orphan `gh-pages` branch, with a banner stating what the customer asked for. Prints the README's *See it running* table rather than writing it, and neither pushes nor switches Pages on — both are outward-facing and stay deliberate |

**And the rules around them, which no exit code enforces.** Each of these has already cost a run:

- **A run's brief is a `Gate: run` item in `grilled`.** No item, no run.
- **Dependencies are installed at setup, never by the hire** — inside the session they land in
  `num_turns` and `total_cost_usd`, two of the three numbers the gates are stated in.
- **A fixture folder holds only what the target project would hold.** What a fixture is *for* — the
  marks it exists to turn on, what a correct run looks like — goes in `process/fixtures/<name>.md`,
  a sibling, for the same reason the setup recipe does. Every fixture README said the opposite until
  `2026-08-02`, and it reached six of the first ten transcripts (`#015`, `#054`).
- **Two check roles sit either side of the hire**, in `.claude/agents/`, because every failure this
  project found late was a single unopposed reader. The **`leak-auditor`** asks the one question no
  path check asks — *does this setup already answer what the run is trying to measure?* — reports,
  and does not gate; it is told not to read `process/backlog/`, since a reader who knows the filed
  leaks restates instead of finding. The **`run-scorer`** scores blind, as a separate `claude -p`
  session with the bundle as its working directory, because an in-process subagent can read this
  repository and asking it to be blind is not a control.
- **Above `## Run log` in a scenario is what the blind scorer reads** — the setup, the **current**
  answer script, the criteria, the rules for scoring them. How the file got that way goes below it
  under `## Provenance`, because **a criterion's history is not an instrument**: handing it over
  hands over the map with the criterion at risk already circled (`#056`, `#047`). The bundle refuses
  a criteria half that names any run id, and that check is narrower than the rule — a pass rate
  quoted without a run id defeats it.
- **Every disagreement with the first scoring is resolved in the report with a reason, or filed.**
  Keeping your own verdict quietly is the outcome the second pass exists to prevent.
- **A report silent about what the hire reached has not checked it** (`#041`).
- **The demos stay off `main`.** Ten finished implementations of the exact job are the answer sheet,
  and a mirror exclusion does not contain them: a run over real URLs never reads a mirror, and §0's
  base URL points at `main`.

**Add, regenerate or re-cut a sprite sheet** — two generators and a loop gate under
`tools/provenance/`, run once per sheet and never during a run. **The recipes, every tunable, and
the ordered steps that follow a generator live in [`monsters/README.md`](monsters/README.md)** — go
there rather than here, which held a partial second copy until `2026-08-03`. Two points belong in
this file because they are easy to get wrong from outside that one:

- The gate is `Test-SheetLoop.ps1`, which measures the shipped artifact, **not** the generator's own
  loop-closure figure. The two disagree, and the README has the case that showed it.
- Writing a sheet is not publishing it: `MONSTER-DEV.md` §5 is the only roster a hire can see, so a
  sheet missing from that table is unreachable no matter what `catalog.json` says. `check-index.ps1`
  compares the two row by row.

## Working on `START.md` / `MONSTER-DEV.md`

These are prompts, not code — read them in full before editing, since their instructions are internally cross-referencing (e.g. `START.md` tells the agent to derive the repo's raw base URL from the URL it was just fetched from, rather than hardcoding an owner/repo, so the instructions keep working across forks/renames). Preserve that pattern in any edit. Also preserve the sign-off rule in `MONSTER-DEV.md` §8: Monster-Dev must never commit or add a commit trailer on its own initiative — only when the host agent is already committing at the human developer's explicit request.
