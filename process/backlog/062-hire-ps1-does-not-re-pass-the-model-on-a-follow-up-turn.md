# `#062` — `hire.ps1` does not re-pass `--model` on a follow-up turn, and the record cannot tell you

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none of its own, and potentially every criterion of every multi-turn run — the model is what an attribution is stated against |
| Target file | `process/tools/hire.ps1` — line 195, and the record it writes |
| Evidence | `2026-08-03-local-floor` found it against Ollama, where it is a hard 404. Verified independently on `2026-08-03-r16` |
| Blocked on | nothing |
| Proof design | `Gate: none` — both halves applied. The tier comparison was tested against nine cases **before** it shipped, and the first version was wrong; see the `proven` entry |

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

- `2026-08-03` `proven` — **both halves applied, and it stopped being a tidying job when it was
  measured.** It was filed as cheap board work. Then a live check made it a blocker for `#061`
  Phase 1: an unflagged `claude -p` in this working copy selects `claude-opus-5[1m]`, and nothing
  pins a model — not `~/.claude/settings.json`, not `.claude/settings.local.json`, not
  `$env:ANTHROPIC_MODEL`. Phase 1 is the **Sonnet** arm, so its turn 2 would have run on Opus while
  `modelFlag` read `sonnet`. The defect was about to corrupt the next run rather than the last one.

  **`A`:** the resume branch takes `$Model` from `$record.modelFlag` when the caller passed none, so
  the flag is re-passed every turn. The record is the authority rather than the parameter — the flag
  belongs to the *run*, and a follow-up turn free to pick a different model would not be the same
  experiment.

  **`B`:** after each turn, `modelFlag`'s tier is compared against `envelope.modelUsage` and a
  mismatch warns loudly. A **warning and not a throw**, deliberately: the turn is already paid for,
  and throwing would destroy the envelope and the worktree snapshot — the exact evidence needed to
  decide whether the run is still usable.

  **The check's first version was wrong, in the direction that matters, and testing is what caught
  it.** Taking the tier as `($Model -split '[-\[]')[0]` reduces `claude-sonnet-5` to `claude`, and
  `claude` then matches every Claude model — so the check went **vacuous for exactly the caller who
  was being more specific**. Nine cases were run against both versions: the first failed one, the
  second passed all nine. The shipped version looks the tier up from a known list and falls back to
  the whole flag, which also keeps a local slug like `gemma4:e2b` working. `.Contains()` replaced
  `-like` in the same pass, because a local slug may carry `[` or `*` and `-like` would silently
  reinterpret them as wildcards.

  That near miss is the item's own subject arriving one level up: a check that cannot fire is
  indistinguishable from a check that passes, and this project has found four of those late.

  Not re-verified across the archive, because it does not need to be: `modelUsage` is already in
  every `hire.json` on disk, so the whole record can be audited at any time without spending a run.
  `#043`'s attribution was audited that way before this fix and holds — `r16`'s turn 2 billed
  `claude-opus-5`.

- `2026-08-03` — **verified on its first real run, by measurement.** `2026-08-03-r17` is a Sonnet arm
  launched from an Opus session, which is exactly the configuration that used to break: per-turn
  `envelope.modelUsage` reads `claude-sonnet-5` on **both** turns (turn 1 also lists a
  `claude-haiku-4-5` the CLI used internally). Before the fix turn 2 would have billed
  `claude-opus-5[1m]` while `modelFlag` read `sonnet`. No tier-mismatch warning fired, which is the
  other half working: the check is quiet when the flag took.
