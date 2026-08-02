# `#010` — A stale server let the verifier measure the wrong arm and report it confidently

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | all of section D, silently |
| Target file | `process/tools/verify-run.mjs`, the run procedure |
| Evidence | `2026-08-01-plan-sonnet` |
| Proof design | — |

**What happened.** The first `plan-sonnet` verification reported
`spriteUrl: .../assets/monster.png` — the **before-arm's** file name. The previous static server
still held port 8080, so the new one never bound, and the verifier silently re-measured
`2026-08-01-sonnet-base2`. No error, no warning, a complete-looking result.

**Why this one matters more than its size suggests.** It was caught only because the two hires
happened to name their sprite differently. **Had both arms picked the same filename, the run would
have produced a flawless "no difference" result** — and "no difference" is precisely the verdict
that retires a change under the A/B gate and removes a tool under the cost gate. This class of bug
does not produce wrong numbers that someone might question; it produces confident ones that nobody
would.

**Proposed change.** Applied during the run: every arm gets its own port.

**Proof design.** *`Gate: none`.* Nothing to prove — the mechanism was established from the sprite
filename in the output.

**Cost.** None to the product. Worth stating what it cost the *record*: every A/B result produced
before this fix rests on the assumption that each arm's server actually bound, and that assumption
was never checked. Nothing is being retracted on that basis, but a "no difference" from before this
date is weaker evidence than one from after it.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-plan-sonnet` harness notes.
- `2026-08-01` `proven` — one port per arm.
- `2026-08-02` — filed onto the board, kept rather than closed silently because the failure mode is
  invisible by construction: the next instance will not announce itself either.
