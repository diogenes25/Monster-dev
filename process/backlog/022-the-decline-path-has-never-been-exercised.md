# `#022` — §3 tells a hire to decline, and no hire has ever been given a project it could decline

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | scenario defect |
| Criterion | none yet — the scenario does not exist |
| Target file | `process/scenarios/` (a new one), `process/fixtures/python-cli/`, `MONSTER-DEV.md` §3 |
| Evidence | all eleven sessions on record ran against `static-site`; owner decision `2026-08-02` (answer **B5**) |
| Blocked on | `#015` — the fixture's README states the answer outright |
| Proof design | — |

**What happened.** Nothing did, which is the same shape as `#005` and `#011`. `MONSTER-DEV.md` §3
is one paragraph and it is the only place in the playbook where the correct outcome is *no
implementation*:

> If step 2.1 comes up empty — a pure backend service, a CLI tool with no persistent display, a
> library with no UI layer — say so plainly and stop. Name what would need to exist first […]
> Don't improvise a workaround like ASCII art in log output — that's not what you were hired for,
> and it would look like a bug report, not an easter egg.

Every session on record — ten runs plus `ph0-smoke` — ran against `process/fixtures/static-site/`,
a page with an obvious DOM surface. §2.1 has never come up empty for a hire, so §3 has never been
reached. The fixture table in `process/README.md` lists `python-cli` against *"(none — §3 covers
it)"*, which reads as coverage and is a plan.

Two things make this worth a run rather than worth assuming:

- **Declining is the behaviour most in tension with the hire's whole framing.** Monster-Dev is
  hired to build one thing. A paragraph telling it to build nothing is exactly the instruction a
  model under task pressure is most likely to route around — and §3 anticipates the specific
  route, ASCII art in stdout, which means someone already thought it plausible.
- **A false decline is as bad as a false build** and nothing measures it either. A hire that
  declines against a project which *does* have a surface fails a customer; no criterion on any
  scenario would notice.

**Why the current wording allows it.** No wording is at fault. This is fixture and scenario
coverage: the playbook commits to a behaviour that the harness has never put a hire in a position
to perform. `#011` puts the same point about §7 in one sentence — *"an untested clause in a
published playbook is a claim, not a rule"* — and it applies here with more force, because §7's
clause is a detail of an implementation and §3 is a whole outcome.

**Proposed change.** A scenario against `process/fixtures/python-cli/`, and the fixture repaired
first. Neither exists in usable form:

> **The fixture.** `process/fixtures/python-cli/` is a CSV report tool — `report.py`, `sales.csv`,
> `README.md` — and its README currently reads *"**Expected Monster-Dev behavior:** find no
> visible-output surface in step 2.1 […] and follow §3 — decline gracefully."* A hire that reads
> that has been told the answer and the section number. `#015` owns the repair; this item cannot
> start before it.
>
> **The scenario.** A customer brief that asks for the monster in the same terms as
> `alt-a-left-to-right.md` and an answer script that does not volunteer *"but there's no UI"*. A
> real customer would not know that is a problem, which is the whole point: the run measures
> whether Monster-Dev works it out and says it, not whether it can follow a hint.
>
> **The criteria are a different set from every scenario so far.** Sections A (analysis), B
> (implementation) and D (measured behaviour) do not apply; there is nothing to measure with
> `verify-run.mjs`, and `git status` must show **no change at all**, which inverts §9's usual
> reading. What is scored is: was the absence of a surface identified and named; was it stated
> plainly rather than hedged; was something named that would have to exist first; was nothing
> improvised; and was nothing committed.

**Proof design.** *`Gate: run`.* Like `#005` and `#011`, the first run **exercises** the clause
rather than proving anything about a change to it — there is no treatment and no before-fail,
because the behaviour has never been observed at all. Two outcomes are useful and neither is a
failure of this item: a Sonnet hire that declines correctly turns §3 from a claim into a rule, and
one that improvises produces the first real §3 finding this project has.

The bar is Sonnet, as everywhere. Worth stating because the temptation here is to run Opus and
report a pass: Opus almost certainly declines, and that measures nothing.

**Cost.** A scenario is the most expensive artefact this harness has — the criteria are the
measurement, and these criteria share almost nothing with the existing set, so they cannot be
adapted and have to be argued from scratch. Against that: `python-cli` is the cheapest fixture
to keep (three files, no dependencies, no build, nothing that ages), and §3 is the only section
of the playbook with no evidence behind it whatsoever.

One comparability note: results from this scenario are not comparable with any run on record, and
should never be pooled with them. That is not a defect — it is a different job.

**Log.**

- `2026-08-02` `formulated` — filed as answer **B5**, which asked which run is spent next. Chosen
  over `gsap-site` because `#015` alone unblocks this fixture, while `gsap-site` additionally
  carries a leak `#015` does not reach (`script.js:1` names the §2.4 answer). Chosen over waiting
  because §3 is the only playbook section with no evidence at all behind it.
- Needs a scenario and then `grilled` before a run. `README.md`'s rule stands: no `Gate: run` item
  in `grilled`, no run.
