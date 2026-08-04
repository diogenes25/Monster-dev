# `#077` — `permissionDenials` is always zero, because an array is cast to `[int]`

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none. It disables a **stop rule**: *"if a run dies on a permission denial, widen the fence and rerun; do not record it as a finding"* |
| Target file | `process/tools/hire.ps1` line 306 |
| Evidence | `2026-08-04-r20` (found by its blind scoring), `2026-08-01-plan-opus` (found by the sweep it prompted) |

**What happened.** `hire.json` `totals.permissionDenials` reads `0.0` for `2026-08-04-r20`. The
envelope for turn 2 reads:

```json
"permission_denials": [
  { "tool_name": "Bash",
    "tool_input": { "command": "ls -la \"…/2026-08-04-r20/dist/monsters\" 2>&1",
                    "description": "Check whether the accidental rm actually deleted the dist README" } }
]
```

One denial, and the total says none.

**Why.** Line 306:

```powershell
permissionDenials = ( $record.turns | Measure-Object -Property { [int]$_.envelope.permission_denials } -Sum ).Sum
```

`permission_denials` is an **array of objects**, not a number. `[int]` on it yields `0`, so the sum is
`0` for every run whatever happened. The sibling fields on either side are correct because they cast
numbers: `total_cost_usd` and `num_turns` are scalars.

**Two runs on record carry a hidden denial**, found by sweeping every `hire.json` for
`totals.permissionDenials ≠ Σ turns[].envelope.permission_denials.Count`:

| Run | totals | actual |
|---|---|---|
| `2026-08-01-plan-opus` | `0.0` | 1 |
| `2026-08-04-r20` | `0.0` | 1 |

Neither report mentions one. `r20`'s said *"no permission denials"* in as many words, off the total.

**What it costs.** The wrapper's whole justification is that the gates are stated in numbers the
prose used to retype — and this is the one field in that group whose job is a **stop rule** rather
than a measurement. Half B: *"a fence that is too tight shows up as a product failure when it was
really the harness. If a run dies on a permission denial, widen the fence and rerun; do not record it
as a finding."* A run cannot be checked against that rule from a field that is always `0`.

Neither known instance mattered — both denials are cleanup-phase calls after the implementation and
after every measurement, and neither run died. **That is the field working by luck.** A denial on a
`Write` in the build phase would produce a hire that could not finish, a report reading *"0 denials"*,
and a product finding filed against the playbook.

**Proposed change.** Count the array and keep it:

> ```powershell
> permissionDenials = ( $record.turns | Measure-Object -Property { @($_.envelope.permission_denials).Count } -Sum ).Sum
> permissionDenialTools = @( $record.turns | ForEach-Object { $_.envelope.permission_denials } |
>                            ForEach-Object { $_.tool_name } | Select-Object -Unique )
> ```

The second field is the one a reader actually needs — *which tool was fenced out* is what decides
whether the fence was too tight — and it is one line, from data already stored.

And, because a wrong number that looks right is exactly what this project keeps finding: **the
summary block should print the denial count only when it is non-zero, with the tool names.** A `0`
printed every turn is a `0` nobody reads.

**Cost.** Two lines. No re-scoring: neither affected run's verdicts move, and both reports get a
corrected clause.

**Sibling defects on the same object, and they should be fixed in one sitting.** `#074` — the
per-turn summary prints the *run* total under a per-turn label, and two reports double-counted turn 1
because of it. `#063` — `total_cost_usd` is fabricated for a local model. All three are `hire.json`
`totals` fields that say something the envelopes do not, and all three were found by a reader
comparing the two by hand. **There is no check that `totals` agrees with `turns[]`**, and after these
three there probably should be: the sweep that found the second instance above is four lines and
would have caught all of them.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r20`. **Found by the blind second scoring**, which cited
  `permission_denials[0]` from the envelope while the primary scoring wrote *"no permission denials"*
  from the total. Neither reader was looking for a tooling bug; they disagreed about a fact and the
  disagreement was the instrument. The sweep over every `hire.json` came afterwards and found
  `plan-opus`.

- `2026-08-04` `proven` — **fixed, and in one sitting with `#074` and `#063` part A as all three items
  asked.** What went in:

  - **The count**, `@($_.envelope.permission_denials).Count` for the cast, plus
    **`permissionDenialTools`** from data already stored — because *which tool was fenced out* is the
    only question a denial actually raises and a count cannot answer it.
  - **The print, only when non-zero**, with the tool names. A `0` printed every turn is a `0` nobody
    reads, which is how this lasted fourteen runs.
  - **`process/tools/check-hire-records.ps1`**, the sweep this item and `#074` both argued for, now a
    tool rather than four lines somebody types once. See the `#074` entry for what it does and for the
    bug it had on its first run.

  **Its first run found exactly the two known instances and nothing else**, recomputing from the
  envelopes in a different expression than the one that wrote the file — which is the only way a cast
  bug can be caught, since `totals` is computed *from* `turns[]` and a self-check would agree with
  itself.

  **The two hidden denials are now correct on disk, and only the derived fields were touched.**
  `totals.permissionDenials` and `totals.permissionDenialTools` were recomputed on
  `2026-08-01-plan-opus` and `2026-08-04-r20`; the diff is five lines inside the `totals` block and
  **no envelope byte moved**. That distinction is the whole justification: the envelopes are the
  evidence, `totals` is arithmetic over them, and correcting arithmetic is not editing a record. The
  alternative was a sweep that reports four known disagreements forever — which is this item's own
  argument about the printed `0`, one layer up.

  **Neither denial was a fence problem, and that is worth stating rather than leaving as *"did not
  matter"*.** `r20`'s was a `Bash` `ls -la` during cleanup. `plan-opus`'s was a `Remove-Item` on
  `'\','\\'` blocked by **the CLI's own path protection**, not by this harness's allowlist — so the
  stop rule *"widen the fence and rerun"* would have been the wrong response to it. Both reports now
  say so: `plan-sonnet/report.md` had claimed *"No permission denials"* in as many words for the arm
  that had one, and `r20`'s cost-envelope row read `0 denials`.

  **What this does not fix.** Nothing yet checks that a *report* agrees with its record on anything
  but cost — section B is deliberately narrow, see `#074`. And the field is still only as good as the
  envelope: a denial the CLI does not record is invisible here as it was before.
