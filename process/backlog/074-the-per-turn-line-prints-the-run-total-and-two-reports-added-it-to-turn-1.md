# `#074` — the per-turn line prints the run total, and two reports added it to turn 1

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | none of its own. It corrupts the **cost envelope**, which `#002` is stated in and which `CLAUDE.md` names as one of the two numbers the tooling gate reads |
| Target file | `process/tools/hire.ps1` lines 440–441; `process/runs/2026-08-03-r14/report.md`, `process/runs/2026-08-03-r15`'s figures wherever they are quoted |
| Evidence | `2026-08-03-r14`, `2026-08-03-r15`, and one live instance while writing `2026-08-04-r20` up |

**What happened.** `hire.ps1` ends every turn by printing a summary block:

```
Cost        = $record.totals.total_cost_usd
ModelTurns  = $record.totals.num_turns
```

Those are the **run totals** — `totals` is the sum over `turns[]`, computed at line 301 — printed
after each turn under labels that read as *this turn*. So the natural way to write a report from the
console output, adding up what each turn printed, **counts turn 1 twice**.

It is not hypothetical. Both `#002` arms are wrong in every document that quotes them:

| Run | Envelope (`turns[].envelope`, summed) | Quoted everywhere | Difference |
|---|---|---|---|
| `2026-08-03-r15` | `0.3756 + 1.5668 = ` **`$1.9424`** · `12 + 26 = ` **38 turns** | `$2.3180` · 50 turns | `+$0.3756` · `+12` |
| `2026-08-03-r14` | `0.4376 + 1.4607 = ` **`$1.8983`** · `15 + 30 = ` **45 turns** | `$2.3359` · 60 turns | `+$0.4376` · `+15` |

**Both deltas are exactly turn 1's own figures**, which is the arithmetic signature of the double
count and is why this is a mechanism rather than a guess. The runs' own `hire.json` `totals` are
**correct** — `1.9424` and `1.8983` — so the record on disk never agreed with the prose, and nothing
compared them.

`r16`, `r17` and `r18` are unaffected: their reports quote `totals` rather than a sum of console
lines, and every figure matches.

**What it costs, and it is less than it looks.** `#002` is `rejected` on the sentence *"the §6 bound
cost +20 % turns (60 vs 50) at flat cost"*. On the true figures:

- **Turns: 45 vs 38, `+18.4 %`.** The finding survives — arm B still costs about a fifth more model
  turns, which is what the rejection rests on.
- **Cost: `$1.8983` vs `$1.9424`, `−2.3 %`.** *"Flat cost"* becomes *"very slightly cheaper"*. The
  direction flips and the magnitude is noise, so nothing in the rejection turns on it — but it is
  quoted as a fact and it is not one.

So this is a correction to the record rather than a reopening of `#002`. **It must not be used to
argue that item back open**, and the `2026-08-03` handoff's *"Do not redraft `#002`'s sentence"* is
unaffected.

**Proposed change.** Two parts.

1. **Label the print.** The block is the one place a person reads these numbers under time pressure,
   and it should not need a docstring:

   > ```
   > Cost        = "{0} (turn) / {1} (run)" -f $turnCost, $record.totals.total_cost_usd
   > ModelTurns  = "{0} (turn) / {1} (run)" -f $turnTurns, $record.totals.num_turns
   > ```

   Both numbers, both labelled. Printing only the per-turn figure would fix the double count and
   create the opposite error — a report quoting the last turn as the run.

2. **Correct the two reports and everything that quotes them**: `r14`'s report table and its
   criterion row, `r15`'s row in `alt-a-left-to-right.md`'s run log, and `#002`'s two cost tables.
   Each gets the true figure and a clause saying the earlier one was a double count, because a
   silently corrected number is indistinguishable from a number nobody checked.

**Cost.** Nothing. One format string, and a correction pass over four places.

**The wider point, and it is the reason this is filed rather than just fixed.** `CLAUDE.md` states
the tooling gate in `total_cost_usd` and `num_turns`, and `hire.ps1`'s own docstring says the wrapper
exists because *"every run so far discarded them and retyped the numbers into a report by hand —
which is a problem, because two of the three proof gates are stated in exactly those numbers."* The
wrapper kept the numbers and the retyping came back anyway, one layer up: the reports are still
written from the console rather than from `hire.json`. **A record nobody reads is not better than no
record** — and the check that would have caught this is a comparison between the two, which nothing
does.

`#063` is the sibling defect on the same field (`total_cost_usd` fabricated for a local model) and
they should probably be fixed in one sitting.

**Log.**

- `2026-08-04` `intake` — from `2026-08-04-r20`, and found the honest way: while writing that run up
  I added its two printed lines and got `$2.2985 / 60 turns`, then reconciled against `hire.json`
  and got `$1.9517 / 47`. The same reconciliation on `r14` and `r15` showed the error was already on
  the board's record. **The interim summary written before the reconciliation carried the wrong
  figure**, which is the clearest possible demonstration that the print is the trap rather than the
  reader.

- `2026-08-04` `proven` — **both parts done, in one sitting with `#077` and `#063` part A.**

  **Part 1, the print.** `Cost` and `ModelTurns` now read `"<turn> (turn) / <run> (run)"`, both
  figures labelled, from `$envelope` and `$record.totals` respectively. The block became an
  `[ordered]` hashtable cast to a `pscustomobject` so `#077`'s denial line can be appended
  conditionally without disturbing field order.

  **Part 2, the correction pass, and the true figures were re-derived from the envelopes rather than
  copied out of this item:** `r15` = 12 + 26 = **38 turns / `$1.9424`**, `r14` = 15 + 30 = **45 turns
  / `$1.8983`**. Corrected in six places, each with a clause saying the earlier figure was a double
  count:

  | | what it said | now |
  |---|---|---|
  | `r14/report.md` cost table | build turns 38/45, totals 50/60, `$2.3180`/`$2.3359` | 26/30, 38/45, `$1.9424`/`$1.8983`, with a corrected-on block |
  | `r14/report.md` criterion row | `60 vs 50 turns, $2.3359 vs $2.3180` | `45 vs 38, $1.8983 vs $1.9424` |
  | `r14/knowledge.md` | headline figures + `20%` in the frontmatter description | true figures + `18%` |
  | `r15/knowledge.md` | headline figures + `50 model turns` in the description | true figures + `38` |
  | `alt-a-left-to-right.md` run log | `50 turns (12+38), $2.3180` | `38 turns (12+26), $1.9424` |
  | `#002` tables | left as the record of what was believed | unchanged, but now flagged as the double-counted figures with a pointer to the true ones |

  `#002`'s own `2026-08-04` entry had already made that last call before this sitting, and it stands:
  a table silently corrected under the argument it was quoted in is a table nobody can audit. What it
  lacked was a marker at the table itself, which is all that was added.

  **`DISCUSSION-2026-08-03.md` is deliberately not corrected.** It is a dated handoff and its rows are
  a record of what was believed that day; rewriting a snapshot is how a project loses the ability to
  see that it was ever wrong. Its `50`/`60` are read through this item.

  **And the promised check exists: `process/tools/check-hire-records.ps1`.** Two sections over every
  `process/runs/*/hire.json` — **A** recomputes `totals` from `turns[].envelope` in a different
  expression than the one that wrote it, and **B** asks whether each run's `report.md` quotes its own
  recorded cost at all. B is the one that catches *this* defect on the day, because a report quoting a
  cost that is nowhere in its own record was written from the console. It reports rather than throws:
  most of what it finds is history.

  **B is narrow on purpose and the first draft proved why.** A report legitimately quotes other runs'
  figures and its own forecast, so *"every dollar figure must match"* would fire on correct prose —
  the same trap `CLAUDE.md` describes for the mirror's vocabulary list, where a term that fires on
  legitimate text is removed rather than accommodated.

  **The check's own first run was broken, and it failed in the loud direction.** On this de-DE host
  `'{0:0.0000}' -f 1.9517` renders `1,9517`, which matches no report ever written, so B fired on nine
  of fourteen runs — including `r17`, `r18` and `r20`, which this item names as **correct**. That
  discrepancy is what exposed it within a minute; formatted with `InvariantCulture` it reports exactly
  one B finding, `r14`, which is the known instance. **A fifth instrument in this project turning out
  to measure a formatting artefact rather than the thing** (`#009`, `#010`, `#007`, the
  `-SimpleMatch` grep) — the difference is that this one contradicted a known-good answer instead of
  confirming an expected one, which is the property that made it cheap.

  **Green after the pass:** `records OK — 14 record(s), totals agree with envelopes and every report
  quotes its own cost.`
