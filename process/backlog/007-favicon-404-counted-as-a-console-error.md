# `#007` — Chrome's automatic favicon request is counted as a console error in every run

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | console errors |
| Target file | `process/tools/verify-run.mjs` |
| Evidence | `2026-08-01-plan-sonnet`, `2026-08-01-index-sonnet` |
| Proof design | — |

**What happened.** Every arm of every run on the `static-site` fixture reports exactly one
console error, and it is Chrome's own `/favicon.ico` request 404-ing. The fixture has no favicon
and no reference to one, so no hire caused it and no hire can remove it.

**Why the current wording allows it.** `verify-run.mjs` counts console errors against zero. A
fixture-inherent error therefore makes the honest result `1` on every arm, and the reports have
been carrying "1 (favicon)" as a footnote instead of a number that means something. The failure
mode is the interesting one: a real error introduced by a hire would land at `2`, and a reader
comparing "1" against "1" across arms sees no change.

**Proposed change.** Give the verifier a `preexistingConsoleErrors` allowlist, measured against
the untouched fixture rather than declared by hand, and report `consoleErrors` as *new since the
fixture*. The count then starts at zero and any non-zero value is the hire's.

**Proof design.** *`Gate: none`.* Half C: *"fix the harness, rerun, record nothing against the
product."* Nothing about Monster-Dev changes.

**Cost.** An allowlist is how a check quietly stops checking — the same trap `check-index.ps1`
avoided by testing sprite-sheet geometry instead of exempting `monster.png`. Mitigation: derive
the baseline by loading the fixture before the hire touches it, so the allowlist is measured per
run and cannot accumulate hand-added entries.

**Log.**

- `2026-08-01` `intake` — from `2026-08-01-plan-sonnet` harness notes, flagged as belonging on a
  Phase 4 allowlist.
- `2026-08-01` `formulated` — unchanged in `2026-08-01-index-sonnet`; identical in all arms of
  both runs, so it is fixture-inherent rather than run-to-run noise.
- `2026-08-02` — **D3**: lands in one `verify-run.mjs` pass with `#021` and `#020`. `#021` had
  already booked the bundling from its side; this item had not mentioned it. Three separate edits to
  the measurement set would be three points after which a number stops comparing with the ten runs
  on record, for a baseline fix, a new pass and a new field that have nothing to do with each other.
- `2026-08-02` `proven` — applied, and the mitigation the Cost section demanded is what the
  implementation actually is: `verify-run.mjs` serves `process/fixtures/<name>/` itself on a
  second port, loads it before the run page, and subtracts what it logged. Nobody has to remember
  to start it, and there is no list to hand-edit — the two ways an allowlist rots. `consoleErrors`
  is now new-since-fixture and `consoleErrorsAll` sits beside it so the subtraction can be checked
  rather than trusted. Comparison is origin-blind, because the fixture and the run are served from
  two ports and the same error would otherwise read as two different strings. Criterion `16` names
  all three fields; the boundary is the one dated line in the scenario, shared with five other
  criteria.
- `2026-08-02` — measured end to end against `index.html` before this line was written:
  `fixtureConsoleErrors` holds the favicon 404, `consoleErrorsAll` holds it too, `consoleErrors` is
  empty. That is the first run in this project's history where the honest console count is zero.
