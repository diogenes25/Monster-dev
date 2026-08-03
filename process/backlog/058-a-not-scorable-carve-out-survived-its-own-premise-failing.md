# `#058` — a criterion pre-assigns `NOT SCORABLE` on a premise the run can falsify, and did

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `12`, the §8 code-comment half |
| Target file | `process/scenarios/nowhere-to-walk.md` — and the pattern is worth checking in `alt-a-left-to-right.md` |
| Evidence | `2026-08-03-r16`; raised by the blind scoring, unprompted |
| Blocked on | nothing |
| Proof design | — |

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
