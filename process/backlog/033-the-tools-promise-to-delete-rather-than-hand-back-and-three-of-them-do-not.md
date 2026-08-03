# `#033` — three tools promise to delete rather than hand back a broken result, and their own error paths do not

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | — |
| Target file | `process/tools/new-run.ps1`, `process/tools/score-bundle.ps1`, `process/tools/publish-demos.ps1` |
| Evidence | code review of `main...HEAD`, `2026-08-02`; all three reproduced `2026-08-03`, each against the pre-fix code as well |
| Blocked on | nothing |
| Proof design | — |

**What happened.** *"It builds and verifies in one step and deletes the mirror rather than return
a leaking one."* *"Deletes the folder rather than hand back one that fails isolation."* That
promise is in `CLAUDE.md` twice, in `process/README.md`, and in the doc comments of the scripts
themselves. It is the reason nobody inspects these outputs by hand.

Three places do not keep it, and each is on the script's own error path — the branch that runs
only when something has already gone wrong, and therefore the branch nothing has exercised.

- **`new-run.ps1:127`** — `& $recipe` has no `catch`. A setup recipe that *exits* non-zero is
  handled; one that raises a **terminating** error is not, and the run folder stays on disk. The
  next thing that happens is somebody hires against a folder whose dependencies were never
  installed, and the cost of that lands in `num_turns` — one of the three numbers the tooling
  gate is stated in.
- **`score-bundle.ps1:194`** — every failure path deletes the bundle except the last one, the
  isolation check. A bundle that fails it is left complete-looking at exactly the path the
  procedure tells the operator to `cd` into. The blind scoring is the control on the first
  scoring; a control that runs against a bundle the script refused is worse than no second pass.
- **`publish-demos.ps1:205`** — `git checkout --orphan` fails once the branch exists (exit 128,
  unchecked). The script then commits to a detached HEAD, `git worktree remove --force` throws
  that commit away, and it prints `Demos = 10` and the tip of the **stale** branch. Republishing
  is a silent no-op that reports success. Reproduced by the reviewer; this is the one of the
  three that has certainly already happened, because the branch was built once on `2026-08-02`.

**Why the current wording allows it.** The promise is stated as a property of the tool and
implemented as a sequence of statements. Nothing checks that every exit from the script is
covered, and the paths in question are unreachable in a normal run by construction — which is
the same reason `#032`'s four defects survived, and the reason both items exist at all.

**Proposed change.**

> `new-run.ps1` wraps the recipe in `try`/`catch` and deletes the folder on a terminating error,
> the same way the exit-code branch already does.
>
> `score-bundle.ps1` deletes the bundle when the isolation check throws. That means catching it,
> since the check throws rather than returning.
>
> `publish-demos.ps1` handles an existing branch explicitly — check `git rev-parse --verify`
> first, and either delete the local branch before the orphan checkout or refuse with a message
> that says which. Silently rebuilding is defensible; silently *not* rebuilding is not.
>
> And the exit codes get checked. Every `git` invocation in `publish-demos.ps1` currently runs
> unguarded; `$LASTEXITCODE` after each, or a small `Invoke-Git` helper that throws, is the
> minimum. This is the sub-deliverable that outlives the three specific bugs.

**Proof design.** *`Gate: none`.* Tooling correctness, no criterion to flip. But each fix must be
**demonstrated against its own failure**, not just written: a recipe that throws, a bundle that
fails isolation, a second `publish-demos.ps1` run against an existing branch. `#032` is the
precedent — its fifth defect was found only by running the repaired code and reading the output.

**What was applied.** All three, each demonstrated **both ways** — the pre-fix code run against
the same failure first, so the entry records what changed rather than that the new code works.
The sabotage was a copy of the script with the new `catch` removed, deleted afterwards.

| Site | Pre-fix, measured | After |
|---|---|---|
| `new-run.ps1` | recipe throws → raw `synthetic recipe failure`, **run folder left on disk** | message names the recipe, folder gone. The exit-code branch still fires unchanged (exit 3) |
| `score-bundle.ps1` | ancestor `CLAUDE.md` → **bundle left on disk, 12 files, looking complete** | `Bundle deleted rather than handed back.`, folder gone |
| `publish-demos.ps1` | second run → tip identical before and after, exit 0, full success report incl. the **stale** `Committed` | refuses by name; `-Rebuild` moves the tip and reports the new one |

`new-run.ps1` records the failure and re-throws *after* `Pop-Location`: `$target` is the working
directory at that moment and Windows will not delete it. That ordering is the reason the catch is
a variable and not a `Remove-Item` inside the `catch` block.

The sub-deliverable the item asked for is there: every `git` call in `publish-demos.ps1` that must
succeed goes through an `Invoke-Git` helper that throws on a non-zero exit, plus a **post-condition**
— the branch must exist afterwards and must not still point at the tip it had before. Checking the
calls is not the same as checking the outcome, and the outcome is the thing that was wrong.

**A fifth defect, found the same way `#032`'s was.** The first run of the repaired
`publish-demos.ps1` failed with `git branch gh-pages exited 128 — a branch named 'gh-pages'
already exists`. `Invoke-Git branch -D $Branch` had been written with
`ValueFromRemainingArguments`, and PowerShell binds a leading-dash token to a **parameter name**
before it ever reaches the remaining-arguments collector — so `-D` was silently dropped and the
call *created* the branch instead of deleting it. The helper is now called with one array
argument, `Invoke-Git @('branch','-D',$Branch)`, at all five sites.

That is the same shape as `#032`'s `[regex]::Replace` overload: a call that silently means
something else. It is recorded here rather than folded in quietly because of what caught it —
**the fix's own exit-code check, on its first run.** Had the helper not been written, the `-D`
would have been dropped exactly as invisibly as the `--orphan` failure it was written to catch.

**Two things measured and deliberately not changed.**

- **`process/tools/setup/` does not exist.** The recipe branch this item's first bullet is about
  has therefore never run in a real run, which is why nothing had exercised it. The directory was
  created for the demonstration and removed again; the fix is still worth having, because the
  first fixture that needs a recipe is `gsap-site` and it is already on the board.
- **A failed `new-run.ps1` leaves the empty run root behind.** All five failure paths delete
  `$target` and none deletes `<runRoot>/`. That is the literal promise kept — the script's own
  help defines the run folder as `…\<RunId>\target` — and it is left alone on purpose: the run
  root is also where `build-dist.ps1` writes `dist/`, so deleting it is the one direction that
  could destroy something the operator wanted. The residue is an empty directory that
  `check-isolation.ps1` never looks at, because its sideways check reads the run root and not
  `monster-dev-testruns/`. Recorded as a boundary rather than claimed as clean.

**Cost.**

- **Deleting on failure destroys the evidence of the failure.** That trade was already made for
  the other paths and should stay consistent, but for `score-bundle.ps1` in particular the
  operator then has nothing to look at. Printing what failed before deleting is the mitigation,
  and the existing paths already do it.
- **`publish-demos.ps1` may have published a stale branch already.** The branch was built once,
  before `README.md` was dropped from each demo. Whatever is at `gh-pages` today should be read
  rather than assumed, and that is a check to run *before* the fix, not after. **Checked
  `2026-08-03`, before the fix: it was fine.** One commit, ten demo folders, `index.html` and
  `.nojekyll`, and nothing had ever republished over it — the no-op had no stale content to
  produce because there had only been one publish. The exposure was real and unspent.
- **`gh-pages` was rebuilt during the demonstration**, `3460116` → `f7eea9c`. Content is
  byte-identical (same tree hash), still orphan, still unpushed. Recorded because the branch moved
  and nothing else says so.
- **The `-Rebuild` switch is a new way to lose work**, and it is the deliberate half of the trade:
  the old script destroyed the branch silently, the new one destroys it on request. What it cannot
  do any more is destroy it and report success.

**Log.**

- `2026-08-03` `formulated` — split out of the same review as `#032`. Separate because these three
  are not in the path of a run: they fire only when something else has already failed, which is
  precisely why they need a deliberate demonstration rather than a rerun.
- `2026-08-03` `proven` — all three applied, each demonstrated against its own failure *and*
  against the pre-fix code. `publish-demos.ps1`'s silent no-op was reproduced first, exactly as
  described: identical tip before and after, exit 0, a success report naming the stale commit.
- `2026-08-03` — the fifth defect, in the fix itself: `ValueFromRemainingArguments` swallowed
  `-D`. Caught by the new exit-code check on its first run, which is the second time in two items
  that running the repaired code found what reading it did not. `#032` said that was the lesson;
  this is it happening again, at a cost of one run.
- `2026-08-03` — `process/tools/setup/` turned out not to exist at all, so the `new-run.ps1`
  branch this item opens with had never executed. Filed here rather than as its own item: it is
  the *reason* the defect survived, not a separate finding.
