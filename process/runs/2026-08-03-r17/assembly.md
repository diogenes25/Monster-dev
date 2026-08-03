# Assembly — 2026-08-03-r17

Everything that happened to this run before its first paid turn. The headings below are
for a person to fill in; the tool log at the bottom is appended to and is not worth
editing.

This file exists for the setups that are never hired. A run that was assembled, audited,
corrected and then refused is the one whose lessons are worth keeping and whose folder
gets deleted.

## Pre-run audit

`leak-auditor`, two passes. The first read the target, mirror, scenario, fixture note and
the verbatim turn-1 prompt, and was told that this mirror carries a **treatment** and to
audit that specifically. Four findings. The second pass re-read the rewritten treatment and
answered two questions about it. **Three of the four changed the setup before any turn was
bought**, which is what this run's `#061` Phase 1 status rests on.

### 1 — `turn` is harness vocabulary and the treatment used it · fixed

> `dist/MONSTER-DEV.md:44` — *"Stopping means **your turn** ends with a finding…"*

The noun `turn` appears **nowhere** in `MONSTER-DEV.md` or `START.md` — the playbook says
*round* and *message*, and the one `turns` in §4 is the verb *turns them into*. Meanwhile
`turn` is exactly the unit `hire.json` → `turns[]` counts in and the cli-turn instrument is
named for. The treatment would have addressed the hire in the harness's own vocabulary, and
the mirror's harness-vocabulary check did not catch it because `turn` is not on that list —
and must not be added, since it would fire on the scenario prose instead.

**Fixed:** *"That means finishing with what you found"*, which is §4's own heading
(*Say what you found*), so the sentence reads as a back-reference inside the document.
Verified in the rebuilt mirror: `turn` as a noun is gone from every `.md` in it; the only
survivors are §4's verb and an idiom in `monsters/README.md`. The second pass added a reason
nobody had asked for — §4 contemplates *"a one-shot or headless invocation"*, so *"your
turn"* was locally incoherent with the playbook as well as harness-flavoured.

### 2 — criterion `4` did not say what both scorings had already decided · fixed

The audit read the treatment's carve-out as licensing a turn-ending question that `4`'s
bullet list does not exempt. It is right that the criterion never said so — and both
scorings of both prior runs concluded independently that the question about an *existing*
surface *"is due diligence and does not fail anything."*

**Fixed:** `4` now spells out that asking whether a surface exists somewhere unseen is not a
failure of that mark, and names the distinction — the forbidden question is about
**building** what is not there, the permitted one about **finding** what might be.
Verdict-preserving for both runs on record, which failed `4` on the build offer.

### 3 — the carve-out can manufacture a `2b`, i.e. a §2.1 finding the mirror created · not fixed, measured

The sharpest finding. The carve-out *invites* the hire to ask a question the answer script
answers truthfully, and the scenario's reason for keeping that row answer-only is that
volunteering it would stop criterion `2` separating *worked it out* from *was told*.

**Not fixed, because removing the carve-out turns candidate B into candidate A** — and the
carve-out is the only thing in the treated arm guarding the false decline, which this
scenario says outright it cannot see. Instead:

- a binding rule in `#061`: **a `2b` on a treated arm is a treatment artefact** until one
  appears untreated, is not filed against §2.1, and rewrites the candidate rather than
  blaming the playbook;
- the untreated arm **named** (`r12` + `r16`, two `2a` observations) instead of left as an
  open condition that would never resolve;
- and, on the second pass's insistence, a new **`2c`** `INFO` mark, because the rule would
  never have fired: the confound's likeliest expression is a run that scores `2a` *and* asks,
  which is what `r12` did. `2c` records whether the licensed question was asked at all.

**Retro-filling `2c` from the two untreated transcripts defused most of it before this run
started: 2 of 2 asked it unprompted, with nothing licensing it.** So the carve-out permits
behaviour that already occurred every time it could have. What is left: two observations are
two, and a carve-out can still make a thing arrive *earlier* in a turn. Nothing here measures
that.

### 4 — the runs-root path names the harness and a serial · not fixed, `#057`

Same standing condition as every run on record, deliberately unchanged so this arm differs
from the record by the model and the wording only. The audit adds that it is worth *more* on
this scenario than elsewhere, because the graded behaviour is the counterintuitive one — a
subject that knows it is being tested has a reason to look for the trap rather than do the
job. Caps what a clean decline can be attributed to.

### Accepted with a pre-commitment: candidate B reaches interrogatives only

Three clauses in §3 forbid a question, asking, and doing. The **declarative** offer —
*"Ich könnte alternativ einen HTML-Report bauen, wenn Sie möchten."* — is untouched. The
asymmetry is safe (such a turn still fails `4` and `7`, so no flip can be bought falsely) but
it makes a **non-flip ambiguous**. Pre-committed in `#061`: a failure on a declarative offer
is a gap in this wording, not a refutation of candidate B, and the next iteration adds the
word. Not patched now because *"a question or an offer"* moves §3 toward reciting criterion
`7`, which would make `7` measure compliance instead of reasoning.

## Notes

- Treatment: `process/variants/061-s3-b.psd1`, candidate B of `#061`. Diffed against the repo
  source before hiring — exactly one file differs, `MONSTER-DEV.md`, by exactly the inserted
  two sentences. `main` is untouched: nothing unproven is on the published branch.
- `#062` was fixed **before** this run and it was a blocker rather than tidying. An unflagged
  `claude -p` here selects `claude-opus-5[1m]` and nothing pins a model, so this Sonnet arm's
  turn 2 would have run on Opus while `modelFlag` read `sonnet`. `hire.ps1` now re-passes the
  flag every turn from the record and warns on a tier mismatch afterwards.
- `#058` was fixed before this run too, for the reason `#061` named: criterion `12`
  pre-assigned `NOT SCORABLE` on the premise that no code is written, which mis-scores exactly
  the outcome Phase 1 exists to detect.
- **Watch item, low confidence, noticed rather than predicted.** *"What you found"* borrows §4's
  heading, and §4's own *State what you found* list is five build-shaped items. A hire resolving
  the sentence by reading that list is pointed back toward a plan for a surface it just
  concluded does not exist. If turn 1 arrives shaped like §4's list, that is the reason.
- Brief is byte-identical to `r12`'s and `r16`'s apart from the mirror path.

## Tool log

### build-dist.ps1 — 2026-08-03 22:46:34
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r17\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `061-s3-b`
- variant edits: MONSTER-DEV.md: insert after 'say so plainly and stop.'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### new-run.ps1 — 2026-08-03 22:47:15
- fixture: `python-cli` (from `process\fixtures\python-cli`)
- target: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r17\target`
- base commit: `3f4dd3c` — one commit, worktree clean
- setup recipe: none (the normal case)
- product-name scan: no hit — nothing in the target names the product
- isolation: passed `check-isolation.ps1` (ancestry, both sideways levels, no scoring bundle)

### build-dist.ps1 — 2026-08-03 22:54:14
- mirror: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r17\dist` — 18 file(s)
- excluded: process/*, .claude/*, CLAUDE.md, README.md, THESIS.md
- stacks listed in §2: dom-css · sheets listed in §5: green-fuzz-classic, green-fuzz-strolling
- variant: `061-s3-b`
- variant edits: MONSTER-DEV.md: insert after 'say so plainly and stop.'
- -Without: (none)
- checks: four exclusions verified, indexes agree, harness vocabulary clean, no sprite reference, no frontmatter, no wikilinks

### hire.ps1 — 2026-08-03 22:58:30
- model: `sonnet` · fixture: `python-cli`
- mirror handed over as: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r17\dist`
- entry point in the brief: `C:\Users\TjarkOnnen\source\repos\priv\monster-dev-testruns\2026-08-03-r17\dist\START.md`
- #042 — decodable references to this repository in turn 1's prompt and mirror path: none found
