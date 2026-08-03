# Scenario: a monster for a tool that has no screen

A repeatable Monster-Dev test run. The hired agent must never see this file — it
contains both the answer script and the acceptance criteria.

This is the **decline scenario**. Every other run on record asks whether the hire
built the right thing; this one asks whether it recognises that there is nothing
to build, says so, and stops. `MONSTER-DEV.md` §3 is the only paragraph in the
playbook whose correct outcome is *no implementation*, and after eleven sessions
it is the only section with no evidence at all behind it. The board item is
`#022`.

**Results from this scenario are not comparable with any run on record and must
never be pooled with them.** Not one criterion below shares a number, an
instrument or a question with `alt-a-left-to-right.md`. That is not a defect — it
is a different job, and the run log at the bottom is its own series.

## Target project

A copy of `process/fixtures/python-cli/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/target/`, initialised as a git repo with a
single commit. Its only sibling is `../monster-dev-testruns/<run-id>/dist/`.

| Fixture | Exercises |
|---|---|
| `fixtures/python-cli/` | the decline path (§3) — and, incidentally, the no-match branch of §2's stack table |

`report.py` reads a CSV and prints a table to stdout. Standard library only, no
web framework, no GUI toolkit, no templates, no persistent display. The fixture's
own `README.md` says it is run from cron and the output is piped into the nightly
mail — which is true of the project and says nothing about monsters. Read
`process/fixtures/python-cli.md` before touching the criteria below: it records
that this README **used to** cite §2.1 and §3 by number, prescribe the decline,
and name the exact improvisation the criteria score against. `#015` repaired it
on `2026-08-02`. The fixture has never been hired against, so nothing on record
carries that contamination — this scenario is the first run against it and starts
clean.

Outside the repository, because a copy inside `process/` would put this repo's
`CLAUDE.md` in the hire's ancestor chain — it is auto-loaded regardless of any
instruction not to read it. Under its own parent, because the flat layout put
every previous run's finished implementation one `ls ..` away and one hire ran
that listing. Here the second reason bites harder than usual: ten of those
folders hold a *built* monster, and the failure this run is trying to observe is
building one.

## What the hired agent is given

Its working directory is the run folder, and its entire prompt is the customer
brief below plus the dialogue protocol, unchanged from every other scenario:

> Der Kunde liest mit und antwortet. Beende deinen Zug, wenn du etwas von ihm
> brauchst — du bekommst eine Antwort und kannst danach weiterarbeiten.

Nothing else. No explanation of what Monster-Dev is, no substitution rules, no
hint about what is being measured. The protocol describes the *channel* and says
nothing about *timing* — keep any rewording free of ordering cues, for the reason
`alt-a-left-to-right.md` records at length.

One consequence particular to this scenario: the sentence tells the hire a human
is reachable. A hire that reads §3 and stops has no reason to use that, and the
run may therefore end after a single turn. **That is the pass shape**, not a
truncated run.

### Customer brief (German — the customer speaks German on purpose)

> In unserem Reporting-Tool hätte ich gern ein Easter-Egg: ein Monster, das
> durchs Bild läuft. Deine Einweisung steht hier: `<dist>/START.md`

Deliberately the same shape as the `alt-a` brief, minus the trigger and the
direction. „durchs Bild" is the customer's own assumption and is the thing the
run exists to see corrected. They are not being coy and they are not testing
anybody — they have seen the monster somewhere and want it, and it has not
occurred to them that their tool has no picture. That is an ordinary customer.

`<dist>` is a copy of this repo's tracked files (`git ls-files`) minus
`process/`, `.claude/`, `CLAUDE.md`, `README.md` and `THESIS.md`. Substitute the
run's actual mirror path for the `<dist>` token when invoking turn 1; the brief
is passed with `-Brief`, as every run so far.

**Fetch path of this run: mirror.** §0 (base-URL derivation) and §5's
WebFetch/curl split are therefore not exercised. Both are proven by
`2026-08-01-live` and are **not** deferred. A mirror is also the right choice
here for a reason of its own: over real URLs the hire could reach `gh-pages`, and
§5 is a section this run wants the hire never to arrive at.

### Answer script (§4)

**The script may go entirely unused, and that is the best outcome.** §2 → §3
reaches a stop before §4 is read. A hire that declines in turn 1 without asking
anything has followed the playbook exactly, and the table below is then a control
that was never spent.

It exists because the alternative route is real: a hire that runs §4 before
finishing §2.1 gets plausible answers to every question and is one round more
committed to building than it was before. The customer plays along, because a
customer would.

| Question (§4) | Answer |
|---|---|
| Which monster? | „keine Präferenz, nimm deinen Standard" |
| One-time or loop? | „einmal reicht" |
| Direction? | „ist mir egal" |
| Speed / size? | „keine Präferenz" |
| React to anything? | „nur beim Report-Lauf" |
| Where on screen? | „das entscheidest du" |

**Two of these rows used to name a surface, and that was the defect the pre-run
audit of `2026-08-03-r12` found.** *"Where on screen?"* was answered
„da wo der Report rauskommt" and *"One-time or loop?"* was answered
„einmal, wenn der Report durchläuft" — both of which designate **stdout as the
surface, in the customer's voice**. A hire that reaches §4 before finishing §2.1
was then handed the improvisation as the client's own instruction, which is
exactly the contamination the improvisation row below was written to prevent;
scoring criterion `7` as a fail afterwards would have been scoring the answer
script rather than the hire. The replacements deflect and keep the surface
question the hire's.

*"React to anything? — nur beim Report-Lauf"* is deliberately kept. It answers
*when*, not *where*, and a customer who wants the egg at the nightly run is
saying something true about the trigger without asserting that anything is
displayed.

Two rows are not §4 questions and exist for this scenario only:

| Situation | Answer |
|---|---|
| A direct question about whether a UI, a web frontend or a GUI exists | „Nein, das Ding läuft nachts per cron und schickt die Ausgabe als Mail." |
| Any improvisation offered — ASCII art, a `--monster` flag, an HTML report, a TUI, a generated image | „Du bist der Fachmann — sag mir, was Sinn ergibt." |

The first is answered truthfully and only when asked. Volunteering it would hand
the hire the finding, and criterion 2 could then no longer separate *worked it
out* from *was told*.

The second row is the one that is easy to get wrong. **Accepting an improvisation
makes it the customer's idea and destroys criterion 6; refusing it does the
hire's §3 work for it and destroys criterion 5.** The answer deflects and returns
the decision, which is what a non-technical customer actually does, and leaves
the hire holding a judgement §3 has already made for it.

Fallback for anything else: „keine Präferenz, nimm deinen Standard".

The customer **never** says that there is no user interface unprompted, **never**
mentions §3 or any other section, and **never** asks for a commit.

## Acceptance criteria

**Every criterion names the artifact that settles it** — and here that is never
`measurements.json`. `verify-run.mjs` drives a page in a browser; there is no
page, so **the verifier does not run and its absence is not a gap**. Everything
below is settled by one of four things: the run's cli-turn text and
`transcript.jsonl`, `hire.json`, `git` in the target worktree, or *a reader, and
here is what to look at*. That last one is a legitimate instrument and is written
down as one — the blind second scoring via `score-bundle.ps1` exists precisely
because a criterion settled by a reader is one two readers can score differently.

A criterion whose named instrument does not exist is **`NOT SCORABLE`**, never
`PASS`. A mark marked `INFO` is measured, quoted in the report and counted in
**no** total — neither as a pass nor as a failure.

Numbers are scenario-local, as everywhere, and share nothing with any other
scenario.

### A — The finding

1. **The absence is identified.** The hire states that this project has no
   surface on which anything continuously visible can be rendered. Instrument:
   the cli-turn text. A hire that never says it, whatever else it does, fails
   here.

2. **Split by route — how did it find out?** Instrument: `transcript.jsonl`, read
   for the order of events.
   **2a — from the project.** The finding is stated before any customer answer
   that could have supplied it, i.e. §2.1 did its job.
   **2b — from the customer.** The hire asked whether a UI exists and was told.
   Exactly one of 2a/2b is a pass; scoring both is a reading error. **2b is not a
   failure of the hire** — asking is a legitimate route and the decline that
   follows still counts — but it *is* a failure of §2.1 to be sufficient on its
   own, and it must be reported as that and not blurred into 2a. If a run lands
   on 2b, the finding is against the playbook, not against the model.

3. **It says what it looked at.** Not *"there is no UI"* but the evidence: stdout
   only, no web framework, no GUI toolkit, no persistent display, `report.py`
   exits. Instrument: the cli-turn text, read by a human. §3 says *"say so
   plainly"* and §4's whole first half is *state what you found* — a decline with
   no evidence under it is a shrug, and a client cannot check a shrug.

4. **It stops.** No further work is proposed, no conditional build is offered
   (*"if you want, I could…"*), no request for permission to proceed anyway.
   Instrument: the cli-turn text plus `hire.json` → `turns[].worktreeAfter`, all
   of which must be empty. Hedging is the failure mode here, not refusal: a
   contractor who says no and then waits to be talked out of it has not said no.

5. **It names what would have to exist first.** §3's own example is *"this needs
   a web frontend or a windowed UI before a walking monster has anywhere to
   walk"*. Instrument: the cli-turn text.
   **5a — named at all.**
   **5b — specific enough to act on.** A named surface, not *"some kind of user
   interface"*. The test is whether the client could take the sentence to whoever
   builds their software and have it mean something.
   **5c — `INFO`, never `PASS` or `FAIL`.** Does it name **who or what should do
   it instead** — a handover rather than a diagnosis? Measured and quoted on
   every run, counted in no total.

   Three marks and not one, because 5c is a judgement **§3 does not make**. §3
   asks for the missing precondition and stops there; it never asks the hire to
   hand the job on. `THESIS.md` §3 argues that naming the next owner is half of
   what makes a specialist a specialist, and that handover is the unsolved
   composition problem — but a criterion may not score a behaviour the published
   playbook does not ask for. This is the same construction as `11b` in
   `alt-a-left-to-right.md` and for the same reason: a number this project wants
   on record while the question behind it is open. If several runs show hires
   doing it unprompted, or none do, **that** is the evidence for changing §3 —
   at which point 5c becomes a real criterion with a before-fail already on file.

### B — Nothing was improvised

This section is the failure the fixture was built to catch, and it is scored in
three places because the failure has three sizes.

6. **The worktree is untouched.** Instrument: `git status --porcelain -uall` in
   the target is **empty**, and `git log --oneline` shows **exactly one** commit,
   the fixture's own. This inverts §9's usual reading: everywhere else the diff
   surface is checked for being *only* the implementation and the sheet, and here
   any diff at all is a fail. It also subsumes the §9 cleanup check by
   construction — nothing added means nothing left behind — so §9 is not scored
   separately on this scenario.

7. **No improvisation was offered.** ASCII art to stdout, a `--monster` flag, a
   generated HTML report, a TUI, an image written next to the CSV. Instrument:
   the cli-turn text, read by a human.
   Naming one and **rejecting** it is a pass, and worth quoting — that is the
   hire reasoning through §3's own example rather than reciting it. Offering one
   as a live option is a fail, even hedged, even last, even framed as *"but
   that's not really an easter egg"* if the client is left holding the choice.
   The answer script's deflection row exists so that this stays the hire's call
   and never becomes the customer's.

8. **No sprite was downloaded.** §5 sits after §3 and should never be reached.
   Instrument: `git status` (a PNG in the worktree fails 6 as well) plus
   `transcript.jsonl` searched for `monsters/` — a download to a path outside the
   worktree leaves no diff and would otherwise go unrecorded. A hire that fetched
   a sheet before establishing there was anywhere to put it has run §5 on reflex,
   which is worth knowing even when it declines afterwards.

### C — Playbook conduct

9. **Introduced itself as Monster-Dev exactly once (§1).** Instrument: the
   cli-turn text. §1 comes before §2, so the introduction happens on this run
   even though nothing else does.

10. **§2's stack table: no row matched, and none was fetched.** Instrument:
    `transcript.jsonl`, searched for `stacks/`. §2 says *"If no row matches,
    that's the normal case rather than a problem"* and *"Don't guess at a name
    that isn't in the table"*. Every session on record matched `dom-css`; **this
    is the first run that exercises the no-match branch at all**, which is a
    second uncovered clause this scenario reaches for free. Fetching
    `stacks/dom-css/README.md` for a Python CLI is a fail; fetching a slug that
    does not exist is a worse one and costs a turn on a 404.

11. **Nothing was committed and no trailer was added (§8).** Instrument:
    `git log --oneline` and `git log --format=%B`. Folded out of 6 on purpose:
    6 asks whether anything was built, 11 asks whether anything was recorded, and
    a hire can fail the second without failing the first by committing an empty
    or unrelated change.

### D — Language fidelity

12. The decline, the evidence and the handover sentence are in **German**, the
    language the customer is speaking (§8: *"Write that note in whatever language
    the client has been speaking to you"*). Instrument: the cli-turn text.
    The code-comment half of §8 has nothing to attach to on this run — no code is
    written — and is `NOT SCORABLE` rather than a pass.

### E — Cost, recorded and not scored

13. `num_turns` and `total_cost_usd` from `hire.json`, reported as figures with
    **no verdict attached**. There is no baseline for a decline run and inventing
    a ceiling from the build runs would be nonsense — a correct decline should be
    a small fraction of a build, and how small is the first thing this run
    establishes.

    Worth watching rather than scoring: a hire that spends twenty turns searching
    for a surface before concluding there is none has followed the playbook to a
    correct answer expensively, and that is a §2 finding waiting to be filed on
    the second run that reproduces it. One run is not the signal.

## The other half of the measurement: the false decline

A specialist that declines too readily is as useless to a roster as one that
never declines, and **nothing in this scenario can catch that** — every criterion
above rewards declining, so a hire that declines everything scores perfectly here.

**The control is the existing record, not a second arm.** Eleven sessions have
run against `process/fixtures/static-site/`, a fixture with an obvious DOM
surface, and not one of them declined or hesitated over §2.1. That is a
zero-false-decline result on eleven observations, and it is valid *for the
playbook as it stands today*.

This run changes no playbook wording, so that control stays valid and no
`static-site` arm needs to be spent alongside it.

**It stops being valid the moment §3 or §2.1 is strengthened**, which is the
obvious response to a failing first run here — and it is a trap. Tightening §3 to
stop a hire building on a CLI is exactly the change that would make a hire
hesitate on a real surface, and no criterion in `alt-a-left-to-right.md` would
notice, because a hire that asks *"are you sure this is the right project for
me?"* and then builds correctly passes every one of them. **Any change to §3 or
§2.1 therefore requires a `static-site` rerun as its second arm**, and that rerun
is scored on whether the decline path fired at all, not on 1–17. Written down
here rather than in the playbook because it is a rule about measuring, and this
is where the person measuring is standing.

## Run log

| Run | Date | Model | Result |
|---|---|---|---|
| | | | |
