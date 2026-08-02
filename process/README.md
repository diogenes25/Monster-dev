# The process side

Monster-Dev is a prompt, not code. The only way to know whether an edit worked is to hire a
fresh agent and watch what it does — which makes this folder the closest thing the project has
to a test suite, and the reason it used to be called `test/`.

It holds two things now, and they are not the same kind of thing:

- **The measurement.** Fixtures, scenarios, the harness, the runs, the board. Everything with an
  acceptance criterion behind it, governed by the proof gates in `CLAUDE.md`.
- **The record** — `stacks/`. One folder per implementation actually carried out, kept as
  fixture → requirement → process → result. Created once, never re-run, never scored. Its purpose
  is documentation and raw material; see [`stacks/README.md`](stacks/README.md).

Nothing crosses from the second into anything a hire reads without passing through the first.

Everything here is **published but never fetched**. It ships with the repo so anyone can
reproduce a run, and it is excluded from the `<dist>` mirror a hire receives, because an agent
that has read the acceptance criteria passes them without reading the playbook.

This file is the **rationale**: why the harness is shaped the way it is. The **procedure** —
the exact sequence for building a mirror, creating a run folder, hiring, scoring, and the
report templates — lives in the `monster-dev-workshop` skill
(`.claude/skills/monster-dev-workshop/`). Keep it that way rather than duplicating steps here;
when the two disagree, the skill is what actually gets executed.

## Layout

```
process/
  fixtures/<name>/          target-project templates; a run never modifies one
  scenarios/<name>.md       customer brief + answer script + acceptance criteria
  runs/<run-id>.report.md   criterion-by-criterion result, with evidence
  backlog/<nnn>-<slug>.md   one file per open problem, carried across runs
  tools/                    the harness itself — see below
  stacks/<lang>/<lib>/      the implementation record — see stacks/README.md

../monster-dev-testruns/<run-id>/        the project the hire actually works in
../monster-dev-testruns/<run-id>.dist/   what the hire is allowed to see
```

`stacks/` here and `stacks/` at the repository root are different trees answering different
questions. This one is keyed by language → library and is never fetched; the root one is keyed by
rendering surface + animation primitive and is the only stack index a hire can see. The `Stack:`
line at the top of each `impl-NN/knowledge.md` maps one to the other.

Run folders live **outside this repository**, and reports live beside them rather than inside
them — a report inside the target project would itself violate the §9 cleanup rule it checks.

## Fixtures, and the stack each one exercises

| Fixture | Represents | Exercises | Stack |
|---|---|---|---|
| `fixtures/static-site/` | Plain HTML/CSS/JS, no framework, no existing animation | The baseline: DOM surface, no animation convention to conform to, pick injection point and asset location from scratch | `dom-css` |
| `fixtures/gsap-site/` | A site already animating with GSAP | Style conformance (§2.4): build the walk cycle with GSAP, matching `animations.js`, instead of introducing raw CSS keyframes | *(not yet created)* |
| `fixtures/python-cli/` | A pure Python CLI/report tool, no UI framework | The decline path (§3): no visible surface, so say so and stop instead of improvising | *(none — §3 covers it)* |

A stack has no notes file until a run has produced something worth writing down. That is the
point: a `stacks/` entry is a record of what was measured, not a collection of advice.

## The harness — `process/tools/`

- `build-dist.ps1` — builds the mirror **and** verifies it, deleting it rather than returning
  one that leaked. Also builds A/B arms via `-Without`.
- `new-run.ps1` — creates the run folder from a fixture, runs its setup recipe if it has one,
  commits once, and deletes the folder rather than return one that fails isolation or starts
  dirty. Recipes live in `tools/setup/<fixture>.ps1` and are never copied into the target, where
  they would land in the §9 diff surface.
- `check-isolation.ps1` — walks the run folder's ancestry for `CLAUDE.md` and confirms the
  folder is a git repo with exactly one commit. `-AncestryOnly` drops the commit half, for a
  folder that must be free of this repo's context but is not a run folder.
- `score-bundle.ps1` — assembles the blind evidence bundle a run is scored against a second time:
  the criteria minus their run-log table, the transcript, the envelope, the measurements, the git
  surface and the worktree. Not the brief, not an earlier report, not `CLAUDE.md`. Deletes the
  bundle rather than return one where the cut failed.
- `verify-run.mjs` — drives headless Chrome over CDP to measure what the implementation
  actually does.

**`verify-run.mjs` is exactly why the harness lives here and not in `tools/`.** It encodes the
acceptance criteria. Published under `tools/`, it would put "what is being measured" straight
into the mirror. `process/` is excluded already, so it is the only correct home — and nothing that
knows the criteria may move out of it.

## Three constraints, all learned the hard way

**1. A subagent cannot be isolated from `CLAUDE.md`.** An in-process subagent inherits the
session's working directory, so this repo's `CLAUDE.md` lands in its context — and that file
summarises the playbook: the technique by name, the sprite dimensions, the WebFetch/curl split,
the §8 rule. An agent so equipped passes every criterion without reading anything. So a hire is
always a **separate `claude` CLI session** whose working directory is the run folder, and
`check-isolation.ps1` runs before every hire, not just the first.

**2. `WebFetch` cannot reach a local server.** It rejects the hostname `localhost` outright and
force-upgrades `http://127.0.0.1` to HTTPS, so a plain local HTTP server answers a TLS handshake
with `WRONG_VERSION_NUMBER`. Serving this repo locally cannot stand in for
`raw.githubusercontent.com`. Until the repo is pushed, a run hands the agent a **filesystem
path** to `START.md`, and three things stay untested: §0 (base-URL derivation), §5's
WebFetch-for-text / shell-download-for-binary split, and stack resolution. Report them as
*deferred*, never as *passed*.

**3. Exclusion is now deliberate, and it names the folder by hand.** `process/` and `.claude/`
used to drop out of the mirror because git ignored them. They are tracked now, so the filter has
to name them — which is why building and verifying happen in one script rather than as a
documented command someone might paste incompletely.

The rename from `test/` to `process/` on `2026-08-02` is the sharpest form of the same hazard.
`build-dist.ps1` carried the literal `'test'` **twice**: once in the exclusion and once in the
backstop that verifies the exclusion. A rename breaks both at the same moment and in the same
direction — the filter matches nothing, and the check looks for a folder that no longer exists
and reports clean. Two layers, one string, no alarm. Anything that renames this folder again has
to change both lines and then *build a mirror and look inside it*; the script passing is not
evidence.

## Designing the customer

The customer is played from the scenario's answer script, never improvised, so a rerun is
identical. Two principles, both easy to violate:

- **Stay vague where a real customer would be.** Anything the script spells out is something
  the run can no longer measure. State the requirement and you only learn whether the agent
  follows instructions — not whether the playbook surfaces the requirement on its own.
- **Split "didn't ask" from "didn't build".** Score likely gaps twice: did Monster-Dev raise it
  (a §4 signal), and does it work (a §5/§6 signal)? Missing *without* asking is a playbook gap;
  missing *with* asking is an implementation error. A report must never blur the two.

## What a run has to clear

The bar is a **Sonnet**-class hire. Opus solves the known pitfalls unaided, which leaves an A/B
nothing to measure; a Haiku failure is explicitly not a finding.
