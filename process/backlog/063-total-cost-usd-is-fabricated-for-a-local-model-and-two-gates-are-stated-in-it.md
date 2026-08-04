# `#063` — `total_cost_usd` is fabricated for a local model, and a gate is stated in exactly that number

| | |
|---|---|
| Status | `formulated` |
| Part A | **applied `2026-08-04`** — `hire.json` records `baseUrl` and `local`. The item stays open on **part B**, which is a `CLAUDE.md` gate rewording and deliberately belongs to whatever item authorises a local-model A/B |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none directly. It disables the **tooling gate**, which `CLAUDE.md` states as *"`total_cost_usd` / `num_turns` must drop measurably"* |
| Target file | `process/tools/hire.ps1` — what it records and what the reports quote |
| Evidence | `2026-08-03-local-floor`: `$0.2586` reported for a turn served by Ollama on the local GPU |
| Blocked on | nothing — but it only bites once a local-model run is authorised, which no item does yet |
| Proof design | — |

**What happened.** `2026-08-03-local-floor` ran `gemma4:e2b` through Ollama's Anthropic-shaped
`/v1/messages`, with nothing in `process/tools/` modified — only `ANTHROPIC_BASE_URL` and
`ANTHROPIC_AUTH_TOKEN` set. Claude Code priced the local tokens at Anthropic rates and the envelope
reports **`total_cost_usd: 0.2586`** for a turn that cost electricity.

**Why that is worse than a wrong number.** `CLAUDE.md`'s third proof gate is stated in it:

> **Tooling** → A/B with cost: `total_cost_usd` / `num_turns` must drop measurably *and* no criterion
> may regress.

So on a local hire the tooling gate reads a fabricated quantity and would pass or fail on the
relative token counts of two arms multiplied by a price that does not apply. It would look like
evidence. `num_turns` is real, and `duration_ms` and the token counts are real; the dollar figure is
the only fabricated one, and it is the one the gate names first.

**And on disk a local run is indistinguishable from a paid one.** `hire.json` records `modelFlag`
(`gemma4:e2b`, here) but **not `ANTHROPIC_BASE_URL`**. A reader who does not recognise the model name
sees a plausible cost against an unfamiliar model and has no field that says *this did not go to
Anthropic*. Every report in `process/runs/` quotes `total_cost_usd` as a figure, and `#043`'s cost
paragraph reasons about dollars across runs.

**Proposed change.** Two, and the first is not optional if a local run is ever authorised.

> **A — record the endpoint.** `hire.json` gains `baseUrl` from the environment at launch, and
> `hire.ps1` marks the record `local: true` when it is not Anthropic's. One field, and it makes the
> distinction checkable by a script instead of by recognising model names.
>
> **B — state the gate in units that survive.** The tooling gate's substance is *"the tool paid for
> itself"*, and the durable measures of that are `num_turns` and the token counts — both real on both
> endpoints. Cost stays the headline figure for paid runs, where it is the thing the owner actually
> spends. Wording change in `CLAUDE.md`, not a tooling change.

**A is cheap and unambiguous. B needs care**, because rewriting a gate to accommodate a run class the
board has not yet authorised is how a gate gets loosened for the wrong reason. The honest sequencing
is: do `A` now, and do `B` only as part of whatever item authorises a local-model A/B — with the gate
stated in `num_turns` **and** tokens **and** cost, so a paid run is measured exactly as it is today.

**What must not be done.** The gate must not simply be waived for local runs. Its purpose is that a
tool has to pay for itself, and a local hire has a *tighter* budget rather than a looser one — the
spike measured 54 k of system prompt against ~65 k of allocated context, leaving roughly 11 k for the
playbook, the project's files and every tool result together. A stack note that is merely convenient
at Sonnet has to earn its tokens there.

**Cost.** `A` is a line. `B` is an argument, and it belongs to a future item rather than to this one.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-local-floor`. Filed rather than left in that record for
  the reason the board exists: the spike is explicitly *not* a measurement and nothing depends on it,
  so a defect recorded only there is a defect nobody meets again until it has already corrupted an
  A/B. Sibling of `#062`, found in the same spike and independent of it.

- `2026-08-04` — **part A applied**, in the sitting that fixed `#074` and `#077`; all three are
  `hire.json` `totals`-adjacent defects and all three were found by a reader doing arithmetic the
  tooling should have done. `hire.json` now records, at launch:

  > ```powershell
  > baseUrl = $env:ANTHROPIC_BASE_URL
  > local   = [bool]($env:ANTHROPIC_BASE_URL -and $env:ANTHROPIC_BASE_URL -notmatch 'api\.anthropic\.com')
  > ```

  Two fields rather than one, because `baseUrl` alone still needs a reader who knows which hosts are
  Anthropic's, and the point of the item is to make the distinction **checkable by a script**. A
  paid run records `baseUrl: null`, `local: false` — the environment variable is simply unset, so the
  normal case needs no special handling and is still positively stated rather than absent.

  `check-hire-records.ps1`, written in the same sitting, prints `LOCAL` for such a record and
  `(pre-#063 record)` for one written before this landed — which is all fourteen on disk, including
  `2026-08-03-local-floor` itself. **That record cannot be backfilled honestly**: `#077`'s two
  backfills were arithmetic over stored envelopes, and this would be a fact about an environment
  nobody stored. It stays labelled by its model name and by this item.

  **Part B is untouched and stays open**, on the item's own sequencing: *"do `A` now, and do `B` only
  as part of whatever item authorises a local-model A/B."* Rewriting a gate for a run class the board
  has not authorised is how a gate gets loosened for the wrong reason, and nothing in this sitting
  changed that. The `Blocked on` row still says the true thing — this only bites once a local run is
  authorised.
