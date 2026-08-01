# Findings from run `2026-08-01-plan-sonnet` — proposed, not applied

The §4/§6 change this run was built to test is already in the working tree — it *is* the
treatment, not a finding. What follows is everything the run turned up **besides** its own
result. Nothing here has been applied to the playbook.

Two harness fixes were applied immediately during the run rather than proposed, per Half C
("fix the harness, rerun, record nothing against the product"): the verifier's viewport check
and one port per arm. Both are written up in the report's harness notes.

## F1 — Criterion 15c scores the wrong thing, for the third run running

| | |
|---|---|
| Criterion | `15c` |
| Attribution | scenario defect |
| Target file | `test/scenarios/alt-a-left-to-right.md` |
| Confidence | reproduced across 4 runs (`alt-a`, `sonnet-base2`, `plan-sonnet`, `plan-opus`) |

**What the agent did.** All three arms wrote English code comments while speaking German
throughout. The fixture's own `script.js` opens `// Smooth-scroll to in-page sections`, so §6
("match the surrounding code's naming, formatting, and structure conventions") makes English
correct. §8 already says this explicitly: *"Code comments are the other way round: those follow
the codebase."*

**Why the criterion allowed it.** The criterion asks *"Code comments in German?"*, which the
playbook deliberately answers **no**. Run `alt-a` withdrew it as mis-specified and it was never
rewritten, so it has now been re-litigated in every run since.

**Proposed change.** Replace criterion 15c with:

> **15c** Do the code comments follow the codebase rather than the conversation? The fixture's
> comments are English, so English is the pass. German comments in an English codebase are a §6
> failure, not a language-fidelity success.

**Cost.** None to the product — this is a scenario file. It does change what 15c means, so runs
before this point compare on 15a/15b only. That boundary is already documented in the scenario's
"criteria changed" note and needs one more line.

## F2 — The turn overrun needs a second sample before it means anything

| | |
|---|---|
| Criterion | cost envelope, not a numbered criterion |
| Attribution | unattributed — one run per arm |
| Target file | none yet |
| Confidence | one run |

**What happened.** Model turns rose 31 → 41 (+32 %) against the before-arm, over the +25 % soft
ceiling. The rise is entirely in the build turn; turn 1 fell from 12 turns / $0.61 to 11 turns /
$0.37.

**Why this is not yet a finding.** Nothing in the §4 change touches the build. The competing
explanation is run-to-run variance, and this harness has already produced a −54 % swing between
`phase2` and `phase2b` on a near-identical product. One sample per arm cannot separate the two.

**Proposed change.** None. Record 41 as the number to beat and read it again on the Phase 3
neutrality rerun, which changes §2 and should leave the build untouched. If that run also lands
near 41, the ceiling was the wrong shape rather than the change being expensive.

**Cost.** Deferring costs nothing; acting now risks reverting a change that flipped three
criteria on the bar model because of one noisy number.

## F3 — Two documents still say the repo is not pushed

| | |
|---|---|
| Criterion | — |
| Attribution | stale documentation |
| Target file | `CLAUDE.md`, `.claude/skills/monster-dev-workshop/SKILL.md` |
| Confidence | verified against `git ls-remote` |

**What is wrong.** `CLAUDE.md` says the target publish location is *"not yet pushed as of this
writing"* and the skill carries a *"Currently open, deferred to the first push"* section
requiring §0 and §5 to be listed as deferred **in every report**. `origin` is
`https://github.com/diogenes25/Monster-dev.git`, `refs/heads/main` exists, and
`2026-08-01-live` already proved both over real raw URLs.

**Why it matters.** The instruction is not merely out of date, it is actively wrong: a report
that follows it records two proven criteria as deferred. It also hides a real choice — a run can
now use the mirror *or* real URLs, and which one it uses is a comparability decision worth
stating rather than a limitation to apologise for.

**Proposed change.** Not applied here on purpose: this run's business is §4, and a documentation
edit made in the same pass muddies nothing but is easier to review on its own. Replace the
skill's *"Currently open"* section with a note that both are proven by `live`, that the mirror
remains the default for A/B work because it holds the fetch path constant, and that a real-URL
run is the way to re-test §0/§5 after any change to `START.md` §0 or the §5 download wording.

**Cost.** None. Both files are dev-side and never reach a hire.
