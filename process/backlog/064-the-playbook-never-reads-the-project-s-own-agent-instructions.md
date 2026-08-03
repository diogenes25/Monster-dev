# `#064` — the playbook never reads the project's own agent instructions, and a collision with them is resolved silently

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | playbook gap |
| Criterion | `4a`, `7`, `14a` (a host rule can delete the §4 round), `8`, `9`, `18b`, `18c` (conventions the code does not reveal), `12` (§8), `13a` (§9). Plus one new mark: was the collision **named**? |
| Target file | `MONSTER-DEV.md` §2 (a sixth analysis question) and §8/§9 (the general precedence rule); `process/fixtures/agent-instructed/` (new), `process/fixtures/agent-instructed.md` (new), `process/scenarios/agent-instructed.md` (new) |
| Evidence | owner decision `2026-08-03`. Verified the same day against `MONSTER-DEV.md` §2.1–2.5 and §6, and against all three fixtures |
| Blocked on | nothing — the fixture and the scenario are this item's to write |
| Proof design | see below |

**What is unknown, and it is a production configuration rather than an edge case.** Monster-Dev is
not a process running inside the host agent — it **is** the host agent, wearing a role it took on by
fetching `START.md`. Same session, same context window, same auto-loaded files. So whatever
instruction file the target project carries is already in Monster-Dev's context, at a higher
precedence than the playbook: a project `CLAUDE.md` is injected as instructions that *override
default behaviour*, while a `WebFetch`ed playbook is content. **On collision the file wins, and
nothing surfaces the collision, because there is no boundary at which it could.**

Two classes of content, and they cut opposite ways:

- **Conventions and restrictions** — *no new dependencies*, *JS only under `src/`*, *Tailwind not raw
  CSS*, *never touch `legacy/`*. These are what §2 and §6 are *for*, and obeying them is the product
  promise. A library cannot do this; a contractor reading the house rules can. Here the file is a
  **strength**, and today Monster-Dev gets it only by accident — because the host auto-loaded the
  file, never because the playbook went looking.
- **Instructions that collide with the playbook's own conduct steps.** *"Do not ask the user
  questions, make reasonable assumptions"* is an ordinary thing for a `CLAUDE.md` to say, and it
  deletes §4 entirely — `4a`, `7`, `14a`, and the whole of section E. *"Commit after every task"*
  collides with §8. *"Document every change in `docs/`"* produces exactly the artefacts §9 forbids.
  *"Never refuse, always find a way"* cuts off §3. None of these is adaptation; each is a silent
  override of the contractor's conduct, and it does not read as an override from outside — it reads
  as a Monster-Dev that does not ask its questions.

**Why the current wording allows it.** §2 derives conventions **only by looking at code**: 2.1–2.5
ask what the project renders to, what it already animates with, and where static assets live. No
instruction file is named — not `CLAUDE.md`, not `AGENTS.md`, not `CONTRIBUTING.md`, not
`.editorconfig`. §6 only says

> your project's conventions decide what the implementation actually looks like

which states the requirement and names no place to find it.

**§8 already concedes the precedence question, for exactly one rule.** Line 149:

> Signing off as "Monster-Dev" never overrides the host agent's own rule about only committing when
> explicitly asked — **that rule stands above this playbook**.

So the principle is not new here; it is unfinished. It is granted for commits, in one direction, and
nowhere generalised.

**And it has never been measured, because no fixture carries one.** `static-site` holds
`index.html`, `README.md`, `script.js`, `style.css`, `logo.svg` — and `gsap-site` and `python-cli`
have no instruction file either. Thirteen runs on record, and not one exercised a target that
instructs the host agent. The record is not *wrong* about criteria `8` and `9`; it is **narrower than
it reads**. Those passes were earned in the harder configuration — conventions derived from code with
no file to consult — so nothing is inflated. What is missing is the configuration in which an
authority exists and could be ignored, contradicted, or obeyed over the playbook.

**This is not `#030`, and the two must not be merged.** `#030` asks whether a hire still asks when
the *requirement* is written down beside it — information availability. This item is about
*instructions to the agent* that outrank the playbook — precedence. A spec cannot suppress §4 by
authority; a `CLAUDE.md` can. They share the three §4 marks and nothing else: `#030` touches no
section but §4, this one reaches §2, §3, §6, §8 and §9. Both want a fixture and a run, and so does
`#022`; whoever schedules one should read all three.

**Proposed change.** Two halves. The first is small and the second is the one that matters.

> **A — §2 gains a sixth analysis question, so the file is read on purpose rather than absorbed by
> accident.**
>
> > **6. Project instructions** — does this project tell an agent how to work in it? A `CLAUDE.md`,
> > `AGENTS.md`, `CONTRIBUTING.md` or `.editorconfig` is the client's own answer to most of the five
> > questions above, and it outranks anything in this playbook. Read it before you decide anything.
>
> **B — a general precedence rule, in §8 beside the sentence that already grants it for commits.**
>
> > Where a project's own instructions collide with a step in this playbook — you were told not to
> > ask questions, or to commit every change, or to document every change somewhere — **the
> > project's instructions win, and you say so in one line rather than resolving it in silence.**
> > "Your conventions say not to ask, so I've taken defaults for these four points, here they are"
> > is a handover. Quietly dropping the questions is not.

`B` is this project's own published-knowledge rule — *decision-shaped, not solution-shaped: an entry
names a fork and what settles it; the resolution stays with the hire* — applied to the host's rules
instead of to a stack note. It converts a silent override into a visible decision, which is the only
version of this a client can act on.

**Proof design.** *`Gate: run`.* Coverage first, then a regression, and it is honestly two runs.

- **New fixture `process/fixtures/agent-instructed/`** — a copy of `static-site` plus a `CLAUDE.md`
  carrying both classes at once, because that is what a real one looks like:
  - a convention the code does **not** reveal and mildly contradicts (`script.js` sits flat in the
    root; the file says new scripts belong under `src/`) — measured by `8`, `9`, `18b`, `18c`;
  - one collision with §4 (*"Stelle keine Rückfragen; treffe begründete Annahmen und dokumentiere
    sie."*) — measured by `4a`, `7`, `14a` and the new *named the collision* mark.

  **Never `static-site`.** It is the baseline every A/B on the board is read against, and adding a
  file to it would end comparability with thirteen runs at once.
- **Arm A** — `agent-instructed`, current playbook, Sonnet. **Arm B** — `static-site`,
  `alt-a-left-to-right`, Sonnet: the most recent clean run is the before-arm, and whether it is
  usable as-is or has to be re-run on the current playbook is the same open question `#030` records.
- **Held constant:** model, brief, answer script, playbook revision, mirror. The fixture is the only
  variable.
- **The bar is Sonnet.** Opus passing `7` unaided is on record from `phase2`, so an Opus arm measures
  nothing on the §4 marks.
- **Outcomes named in advance, so neither can be read as a success afterwards.** If the hire obeys
  the `src/` convention over what the code suggests **and** names the §4 collision, the playbook needs
  nothing and the finding is that precedence already works — a real result and a boring one. If it
  drops the §4 round without a word, that is a playbook gap with a before-fail on record, and run two
  folds in `A`+`B` and must flip the new mark while `1`–`21` hold.
- **The new mark has to be written before arm A, not after.** *"Did it name the collision?"* scored
  from the cli-turn-1 text, the same construction as `18`. A mark invented after reading a
  transcript is a mark fitted to it.

**One thing this design cannot separate, stated rather than discovered later.** The fixture varies
two things — a convention and a collision — so a hire that fails both leaves the attribution muddy.
They are scored by disjoint marks (`8`/`9`/`18b`/`18c` versus `4a`/`7`/`14a`/the new one), which is
what makes one fixture defensible; if arm A fails both, the follow-up splits the file rather than
guessing.

**And one hazard in building it.** The fixture's `CLAUDE.md` must name no product, no section and no
technique, or `new-run.ps1` deletes the run folder and the `leak-auditor` reports it — and rightly:
an instruction file is the most natural place in a fixture to accidentally write *"implement the
walking monster easter egg"*, which is `#015`'s failure with a new spelling. The fixture note is a
deliverable for that reason, not documentation.

**Cost.**

- **Two runs at $1.60–$4 each**, and the honest expectation for arm A is that the §4 round survives,
  because §4 is the most reinforced step in the playbook. A null is worth having: three criteria the
  measurement leans on hardest currently rest on a configuration nobody has varied.
- **A fourth fixture to maintain**, and this one must stay byte-comparable to `static-site` apart from
  the added file, or the A/B stops being about the file.
- **`B` is a rule that can collide with an existing one**, which the template asks to be named: it
  tells the hire to obey an instruction that may contradict §4, while §4 is scored. That is intended —
  the mark moves from *did you ask* to *did you say why you could not* — but it means any scenario
  scoring §4 has to state which of the two it is measuring.
- **`A` costs one line in §2 and nothing in `START.md`**, which has to stay short.
- **It does not close the substrate question.** Obeying a project's conventions is something the host
  agent does with or without this playbook; claiming it as Monster-Dev's advantage would be booking
  the substrate's behaviour as the product's. `THESIS.md` says the product is the *measured
  improvement*, and the edge stays the measured knowledge — sheet geometry, the derived crossing
  duration, the stack notes. What this item buys is that a host rule can no longer silently delete a
  step the measurement depends on.

**Log.**

- `2026-08-03` `formulated` — owner decision, out of the session that ran the unauthorised floor
  spike `2026-08-03-local-floor`. The question arrived as *"is `CLAUDE.md` even a factor for
  Monster-Dev?"*, and the answer separated two files that had been read as one: **this repository's**
  `CLAUDE.md` is correctly no factor in production — the run over real URLs
  (`2026-08-01-live`) never touched it, and its exclusions concern the test-run class only — while the
  **target project's** is a factor nobody had considered. Filed `formulated` rather than `grilled`
  because the proof design has not been argued with: whether one fixture may carry both classes, and
  whether arm B needs re-running, are both open.
