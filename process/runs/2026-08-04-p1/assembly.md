# Assembly — 2026-08-04-p1

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

*Empty until the `leak-auditor` has run. Its findings go here as `file:line`, the
criterion each one short-circuits, and the quote — then, separately, what was done about
each. A finding deliberately not acted on is a finding to write down rather than leave
out: on `2026-08-03-r15` all nine were properties of the fixture, the stack note or the
mirror, so all nine were identical in both arms and none could bias the comparison.
That is a reason. An empty section under a finished run is not.*

## Notes

*Anything about this setup a tool does not know.*

## Tool log

### new-run.ps1 — 2026-08-04 16:09:04
- fixture: `static-site` (from `process\fixtures\static-site`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-04-p1\target`
- base commit: `2baa52c` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### hire.ps1 — 2026-08-04 16:09:04
- model: `sonnet` · fixture: `static-site` · fetch path: `real-urls`
- no mirror — entry point handed over as the URL `https://raw.githubusercontent.com/diogenes25/Monster-dev/main/START.md`
- entry point in the brief: `https://raw.githubusercontent.com/diogenes25/Monster-dev/main/START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
