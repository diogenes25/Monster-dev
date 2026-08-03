# `#032` — four defects sat in the path of every run, and each one fails in the direction that looks like success

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `check-isolation.ps1`, `score-bundle.ps1`, `publish-demos.ps1`, `verify-run.mjs` |
| Evidence | code review of `main...HEAD`, `2026-08-02`; every one reproduced before being fixed |
| Proof design | — |

**What happened.** A review of the twelve commits on this branch reported ten defects across the
nine PowerShell tools and `verify-run.mjs`. Four of them sit in the path of an ordinary run, and
that is why they are one item and applied at once rather than queued. The other six are `#033`,
`#034`, `#035` and `#036`.

The four share a shape worth naming: **each fails in the direction that reads as success.** None
of them throws, none prints a warning, and three of them produce output that looks exactly like a
clean result.

| Site | What it did | Verified by |
|---|---|---|
| `check-isolation.ps1:76` | `-Target` ending in a separator made the check report the run folder as a leaking sibling of *itself* | `GetFileName('C:\a\b\')` is `''`, and `Resolve-Path` **preserves** the trailing separator — both measured |
| `score-bundle.ps1:184` | the leak regex's bare `board` matched inside **keyboard**; a hit deletes the whole scoring bundle | pattern run against `"the keyboard handler"` — matched. **Latent, not fired** — see below |
| `publish-demos.ps1:164` | `[regex]::Replace(s, p, r, 1)` has no count overload; the `1` bound to `RegexOptions.IgnoreCase` and every `<body>` got a banner | two-`<body>` input, both replaced |
| `verify-run.mjs:446` | `process.exit(0)` in the `finally`, so a crashed verifier exited 0 with `harnessError` set | read; no caller depends on the old code |

**Why this matters more than four bug fixes.** Three of the four are in *checking* apparatus —
the isolation check, the blind-scoring bundle, the measurement verifier. This project's answer to
every late-found failure has been to add a reader: two agent roles, a second blind scoring, six
path-free mirror checks. A checker that fails silently is worse than no checker, because it also
spends the attention that would have gone to looking.

`verify-run.mjs` is the sharpest of the four and the reason this item is not called "four small
bugs". It is the instrument. Every §D criterion is scored off `measurements.json`, and an exit
code of 0 with a wrong Chrome path or a CDP connection that never came up is the instrument
reporting success while broken.

**Why the current wording allowed it.** Nothing was wrong in the prose. `check-isolation.ps1`'s
sideways look is eight days old and was tested against the paths a script passes, never against
the path a person tab-completes. `score-bundle.ps1`'s word list was written before the brief it
would scan was a keyboard shortcut. The other two are language-level: a PowerShell overload that
silently means something else, and a `finally` that runs after the `catch` that recorded the
failure.

**What was applied.**

Each fix carries a comment naming the trap rather than describing the code, because all four are
the kind that get re-introduced by someone tidying up. Each was reproduced first and re-tested
after:

- `check-isolation.ps1` — `TrimEnd` on both separator characters before `GetFileName`. Verified
  three ways: passes with and without a trailing separator and reports the *same* sibling count
  for both, and still throws on a planted `2026-08-01-alt-a` beside the run folder.
- `score-bundle.ps1` — `\bboard\b`. `"the keyboard handler"` is now clean, `"read the board
  first"` still fires. The other three terms are multi-word and cannot collide this way.
- `publish-demos.ps1` — the *instance* `Replace`, which does have a count overload. Verified
  against a two-`<body>` document: one banner.
- `verify-run.mjs` — `process.exit(results.harnessError ? 1 : 0)`. `measurements.json` is still
  written in every case, so the diagnosis survives; only the verdict changes. No PowerShell caller
  invokes it, so nothing breaks and an exit-code gate becomes possible for the first time.

**One defect the review did not find, discovered by testing the fix.** `check-isolation.ps1`'s
success line derived the run-folder name a *second* time, from the untrimmed path — so with the
sideways look repaired, the passing message still listed the run folder among its own neighbours
(`parent holds 2 other directories: dist, target`). Both derivations are now one: `$self` and
`$parent` are computed once and reused.

That is the item's real lesson. A single reader — human, agent or review tool — finds the defect
it looked for. The duplicate surfaced only because the fix was **run** and the output **read**,
which is the same rule `CLAUDE.md` already states about the mirror: a green script is not
evidence.

**And one claim in the review did not survive being checked.** The `board` finding was reported as
*verified*, with the consequence that *"an innocuous hire summary deletes the whole bundle"*. The
pattern defect is real and was reproduced. The consequence was not: a bundle rebuilt for
`2026-08-01-index-sonnet` after the fix contains the substring in exactly two files, `criteria.md`
and `transcript.jsonl`, and the scan skips both by name. Nothing else in it matches, and the scan
only reads `.md`, `.json` and `.txt` — the hire's own `KeyboardEvent` is in a `.js` and was never
in range.

So the defect is **latent**: no bundle on record would have been deleted, and none was. The
realistic path is a hire writing *"keyboard shortcut"* into a Markdown file inside `worktree/`,
which is plausible and has not happened. Fixed anyway, because a leak scan whose failure mode is
*delete the artefact* has no margin — but the item says latent rather than repeating *verified*,
and the correction is recorded because it is the second time in one sitting that a confident
single reader needed checking.

**Cost.**

- **Four fixes in one commit, applied without their own before-fail run.** These are `Gate: none`
  by the lane rule — tooling correctness, no criterion to flip — but it is worth saying plainly
  that "reproduced, fixed, re-tested" is a weaker bar than the gates hold product changes to.
- **`verify-run.mjs` can now exit non-zero**, and no procedure reads that yet. The value is
  available and unclaimed until something gates on it; until then the change only stops the lie.
- **Ten findings from one reviewer, four acted on immediately.** The other six were read and
  filed, not dismissed — but they were not independently reproduced, and the items say so.

**Log.**

- `2026-08-02` `intake` — ten defects reported by a review of `main...HEAD`, alongside four
  constructs the reviewer suspected and cleared.
- `2026-08-03` `proven` — the four run-path defects reproduced, fixed and re-tested. A fifth,
  the duplicate derivation in the success line, was found by running the repaired check and
  reading what it printed.
