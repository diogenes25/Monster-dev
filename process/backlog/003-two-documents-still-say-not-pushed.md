# `#003` — Two dev-side documents still say the repo is not pushed, and one of them tells every report to lie

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | stale documentation |
| Criterion | — |
| Target file | `CLAUDE.md`, `SKILL.md` (two places), `references/report-template.md` |
| Evidence | `2026-08-01-live`, `2026-08-01-plan-sonnet` |
| Proof design | — |

**What happened.** `CLAUDE.md` still reads *"not yet pushed as of this writing — repo is
git-initialized locally with branch `main`"*, and the workshop skill still carries a section
headed *"Currently open, deferred to the first push"* which requires §0 and §5 to be listed as
*deferred* — *"never as passed"* — **in every report**. Meanwhile `origin` is
`https://github.com/diogenes25/Monster-dev.git`, `refs/heads/main` exists, and `2026-08-01-live`
proved both over real `raw.githubusercontent.com` URLs: §0 by reaching the playbook with no owner
or repo named anywhere in it, §5 by a byte-identical 1.9 MB PNG, which is the one criterion
self-report cannot fake.

**Why the current wording allows it.** It is not merely out of date, it is an active instruction:
a report that follows the skill records two proven criteria as deferred. It also hides a real
choice that now exists — a run can use the `<dist>` mirror **or** real URLs, and which one it
uses is a comparability decision worth stating rather than a limitation to apologise for.

**Proposed change.** Replace the skill's *"Currently open, deferred to the first push"* section
with:

> ## The fetch path is now a choice, not a limitation
>
> §0 (base-URL derivation) and §5 (WebFetch for text, shell download for the binary) are
> **proven** by `2026-08-01-live` over real `raw.githubusercontent.com` URLs. Neither is deferred
> any more, and a report that lists them as deferred is wrong.
>
> The mirror stays the default for A/B work, because it holds the fetch path constant and every
> earlier arm used it. A real-URL run is how §0 and the §5 download wording get re-tested after
> either is edited — and it is the only arm in which a 404 or a WebFetched binary can show up at
> all.

and in `CLAUDE.md`, replace *"(not yet pushed as of this writing — repo is git-initialized
locally with branch `main`)"* with *"(pushed; `main` is the published branch)"*.

Two more places carry the same stale premise and were found while wiring the board in:

- **Half B's preamble**, above the procedure: *"Until this repo is pushed, a run therefore hands
  the agent a **filesystem path** to `START.md`, and two things stay untested."* The `localhost`
  /WebFetch limitation it opens with is still true and stays; what has to go is the conclusion
  that a path is the only option. Rewrite it as: the mirror is handed over as a path **because
  it holds the fetch path constant across arms**, and a real-URL run is now the alternative,
  not a future one.
- **`references/report-template.md`**, the `## Deferred` section: *"Standing entry until the repo
  is pushed: §0 base-URL derivation, §5 WebFetch/curl split."* A standing entry that instructs
  every future report to record two proven criteria as deferred. It becomes *"anything this
  scenario could not reach"* and nothing more.

**Proof design.** *`Gate: none`.* Nothing to measure — the claim is settled by `git ls-remote` and
by a run already on record.

**Cost.** None. Both files are dev-side and never reach a hire.

**Log.**

- `2026-08-01` `intake` — noticed while scoring `2026-08-01-live`, which proved both criteria.
- `2026-08-01` `formulated` — written up as F3 of `2026-08-01-plan-sonnet`, not applied in that
  pass on purpose: that run's business was §4, and a documentation edit reviews better alone.
- `2026-08-01` — two further sites found while wiring the board into Half B and the report
  template. Still not applied, for the same reason: the board's own edit is the change under
  review in that pass.
