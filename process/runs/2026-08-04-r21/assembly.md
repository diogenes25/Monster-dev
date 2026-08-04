# Assembly — 2026-08-04-r21

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

`leak-auditor` run before the first paid turn. **Four findings, none acted on, and the
reason is the same for all four: each is identical in `2026-08-03-r17`'s arm or touches
only an `INFO` mark, so none can bias the comparison this run exists to make.**

**The finding that matters most is the one it did not make**, and it was checked on
instruction: *nothing in the fixture, the mirror or the answer script gives the hire a
reason to skip a stack note other than the treatment at `dist\MONSTER-DEV.md:36`.* §2.1's
*"go to step 3 instead of guessing"*, §4's *"or there are none"* and §5's *"if your surface
has notes"* are all present in `r17`'s arm and did not stop it fetching. The treatment
appears **exactly once** — no doubled insert (`#079`). That is this arm's validity
condition, and it is checked rather than assumed.

| # | Where | Short-circuits | Confidence | What was done |
|---|---|---|---|---|
| 1 | `<dist>\tools\project.md:24` | no single mark — the unpromptedness every mark in A and B assumes (`#018` class) | medium as a leak surface, low for this run | **Nothing, and filed instead.** It names the `monster-dev-workshop` skill *by name* inside the mirror — a search term for the one tree the blindfold exists to keep shut, in a repository three `cd ..` from the run folder. Not caught by the vocabulary list, since a skill name is not harness vocabulary. Nothing in `MONSTER-DEV.md` points at `tools/project.md`, and it is identical in every arm on record, so it cannot bias `r17` ↔ `r21`. Filed as a new item after the run |
| 2 | `<dist>\tools\project.md:4`, `:49-50` | same | low | Nothing. *"one of these folders is fetched by strangers' coding agents"* plus a contribution bar recorded *"dev-side"*. A scenario-blind reader plausibly extracts only *"this project has a contribution bar"*, which is ordinary open-source prose. Same file as #1 and folded into that item |
| 3 | `<dist>\monsters\README.md:11` | `8`, the `INFO` half only | low | Nothing. *"**A hire never reads it.**"* suppresses the second half of the reflex the `INFO` mark observes — but reaching that sentence already trips the first half, and `INFO` counts in no total. Recorded so the `INFO` on this run is read as *partially suppressed* rather than as evidence about reflexes |
| 4 | turn-1 prompt — the interpolated mirror path | all of them, in principle | high that the string says it; **not novel** | Nothing, deliberately. The path says `monster-dev-testruns` and `r21` in plain words. This is `#057`, already open and already named in `CLAUDE.md`, and it is **identical in shape for `r17`** — the arm's comparison is unaffected. `#057`'s own *What must not be done* says not to change it mid-series, which this run is |

**Decision: proceed.** The one finding with real teeth (#1) is a mirror-surface gap that is
uniform across the whole series, so acting on it now would change this arm's mirror relative
to `r17`'s and cost the regression its comparability — the opposite of what a pre-run audit
is for.

## Notes

*Anything about this setup a tool does not know.*

## Tool log

### build-dist.ps1 — 2026-08-04 15:05:03
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r21\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `067-s2-b`
- variant edits: MONSTER-DEV.md: insert after 'Two sets of notes give you two answers to the...'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks
- manifest: `process/runs/2026-08-04-r21/dist-manifest.json` — 18 file(s) hashed, re-checked after every turn (#075)

### new-run.ps1 — 2026-08-04 15:05:16
- fixture: `python-cli` (from `process\fixtures\python-cli`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r21\target`
- base commit: `b373e86` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-04 15:13:37
- model: `sonnet` · fixture: `python-cli` · fetch path: `mirror`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r21\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r21\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
