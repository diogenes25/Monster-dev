# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not a library**. It's the source for **Monster-Dev**, an AI-developer persona distributed as GitHub-hosted instructions: a hiring agent WebFetches `START.md` (and then `MONSTER-DEV.md`) directly from the raw GitHub URL and thereby takes on the role of a freelance contractor whose one job is to implement a walking-monster easter egg into whatever codebase it's pointed at — idiomatically, in that project's own language/framework/conventions. Nothing from this repo gets cloned or installed into the target project; only the resulting implementation and the sprite-sheet asset do.

This scope is deliberately narrow and closed: the AI-developer-persona packaging applies **only** to this one monster feature. Do not generalize it into a reusable multi-feature pattern, and do not repackage it as a locally-installed Claude Code Skill (`.claude/skills/...`) — both were explicitly considered and rejected in favor of the "nothing installed, always fetched live from `main`" model.

Target publish location: `https://github.com/diogenes25/monster-dev` (not yet pushed as of this writing — repo is git-initialized locally with branch `main`).

## Two features, not one

1. **Monster-Dev** — the contractor. Fetches the playbook, plus the accumulated notes and tooling for *its* rendering surface if any exist.
2. **The Monster-Dev developer** — the loop that produces those notes and that tooling and *proves* they help: test run → findings → fold in → rerun. Lives in the `monster-dev-workshop` skill and in `test/`.

Three layers grow with every run — the playbook (general), stack notes (per surface), tooling (spares a hire derivation and measuring). None of them grows on a hunch; see "The proof gates" below.

## Repository layout — who fetches what

| Path | Role | Fetched by a hire? |
|---|---|---|
| `START.md` | Entry point pasted as a raw URL. **Keep it short and stable** — method changes belong in `MONSTER-DEV.md` | yes |
| `MONSTER-DEV.md` | The playbook: analysis framework, onboarding questions, the surface-agnostic technique, sign-off, cleanup | yes |
| `stacks/<name>/README.md` | Delta notes for one rendering surface, each entry traceable to the run that produced it | yes, the matching one |
| `stacks/<name>/tools/` | Tooling for that surface only | yes, with it |
| `tools/hire/` | Cross-stack hire tooling | yes |
| `monsters/<slug>.png` | The sprite sheets — shell download, never WebFetch, since WebFetch is unreliable for raw binary bytes | yes, the chosen one |
| `monsters/catalog.json` | Machine-readable record of each sheet's geometry, tempo and provenance, written by the generator | no — the roster a hire reads is the table in `MONSTER-DEV.md` §5 |
| `index.html` | A working `dom-css` implementation. **No longer the universal reference** — reachable via `stacks/dom-css/` | via that stack |
| `tools/provenance/` | Offline sprite-sheet pipelines | never |
| `sources/` | The footage the sheets were cut from, kept so they stay regenerable | tracked, so technically yes — but nothing points a hire at it |
| `test/`, `.claude/` | Measurement and procedure of feature 2 | **never** |

Stacks are keyed by **rendering surface + animation primitive**, not by language: a TypeScript React app and a plain HTML page can be the same job, while two Python projects can be entirely different ones. `MONSTER-DEV.md` §2 lists **only stacks that actually exist** — `raw.githubusercontent.com` serves no directory index, so an unlisted stack is unreachable, and a listed-but-absent one is a dead pointer.

### The one invariant that silently invalidates everything

`test/` and `.claude/` are **tracked**. They used to drop out of the `<dist>` mirror because git ignored them; now the exclusion has to be deliberate. Miss it and every hire reads its own acceptance criteria, and every future run is worthless.

Never hand-roll the mirror. `test/tools/build-dist.ps1` builds and verifies it in one step and deletes the mirror rather than return a leaking one. For the same reason, **nothing that encodes the acceptance criteria may live under `tools/`** — the run verifier belongs in `test/tools/`, which is excluded already.

### The proof gates

- **Playbook wording** → regression: fold in, rerun the same scenario, the failing criterion must flip.
- **Stack notes** → A/B: precautionary knowledge usually has no prior failure to flip, so compare a run with the lines against one without. No difference means the lines go.
- **Tooling** → A/B with cost: `total_cost_usd` / `num_turns` must drop measurably *and* no criterion may regress. Neither, and the tool goes.

The bar is a **Sonnet**-class hire. Opus solves the known pitfalls unaided, which leaves nothing to measure; a Haiku failure is explicitly not a finding.

## Developing Monster-Dev itself

Use the **`monster-dev-workshop` skill** (`.claude/skills/monster-dev-workshop/`) for any work *on* the product: editing `START.md`/`MONSTER-DEV.md`, changing `index.html` or the sprite sheet, adding a stack or a tool, or running and scoring a test hire. It carries the playbook invariants, the full run procedure, and the scenario/report/findings templates.

That skill is dev-side tooling *about* Monster-Dev — it is not, and must not become, a packaging of the product itself.

## Commands

There is no build/lint/test tooling for this repo (static HTML/CSS/JS + Markdown + standalone PowerShell scripts).

**Preview `index.html`:** `.vscode/launch.json` is set up to launch Chrome against `http://localhost:8080` with the repo root as web root — serve the repo root with any static file server on port 8080, or simply open `index.html` directly in a browser.

**Build the `<dist>` mirror for a test hire** (never by hand — it builds *and* verifies, and deletes a leaking mirror instead of returning it):
```powershell
.\test\tools\build-dist.ps1 -RunId 2026-08-02-alt-a
.\test\tools\build-dist.ps1 -RunId 2026-08-02-alt-a-armA -Without 'stacks/dom-css/*'   # an A/B arm
.\test\tools\check-isolation.ps1 -Target ..\monster-dev-testruns\2026-08-02-alt-a
```

**Add or regenerate a sprite sheet from a video** (requires `ffmpeg` on PATH, Windows PowerShell with `System.Drawing`) — full recipe and the checks that follow it are in `monsters/README.md`:
```powershell
.\tools\provenance\New-SpriteSheetFromVideo.ps1 -VideoPath walk.mp4 `
  -OutputPath .\monsters\<slug>.png `
  -CatalogPath .\monsters\catalog.json -Slug <slug> -Faces left
```
Key tunables: `-DarkThreshold` (outline luminance cutoff), `-NoTealFill` (disable growing into dark-teal-filled limbs), `-TailFadePx` / `-TopTrimMinWidth`, and `-Period` / `-StartFrame` to override the detected gait cycle. Full parameter docs are in the script's comment-based help.

Writing the sheet is not the same as publishing it: `MONSTER-DEV.md` §5 is the only roster a hire can see, so a sheet that isn't in that table is unreachable no matter what `catalog.json` says.

**Rebuild a sprite sheet from a flat, multi-pose image** (e.g. AI-generated pose sheets with uneven spacing):
```powershell
.\tools\provenance\New-SpriteSheetFromImage.ps1 -ImagePath sheet.png -OutputPath ..\..\walk.png -Background Dark -FrameCount 11
```
`-Background Light` vs `Dark` changes the cutout strategy (flood-fill from a neutral background vs. synthesizing an outline around detected body color, since a black-on-black outline can't be recovered directly). `-FrameCount` must match the actual number of figures — the script keeps only the N largest connected components.

## Working on `START.md` / `MONSTER-DEV.md`

These are prompts, not code — read them in full before editing, since their instructions are internally cross-referencing (e.g. `START.md` tells the agent to derive the repo's raw base URL from the URL it was just fetched from, rather than hardcoding an owner/repo, so the instructions keep working across forks/renames). Preserve that pattern in any edit. Also preserve the sign-off rule in `MONSTER-DEV.md` §8: Monster-Dev must never commit or add a commit trailer on its own initiative — only when the host agent is already committing at the human developer's explicit request.
