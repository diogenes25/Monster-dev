# `#007` — Chrome's automatic favicon request is counted as a console error in every run

| | |
|---|---|
| Status | `formulated` |
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
