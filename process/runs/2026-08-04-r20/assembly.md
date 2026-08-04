# Assembly — 2026-08-04-r20

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

**Carried over from `2026-08-04-r19`, whose setup this is byte for byte** —
`process/runs/2026-08-04-r19/assembly.md` holds the eight findings and the disposition of each,
and it is cited rather than restated so the two copies cannot disagree.

`r19` was refused by the hire in turn 1 (`#050`) and produced no data. **This run is that run,
rerun with a fresh id and nothing else changed** — which is `2026-08-03-r13` → `r15`'s precedent
and is deliberate: the one repair that would prevent the refusal is reassuring the hire about its
instruction source, which `DISCUSSION-2026-08-03.md` forbids as *"exactly the text a malicious
instruction file would also contain."*

What the audit changed before `r19`'s turn was bought, and what therefore governs here:

1. **The answer script gained a row** for the question class §3's treatment authorises — *"have I
   missed a surface that already exists?"* — because the fallback would have answered it with
   „nimm deinen Standard", i.e. *proceed*, silently resolving the hesitation this run exists to
   observe. Verdict-preserving; no earlier `static-site` session ever asked.
2. **`20a` gained a carve-out** for a stated-sheet arm: criterion `19` forces the plan into the
   same message as the questions, so `18d` announces the §5 default and the client then names
   another sheet — a departure the criteria themselves make unavoidable. `20b` untouched.

And the four findings that were recorded rather than fixed, all of which still apply:

3. **The `dom-css` note hands over the substitution `#053`'s strolling arm was bought to detect**
   (`stacks/dom-css/README.md:32`). The residual tell is `--stride: 130px` / `--crossing: 16s`,
   which §5 derives from nothing and the note does not supply. **Pre-committed: either value in the
   implementation is a copy, whatever `10a`–`10c` score.**
4. **The same note pre-answers `9`, `18b` and `18c`**, and the fixture's `Pre-answered` table
   cannot account for it because the note is not part of the fixture. Uniform across the series;
   this run's report carries the long clause.
5. **The treatment could damp the §4 question round** — *"finishing with what you found, not with a
   question"* read out of §3's conditional. **Pre-committed: a regression on `4a`, `14a` or `19` is
   a §3 finding, not a §4 one**, and it is the treatment's price rather than a §4 gap. Note the
   coupling: on this arm `10`'s value is conditional on `14a` passing, so that regression would
   cost the `#053` purchase in the same stroke.
6. **The treatment is the only may/may-not permission grammar in the playbook.** Register only.
   Not fixed — the three arms must read the same bytes — and recorded as the first edit to consider
   if the wording is folded in.
7. **`tools/project.md:49` still says jobs are measured against a bar recorded dev-side**, and the
   harness-vocabulary check does not fire on it. Uniform since the `2026-08-02` boundary. Filed.
8. **`#057`** — the runs-root path names the harness and a serial. Standing, unchanged.

**No second `leak-auditor` pass was bought.** The setup is byte-identical to the one just audited
apart from the run id, and re-auditing it would ask a reader who has no new information to find
something a reader with the same information did not. The two scenario edits above are the only
delta, and both are the audit's own output rather than something it has not seen.

## Notes

- **`#061` Phase 3, attempt 2.** Sonnet, `alt-a-left-to-right`, treated mirror. Phases 1 and 2 are
  green; this is the *"nothing regressed"* half of the gate and the only owed arm.
- **The treated file is byte-identical across all four mirrors built for this item** —
  `1D087D8580FC7517F5DE8F0066BAC866B65D55C0A701AE127DCC2CB8A99ADB54`, the same hash as `r17`, `r18`
  and `r19`. `main` is untouched.
- **The brief is byte-identical to `2026-08-03-r15`'s** apart from the run id, built by substituting
  into that run's own stored prompt. `r15` is the baseline this run is compared against, and it is
  itself a rerun after a refusal — the same shape as this one.
- **Monster row: „nimm `green-fuzz-strolling`"**, per the owner decision recorded in `#061`.
- **`F4` is open and this run does not close it.** `18a` is scored with the caveat stated in the
  report rather than skipped.

## Tool log

### build-dist.ps1 — 2026-08-04 00:31:04
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r20\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `061-s3-b`
- variant edits: MONSTER-DEV.md: insert after 'say so plainly and stop.'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### new-run.ps1 — 2026-08-04 00:31:08
- fixture: `static-site` (from `process\fixtures\static-site`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r20\target`
- base commit: `3887f4f` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-04 00:31:48
- model: `sonnet` · fixture: `static-site`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r20\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-r20\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
