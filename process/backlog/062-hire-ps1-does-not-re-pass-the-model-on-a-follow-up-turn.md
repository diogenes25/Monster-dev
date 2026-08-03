# `#062` — `hire.ps1` does not re-pass `--model` on a follow-up turn, and the record cannot tell you

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none of its own, and potentially every criterion of every multi-turn run — the model is what an attribution is stated against |
| Target file | `process/tools/hire.ps1` — line 195, and the record it writes |
| Evidence | `2026-08-03-local-floor` found it against Ollama, where it is a hard 404. Verified independently on `2026-08-03-r16` |
| Blocked on | nothing |
| Proof design | — |

**What happened.** `hire.ps1:195` is

```powershell
if ($Model) { $claudeArgs += @('--model', $Model) }
```

and an `-Answer` turn never passes `-Model`. So turn 2 onward runs on whatever the **launching
environment's** default model is. `--resume` does not restore the session's model: a resumed and a
fresh `claude -p` both selected `claude-opus-5[1m]` when the spike checked.

**And `hire.json` cannot tell you which model a follow-up turn used.** `modelFlag` is written once,
at run creation, from turn 1's flag — `2026-08-03-r16` records `modelFlag: opus` whether or not
turn 2 ran on Opus. The **fact** is in `turns[].envelope.modelUsage`, which the CLI fills per turn;
the **intention** is in `modelFlag`, which is what a reader reaches for. Nothing checks they agree.

**The archived record holds, and that is the finding rather than the reassurance.** Verified by hand
rather than taken from the spike's report:

| Run | `modelFlag` | `turns[0].modelUsage` | `turns[1].modelUsage` |
|---|---|---|---|
| `2026-08-03-r16` | `opus` | `claude-opus-5`, `claude-haiku-4-5` | `claude-opus-5` |

Turn 2 really was Opus, so `r16`'s attribution stands and `#043` is not weakened. But it stands
because the session that launched it happened to default to the same model as the flag. Two
different runs on record report two different *correct* models on their second turn, which cannot
come from one shared default — so **the record is right by coincidence, not by construction.**

That is the same shape as the three scripts that each derived `..` separately and agreed until one
of them moved, which `process/tools/lib/run-root.ps1` exists to have ended. A coincidence that has
held so far is not a property.

**Why it matters beyond tidiness.** `CLAUDE.md`'s gates are stated at a **Sonnet**-class hire, and
Half C makes a Haiku failure explicitly not a finding. Both rules are about *which model ran*. A
two-turn A/B whose second turn silently ran on a different tier is not the experiment it claims to
be, and nothing on disk would say so — `modelFlag` would still read `sonnet`.

**Proposed change.** Two halves, and the second is the one that survives the next refactor.

> **A — pass it every turn.** `hire.ps1` already records `modelFlag`; a resume turn should append
> `--model` from the record rather than from a parameter nobody passes. One line, and it turns the
> coincidence into a guarantee.
>
> **B — check the record against itself.** After each turn, compare `modelFlag` with the turn's
> `envelope.modelUsage` and refuse — or at minimum warn loudly — on a mismatch. `A` fixes the
> mechanism; `B` catches the next mechanism that breaks, including a CLI change to how `--resume`
> handles models.

**Both, and `B` is the reason to bother.** `A` alone is a fix whose success is unobservable, which is
the class of thing this project keeps finding late.

**One caveat on `B`'s instrument, so it is not written naively.** `modelUsage` is keyed by *concrete*
model id (`claude-opus-5`) while `modelFlag` is an alias (`opus`), and turn 1 of `r16` lists
**two** models because the CLI used Haiku for something internal. So the check is *"does the flag's
tier appear in this turn's usage"*, not string equality — and a check written as equality would fail
every run and be deleted for being noisy.

**Cost.** Small. The re-verification cost is nil: `modelUsage` is already captured in every
`hire.json` on disk, so the whole archive can be audited without spending a run.

**Log.**

- `2026-08-03` `formulated` — found by `2026-08-03-local-floor`, an unauthorised floor spike, where
  the missing flag is a hard 404 against a local endpoint rather than a silent substitution. Filed at
  `formulated` because what happens, which line changes and the attribution are settled; what is open
  is whether `B` is worth its noise budget.

  **The evidence was re-derived rather than accepted.** `r16`'s per-turn `modelUsage` was read
  directly, and the `modelFlag`-is-written-once behaviour confirmed in its own `hire.json`. The
  spike's account was accurate on every point checked, which is a reason to read it and not a reason
  to skip the checking.
