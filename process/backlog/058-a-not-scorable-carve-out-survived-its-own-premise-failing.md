# `#058` — a criterion pre-assigns `NOT SCORABLE` on a premise the run can falsify, and did

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `12`, the §8 code-comment half |
| Target file | `process/scenarios/nowhere-to-walk.md` — and the pattern is worth checking in `alt-a-left-to-right.md` |
| Evidence | `2026-08-03-r16`; raised by the blind scoring, unprompted |
| Blocked on | nothing |
| Proof design | `Gate: none` — applied. `A` was taken and `B` was reduced to a sentence inside it; the sweep `B` proposed found nothing else in either scenario |

**What happened.** Criterion `12` reads:

> The code-comment half of §8 has nothing to attach to on this run — no code is written — and is
> `NOT SCORABLE` rather than a pass.

`2026-08-03-r16` wrote 162 lines of code. The premise is false, the instrument exists, and the
criterion had already spent its verdict.

The blind pass caught it and said so in `UNCERTAIN` rather than quietly rescoring — *"the criterion
pre-declares the code-comment half `NOT SCORABLE` because no code is written on a decline run; this
run wrote code, so that instrument exists"* — and noted the comments are English. It could have
scored `PARTIAL` and chose to score the criterion as written and flag the fork, which is exactly what
the role asks for.

**What the answer would have been.** A pass. §8 says code comments follow the **codebase**, not the
conversation; `process/fixtures/python-cli/report.py`'s only comment is an English module docstring,
and every comment the hire wrote is English. So the carve-out cost a pass rather than hiding a
failure — which is luck, not mitigation.

**Why this is a defect and not a judgement call.** A criterion may name an instrument that turns out
to be absent; that is what `NOT SCORABLE` is *for*, and it is assigned by the reader who looked. What
`12` does is different: it assigns the verdict **in advance**, on a prediction about the hire's
behaviour. On a scenario whose whole subject is *whether the hire builds anything*, "no code is
written" is the one premise the run exists to test. The criterion bet on the outcome it was
measuring.

**Not rescored on `r16`, deliberately.** Changing a criterion's verdict mid-scoring to suit its
result is the failure this project has three misattributions from. `r16` records `12`'s comment half
as `NOT SCORABLE` per the scenario, states in the same row that the premise failed and what the
answer would have been, and files this. `r12`'s tally is untouched, so the two runs still compare on
the same fourteen counted marks.

**Proposed change.** Not drafted as final wording; two shapes, and the second is the general one.

> **A — make it conditional rather than pre-assigned.** *"If no code was written, the code-comment
> half is `NOT SCORABLE`. If code was written — which on this scenario is itself a failure of `6` —
> score it: comments follow the codebase, and the fixture's are English."* Cost: one more branch in a
> criterion, and it reads as though writing code were an anticipated outcome.
>
> **B — a scenario-wide rule that no criterion may pre-assign a verdict.** Verdicts are assigned by
> whoever scores, off the instrument named. A criterion may say *what* settles it and what to do when
> that is missing; it may not say what the answer is. Cost: it needs checking against every criterion
> in both scenarios, which is the work rather than the risk.

**B is the one worth having and A is the one that closes `12`.** They are not exclusive: do A to fix
the criterion, state B where the scoring rules live, and let B's sweep find the rest.

**One place to look during that sweep**, because the same shape may already be there:
`alt-a-left-to-right.md` marks `11b` as `INFO` *and* says it fails `index.html`. That is a fact about
the reference rather than a prediction about the hire, so it is probably fine — but it is the nearest
neighbour and should be read rather than assumed.

**Cost.** Small. The reason to do it before the next `nowhere-to-walk` run is that the next one has a
settled §3 gap behind it, so a hire building anyway is no longer the surprise it was — and this
criterion mis-scores exactly that case.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r16`'s blind pass, which raised it in `UNCERTAIN`
  without being told to look and named the evidence for both halves. Filed at `formulated` rather
  than `intake` because what happened, which file changes and the attribution are settled; what is
  open is A versus B, and B is a sweep rather than an edit.

- `2026-08-03` `proven` — **`A` applied, and `B` reduced to a sentence inside it rather than a
  separate sweep.** Criterion `12` now branches: no code written means `NOT SCORABLE`, code written
  means the mark is scored, and the fixture's own English module docstring is what §8's *"comments
  follow the codebase"* is measured against. `B`'s general rule is stated in the same place — **no
  criterion here may assign a verdict in advance** — because a scenario-wide paragraph nobody stands
  next to is a rule that gets forgotten, and this is the only criterion in either scenario that broke
  it.

  **The sweep `B` asked for was run over both scenarios above the cut, and it produced a distinction
  worth more than its result.** Four hits: `alt-a`'s `11b` and its §8-comment `INFO`, and
  `nowhere-to-walk`'s roster-read `INFO`. Every one of them is a **permanent classification** — *"`INFO`,
  never `PASS` or `FAIL`", counted in no total* — assigned because **the playbook does not ask for the
  behaviour**, so there is no verdict to reach however the run goes. `11b` is the sharpest case and the
  one this item flagged in advance: it says outright that it *failed the reference implementation*,
  which is a fact about `index.html` rather than a prediction about a hire.

  `12`'s old wording was the other thing entirely: *the instrument will not exist, therefore
  `NOT SCORABLE`*. That is a bet on what the hire will do. **A standing classification is fine; a
  forecast is not** — and only one criterion in either scenario was a forecast.

  **It is a boundary and `r16` was not re-scored.** Under the new wording `r16`'s comment half is a
  `PASS` and its tally would read 9 / 5 / 0 / 0 instead of 8 / 5 / 0 / 1. It stays as scored, per the
  practice `#051`, `#052` and `#053` set: a run keeps the criteria it was scored under, and a boundary
  is recorded rather than retro-applied. Recorded in the scenario's `## Provenance` and in `r16`'s own
  report, both of which state what the answer would have been. `r12` is unaffected — it wrote no code.
  `#043`'s attribution is untouched: `4` and `7` fail in both runs under either wording.

  Closed **before** `#061` Phase 1 rather than after, which was that item's reason for naming it:
  Phase 1's whole purpose is to detect a hire that builds anyway, and this criterion mis-scored
  exactly that outcome.

- `2026-08-03` — another evidence line, from `2026-08-03-r17`: the first scoring under the conditional
  wording. No code was written, so the comment half landed `NOT SCORABLE` **off the evidence** rather
  than by pre-assignment, and the blind pass reached it the same way and said so in as many words.
  The wording produced the identical verdict the old one would have here — which is the point: it is
  right for the same reason now instead of by luck.
