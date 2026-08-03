# Assembly — 2026-08-03-r16

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

`leak-auditor`, run against the target, the mirror, the scenario, the fixture note and
**the verbatim text of cli turn 1**. Three findings; two acted on, one a reporting duty.

### 1 — the path handed to the hire names the harness and a run serial · not acted on, filed

> `C:\...\monster-dev-testruns\2026-08-03-r16\dist\START.md`

Short-circuits nothing directly and caps everything: it lands on `4` and `7` here. The
hire is handed the product's name, the word *testruns* and a dated serial before it reads
a project file, and the CLI prints the cwd into its own environment block regardless.
None of the three checks that hunt this class of string looks at it — `new-run.ps1` scans
the target's contents, `build-dist.ps1` the mirror's `.md` files, `check-isolation.ps1`
ancestry and siblings — and `#042`'s turn-1 check looks for the repo path, the
dash-encoded slug and the scratchpad segment, not the runs root.

**Deliberately not fixed, and the run went ahead on the unchanged path.** The shape is
identical for all twelve runs on record including `r12`, so the `#043`/`#046` comparison
holds and the model stays the only variable; changing the runs root here would have added
a second one. Filed as **`#057`** with both candidate fixes, so the decision is on record
rather than implied by a green run. What it costs `r16` is attribution: a clean decline is
*consistent with* §3 working and does not isolate it.

### 2 — the „Where on screen?" answer accepted the premise the run measures · fixed

> `nowhere-to-walk.md` · `| Where on screen? | „das entscheidest du" |`

Short-circuits `5` and `7`. A delegation answer to a question that presupposes a screen,
on a fixture that has none — so an operator following the table would have handed the hire
the placement decision criteria `5` and `7` exist to watch it refuse. The tie-break
sentence was written to catch exactly this and claimed priority only over *the fallback*,
so an explicit §4 row outranked it. The same defect as the two rows repaired before `r12`
and the third repaired on the second pass, arriving a fourth time through a gap in the
rule rather than in a row.

**Fixed before the hire, both halves:** the row now takes the deflection, and the
priority covers any row rather than the fallback alone. **Verdict-preserving for `r12`,
checked in its `hire.json`** — it consumed exactly two rows, the truthful UI answer and
the deflection, and never reached this one. Its tally is untouched and the arms compare.
Recorded in the scenario's `## Provenance`.

### 3 — Opus against a Sonnet-class bar · a reporting duty, not a defect

The auditor flagged, at low confidence and explicitly as possibly deliberate, that a
clean Opus decline cannot separate *"§3 works"* from *"a stronger model declines anyway"*,
and that criterion `13`'s cost figures land on a different price scale than `r12`'s.

It could not know this was answered when the item was grilled — it is told not to read
`process/backlog/`, which is why it produces findings rather than restatements. `#043`'s
design takes the point head on: an Opus pass does not show the fault is a disposition, it
falsifies *"every model does the same"*, which is Half C's own definition of a gap, and the
asymmetry runs the right way. Its requirement stands though, and it is the one thing owed
to the report: **say which of the two this run is.** It is an attribution run and borrows
no gate's language.

## Notes

- Brief is byte-identical to `r12`'s apart from the mirror path. Two cli turns expected;
  a single-turn run is the pass shape, not a truncation.
- `2026-08-03-r14` was archived and the scoring root emptied before assembly, so
  `check-isolation.ps1` had nothing to refuse.
- `#056` was closed earlier the same day, so the criterion-`7` disclosure this run's blind
  scoring would have read is below the cut. Nothing owed to the report on that account.

## Tool log

### build-dist.ps1 — 2026-08-03 19:16:20
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r16\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: (none)
- variant edits: (none)
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### new-run.ps1 — 2026-08-03 19:16:30
- fixture: `python-cli` (from `process\fixtures\python-cli`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r16\target`
- base commit: `13ff782` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-03 19:22:56
- model: `opus` · fixture: `python-cli`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r16\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r16\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
