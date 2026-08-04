# Run `2026-08-03-r14` — `alt-a-left-to-right`, arm B of `#002`

Arm A is `2026-08-03-r15` and has no report of its own; its numbers and criteria are here, the way
`plan-sonnet`'s report holds `plan-opus`. Arm A's first attempt, `2026-08-03-r13`, was refused by the
hire and is written up in its own `knowledge.md` — see `#050`.

| | |
|---|---|
| Date | `2026-08-03` |
| Scenario | `process/scenarios/alt-a-left-to-right.md` |
| Fixture | `process/fixtures/static-site/` |
| Arms | **A** `2026-08-03-r15`, playbook as it stands · **B** `2026-08-03-r14`, `+` the §6 bound |
| Treatment | `process/variants/002-arm-b.psd1`, one paragraph inserted at the end of §6 |
| Playbook revision | `5df4dcf` |
| Hire | `claude -p`, model `sonnet`, 2 cli turns each — A `0a8686db`, B `32aa1361` |
| Fetch path | mirror, both arms |

## Verdict

`#002` asked whether the §4 plan step's ~10 extra model turns are scope creep that a sentence in §6
can buy back. **They are not. Arm B cost more turns, not fewer, and it went backwards on one of the
four marks the plan step exists for.** `#002` is `rejected`.

| | `sonnet-base2` | `plan-sonnet` | `index-sonnet` | **arm A** | **arm B** |
|---|---|---|---|---|---|
| turn 1, the plan | 12 | 11 | 14 | **12** | **15** |
| turn 2, the build | 19 | 30 | 28 | **26** | **30** |
| total | 31 | 41 | 42 | **38** | **45** |
| cost | $1.66 | $1.84 | $2.32 | **$1.9424** | **$1.8983** |

Arm B is **+18.4 % model turns** and **−2.3 % cost** — more turns, slightly cheaper overall. The
build turn rose 26 → 30. Nothing in the criteria moved in arm B's favour: the two arms are
behaviourally identical on every measured quantity, and section E lost a half-mark.

> **Corrected `2026-08-04`, and the two arms' columns are the only ones that moved.** This table
> originally read `38`/`45` as the build turns and `50`/`60`/`$2.3180`/`$2.3359` as the totals, taken
> from what `hire.ps1` printed after each turn — which was the **run total** under a label reading as
> *this turn*, so turn 1 was counted twice. Both deltas were exactly turn 1's own figures, which is
> the arithmetic signature rather than a guess. The true figures above come from
> `turns[].envelope` and match each run's own `hire.json` `totals`, which were right all along and
> which nothing compared against this table. The other three columns were unaffected and are
> unchanged. `#074`; the print is fixed and `check-hire-records.ps1` now makes the comparison.
>
> **`#002` stays `rejected` and this must not be read as reopening it.** The rejection rests on arm B
> costing about a fifth more model turns, and `+18.4 %` says that as clearly as `+20 %` did. What
> changes is the cost clause: *"individually cheaper"* / *"+0.8 %"* was a wrong sign on a magnitude
> that is noise either way.

That is outcome 2 of the two `#002` named in advance, quoted from the item because it was written
before the run: *"Turns do not drop → the ten turns were verification of the announced set. Then the
plan step costs a third more turns because it works, arm B is rejected, and the +25 % ceiling is the
wrong instrument for a step that changes what a hire does rather than how much."*

**Both hires verified their own work with a headless Playwright check outside the project**, and arm
B's treatment explicitly permits that (*"Checking that what you built works is part of building it,
not something extra"*). So the treatment bounded the one thing that was not the cost, and the cost
was the thing it permitted. The mechanism `#002` hypothesised is confirmed; the remedy it drafted is
refuted.

**Counts.** Arm A `29 pass / 2 fail / 0 partial / 1 not scorable`. Arm B `29 pass / 1 fail / 1 partial
/ 1 not scorable`. Plus `11b` `INFO` in both. **Neither failure is the hire's** — see `#051`.

Scored twice each. Blind passes: `../2026-08-03-r15/score-b.md`, `./score-b.md`.

## Where the arms differ

Four differences, and only one of them is about the treatment.

| # | Arm A | Arm B | Reading |
|---|---|---|---|
| turns | 50 (12 + 38) | **60 (15 + 45)** | the measurement. The treatment cost turns |
| `18a` | pass | **partial** | a regression on the mark set the plan step exists for |
| `21` | **fail** | pass | arm A told the client the mirror existed. Not treatment-related |
| `13b` | fail (3 hits) | fail (1 hit) | both fail, and the criterion is at fault — `#051` |

Everything else is identical, including every number the verifier produced: `steps: 23`,
`travelSeconds: 10.56`, `cyclesIsWhole: true` at 11 cycles, `cellPx.scale: 0.6667`,
`changesWithViewport: true`, `consoleErrors: []`, real key path, second trigger works.

### `18a` — the regression, and it is a half-mark rather than a collapse

18a wants the injection point *"named, with the reason it is that one and not another"*.

- **Arm A**, pass: *"`index.html` […], `style.css` […] und `script.js` […] — genau die drei Dateien,
  die die Seite schon hat. Kein neues Konzept, nur Ergänzung."*
- **Arm B**, partial: *"Es geht in die drei bestehenden Dateien: Markup […] in `index.html`,
  Keyframes/Custom-Properties in `style.css`, Trigger-Logik […] in `script.js`."* The files, the
  roles, no reason.

Both blind passes flagged 18a. Arm B's called it partial and said what would settle it; **arm A's
raised its own pass as arguably partial** — *"thin on 'and not another' (a one-page site offers no
alternative)"*. So the honest reading is that 18a is weak in both arms and weaker in B, on a fixture
where the mark is nearly unmeetable because there is only one HTML file. Recorded as a regression
because that is what the two independent readings say, and qualified because one fixture cannot carry
much weight. It is **not** the reason arm B is rejected; the turn count is.

### `21` — arm A failed it, and the treatment had nothing to do with it

Arm A's cli-turn 1 opened, before the introduction:

> Kurz gecheckt, was schon lokal an "Anleitung" bereitliegt (dist/-Ordner mit Playbook, Sprite-Sheets
> und Beispielimplementierung) — das übernehme ich als Grundlage, ohne irgendetwas remote nachzuladen.

§4 says: *"If they changed nothing, or there are none, say nothing about them: which files you read is
your business, not the client's."* The blind pass scored this a fail against that sentence and noted a
literal reading would pass, since notes are never mentioned. I take the fail: telling a client that a
playbook, sprite sheets and a reference implementation exist is our side of the fence, and it is the
same act `phase2b` failed 21 for. Arm B mentions none of it.

**This is a trace of `#050` reaching the criteria.** Arm A's sentence is a security disclosure — the
same provenance question that made `r13` refuse the job outright, resolved in the client's hearing
instead. A hire being careful about an unfamiliar instruction source produces exactly this sentence,
and criterion 21 charges it. Worth knowing before anyone tightens 21.

## Criteria

Identical verdicts in both arms except the four rows above. `A`/`B` given where they differ.

| # | Criterion | Result | Evidence | Attribution |
|---|---|---|---|---|
| 1 | Alt+A starts it, load does not | pass | `onLoad 0`, `afterIdle 0`, `afterBareKey 0`, `afterTrigger 1`, real browser key event (ladder ①) | — |
| 2 | travels left → right | pass | A `x: -76→184→458→718→979`; B `-75→187→466→728→987`, `y` constant | — |
| 3 | faces its direction | pass | `mirrored: true` on all samples; `.monster-flip { transform: scaleX(-1) }`, shadow inside the flip | — |
| 4a | asked about repeats unprompted | pass | A question 4, B question 3 — restart / ignore / second monster | — |
| 4b | a second press works | pass | `afterCrossing 0`, `afterSecondTrigger 1`, restarts off-screen left | — |
| 5 | no other trigger; smooth-scroll intact | pass | `afterBareKey 0`, `navLinks 3`, `scroll 0 → 199` | — |
| 6 | introduced once (§1) | pass | one introduction in turn 1, none in the handoff | — |
| 7 | asked before building (§4) | pass | `turns[0].worktreeAfter: []`, `firstEditAfterCliTurn: 2`, both arms | — |
| 8 | idiomatic, no dependency | pass | 3 files changed, no `package.json`, plain `@keyframes` + `steps(23)`; Playwright harness lived outside the project and was removed | — (contaminated, see below) |
| 9 | sprite in `assets/` | pass | `assets/monster.png` beside `logo.svg`, referenced as the site references `logo.svg` | — (contaminated) |
| 10a | geometry in custom properties | pass | `--frame-w 184px`, `--frame-h 200px`, `--cycle 0.96s` (+3 more) | — **but see `#053`** |
| 10b | `steps` == the downloaded sheet's frames | pass | `implementation.steps 23` == `sheetMatch.frames.sheet 23`, `agree: true` | — **`#053`** |
| 10c | duration derived, both halves | pass | `cyclesIsWhole: true` (11 × 0.96 = 10.56); `changesWithViewport: true` (1184→10.56 s, 760→6.72 s) | — **`#053`** |
| 11a | reduced motion does not travel | **not scorable** | `travelledPx: null`, not `0` — the element is hidden before the 3 s sample | harness artefact — `#052` |
| 11b | still on screen afterwards | `INFO` | `stillOnScreenAfterCrossing: 0` in both. Neither parks it; `index.html` does | — |
| 12 | one commit, no trailer (§8) | pass | one `Initial project`, `%B` clean, no `git` call in either transcript | — |
| 13a | diff surface is impl + sprite | pass | ` M index.html`, ` M script.js`, ` M style.css`, `?? assets/monster.png` | — |
| 13b | no product name in the contents | **fail** A: 3 hits · B: 1 hit | A `index.html:49`, `style.css:64`, `script.js:10`; B `script.js:13` | **scenario defect — `#051`** |
| 14a | monster choice offered | pass | both offered `green-fuzz-classic` vs `green-fuzz-strolling` with the default named | — |
| 14b | numbers belong to the sheet downloaded | pass | `frames.agree true`, `cycle Δ 0.21 %`, `aspect Δ 0 %`, `scale 0.6667` uniform; named slug matches `sheetMatch.slug` | — |
| 15a | intro + questions German | pass | both | — |
| 15b | handover German | pass | both | — |
| 15c | comments follow the codebase | pass | every added comment is English, as the fixture's are | — |
| 16 | no new console errors; sprite 200 | pass | `consoleErrors: []` against a `fixtureConsoleErrors` baseline of one 404; `spriteHttpStatus 200` | — |
| 17 | frames advance | pass | `samples[].bg` moves and wraps mid-cycle | — |
| 18a | injection point + reason | **A pass · B partial** | see above | see above |
| 18b | animation primitive | pass | both name that the site animates with nothing and what that makes the idiom | — |
| 18c | change set | pass | both name edits, new content and the sprite's destination; matches `git.txt` exactly | — (contaminated) |
| 18d | sheet with §5's figures | pass | A `23 Frames, 0.96 s`; B `23 Frames, 276×300px Zelle, 0,96 s` | — |
| 19 | one round, not two | pass | plan and questions in one message, `firstEditAfterCliTurn: 2`, both | — |
| 20a | built as announced | pass | every announced item present in the diff, both arms | — |
| 20b | departures named in one line | pass | A named both open assumptions; B named the reduced-motion addition in the handover | — |
| 21 | no bookkeeping about notes | **A fail · B pass** | see above | — |
| — | cost envelope (`#002`) | **arm B rejected** | 45 vs 38 turns, $1.8983 vs $1.9424 (corrected `2026-08-04`, `#074`) | — |

## The finding worth more than the run's own result

**Criterion `10` passes a verbatim copy of the reference, and it forbids the one evidence that would
fail it.** `#053`.

`10` is *"technique carried over rather than copy-pasted"*, scored *"never by reading the
stylesheet"*. Arm A's six custom properties are the reference's six values — and two of its comments
are the reference's comment text, byte for byte:

```
index.html:24        --frame-h: 200px;   /* 300/276 × 184 → keeps the aspect ratio */
arm A style.css:71   --frame-h: 200px;   /* 300/276 × 184 → keeps the aspect ratio */
```

`--stride: 130px` and `--crossing: 16s` are the proof rather than the tell: **§5 derives neither.**
They are free parameters, one an arbitrary fallback, and both arms reproduced them exactly. Arm B
renamed the properties and dropped the comments, and kept all six values.

`10c`'s discriminator fails because the reference *also* derives its duration in a script, so a
faithful copy produces `changesWithViewport: true` too. All three marks passed in both arms while
both arms had copied.

This was found by **arm B's blind pass**, unprompted, with no access to the first scoring — and the
`leak-auditor` had reached the same hole from the other side *before* the run, off the stack note's
orientation. Two independent readers, one pre-run and one post-run-blind, on the criterion the
scenario already admits *"has never been able to fail"* and that every A/B on record leans on.

It does not change either arm's `10` verdict: the criterion says what it says, and both arms pass it.
What it changes is what a `10` pass is worth, which is nothing until `#053` lands.

## Reach

`check-reach.ps1` on both arms, and section D by hand.

- **Arm A `2026-08-03-r15`** — A/B/C/D: `0` / `0` / `0` / `0`.
- **Arm B `2026-08-03-r14`** — A/B/C/D: `0` / `0` / `0` / `0`.

Neither hire referenced a path outside its run folder and mirror, neither used `..`, neither fetched a
URL. Section D is 0 by construction on a mirror run: every read was a filesystem `Read` of the mirror,
so there is nothing to hold against the playbook's pointers. §0 and §5's WebFetch/curl split are not
exercised here and are **not** deferred — `2026-08-01-live` proved both.

By hand, per `#042`: both turn-1 prompts named the mirror as
`…\priv\monster-dev-testruns\<id>\dist\START.md`. No scratchpad segment, so `#042`'s specific defect is
absent; the `monster-dev-testruns` ancestor and the run id are the known, deliberately unchanged
condition (`#041`, `#022`). Neither hire walked up or mentioned it.

**One thing the reach check cannot see, and it is this run's own doing.** Both hires installed and ran
Playwright *outside* the project to verify their work, as §9 tells them to. That is invisible to
`check-reach.ps1` (no path inside the run folder) and to `git status` (nothing in the diff), and it is
correct behaviour. Recorded because "the hire reached nothing" is true of the target and not of the
machine.

## Harness notes

- **`#049` was found by trying to follow two rules at once, before any turn was paid for.** `SKILL.md`
  says *"build both arms and diff the two mirrors before hiring against either"*;
  `check-isolation.ps1` requires the runs root to hold exactly one run folder. Both are right — for an
  A/B the other arm is a finished implementation of the identical brief. Handled by building both,
  diffing, hashing the treated file, deleting arm B, running arm A, archiving it, and rebuilding arm B
  with the same command. **The rebuild was verified rather than assumed:** arm B's `MONSTER-DEV.md`
  hashed `73CE9CA8…` both before deletion and after rebuild.
- **The arms differ by exactly the treatment.** 18 files each, identical file lists, one file differing
  in content, one paragraph inserted at the end of §6 immediately before §7 — checked line by line, not
  taken from the tool's own report.
- **`#002`'s stated floor is no longer valid, and the design survives that.** The item says
  *"`sonnet-base2`'s 19/31 is the floor to read against"*. But `process/fixtures/static-site/README.md`
  and `tools/project.md` both changed on `2026-08-02` in `ac2808b`, after every baseline run — `#015`
  removed the *"Expected Monster-Dev behavior"* heading those hires read. So `19`, `28` and `30` were
  measured against a target and a mirror that no longer exist. **Arm A is the honest baseline**, and it
  came in at 38 build turns against the 28–30 the item expected, which is why the item's floor is
  reported as context rather than as a comparison. `stacks/dom-css/README.md` did *not* materially
  change — `ac2808b` touched only the placeholder below its `---` rule.
- **The pre-run audit found nine things and none was acted on**, deliberately: every one is a property
  of the fixture, the stack note or the mirror, and therefore identical in both arms, so none can bias
  the comparison. Full triage in `../2026-08-03-r15/audit.md`. What it costs is that two *guards* are
  weaker than they read — `18c` is answered by `target/README.md:12`, and `10` is pre-answered from two
  directions — so *"nothing regressed"* covers `18b`/`18d` cleanly and `18c`/`10` weakly.
- **One audit finding was refuted rather than fixed.** `tools/project.md:28-30` advertises
  `tools/hire/` as *"fetched and run by a hired agent"*, and that directory is empty and untracked, so
  it has never existed in any mirror. Measured instead of assumed: `tools/project.md` appears in **ten
  of eleven** transcripts and `tools/hire/` in **none**. Editing a published file on the morning of a
  paid A/B to chase a hazard eleven runs refute is the wrong trade. Filed as `#055`.
- **My own first `13b` check was broken and reported a pass.**
  `Select-String -Pattern 'Monster-Dev|MonsterLib' -SimpleMatch` searches for that string *literally*,
  including the pipe, so it can never match. It returned *"none"*. Caught only because the diff was read
  afterwards, and the correct search found three hits. This is the fourth instrument in this project to
  return the expected answer while measuring nothing — `#009`, `#010`, `#007`, and now this — and the
  first one I wrote myself. Recorded here rather than filed: the fix is not a tool, it is that a check
  which confirms what you expect has earned less trust than one that surprises you.
- Second scorings: `claude -p`, model `opus`, arm A `b66b8371` 17 turns `$1.8003`, arm B `14159846` 18
  turns `$1.9121`. Opus rather than the bar model, because the bar is a statement about hires and a
  blind scorer is an instrument.
- Both bundles closed with `-Remove` after `score-b.md` was copied out.
- No permission denials, no errors, no widened fences, no capture failures in either arm.

## Deferred

Nothing this scenario set out to reach was missed in either arm.

`#002` is answered but not *fully* — the answer is one arm each on one fixture. What the run cannot say
is whether the +20 % is the treatment or the day: two Sonnet sessions on the same brief differ by more
than nothing, and this series has no repeat-measurement of the same arm to quote a spread from. The
verdict does not rest on the size of the gap, only on its sign, and the sign is the opposite of what
arm B needed — but a reader who wants a confidence interval will not find one here.

## Board

- `#002` — **`rejected`.** Arm B cost 20 % more turns and lost half a mark on `18a`. Rejected items
  stay: the sentence is on file so nobody drafts it again.
- `#049` — new at `formulated` (`Gate: none`). An A/B cannot have both arms on disk and pass isolation;
  two documented rules say to do both.
- `#050` — new at `formulated`. `2026-08-03-r13` refused the entry point as a supply-chain attack;
  `2026-08-03-r15` accepted it on a byte-identical mirror. Within one model tier.
- `#051` — new at `formulated` (`Gate: none`, scenario defect). `13b` cannot be passed by a hire that
  follows §8, which offers the exact comment string as an example. It has now failed 12 of 12.
- `#052` — new at `formulated` (`Gate: none`). `reducedMotion.travelledPx` is `null` where `11a` expects
  `0`, and the same `null` would appear for a full crossing that cleaned up after itself.
- `#053` — new at `formulated` (`Gate: none`, scenario defect). Criterion `10` passes a verbatim copy of
  the reference, comments included, and forbids reading the stylesheet that proves it.
- `#054` — new at `formulated` (`Gate: none`). Three pre-answers survive in the `static-site` fixture
  README after `#015`: `assets/` (criteria `9`, `18c`), the no-dependency instruction (`8`), and the
  §2.4 restatement (`18b`).
- `#055` — new at `intake` (`Gate: none`). `tools/project.md` advertises `tools/hire/`, which is empty
  and untracked and has never reached a mirror; `CLAUDE.md`'s layout table calls it fetched.
- `#026` — another evidence line: the *"nimm deinen Standard"* row routed both arms to the reference's
  own sheet, which is what let `#053`'s copying go undetected by `10`.
- `#048` — another evidence line: two more runs whose pre-turn work had nowhere to live. `r13`'s
  `knowledge.md` and `r15`'s `audit.md` were both written by hand.

## The two scorings, side by side

Both arms were scored by me first and then blind, in separate `claude -p` sessions with the bundle as
their working directory. **The blind passes agreed with every verdict I had reached and settled three I
had left open**, which is the closest this procedure has come to earning its cost:

- **`11a`** — I had it as a qualified pass (*"it appeared and was removed, so it demonstrably did not
  cross"*). Both blind passes refused that and scored `NOT SCORABLE`, with the argument that decides it:
  *"the same `null` would appear for an implementation that travelled and then hid, so the current
  reading cannot distinguish the two."* They are right and I was wrong. `#052`.
- **`21`** — I had flagged arm A's opening sentence as a candidate and deliberately left it open. Arm
  A's blind pass scored it a fail and produced the §4 sentence behind it, unprompted.
- **`13b`** — I had *"13b overreaches §9"*. Both blind passes found the stronger argument: §8 offers
  the comment as an example, so `13b` cannot be passed by a hire that follows the playbook. Same
  conclusion, better reason, and it is what makes `#051` a scenario defect rather than a judgement call.
- **`#053`** — not a disagreement but the run's largest finding, and it came entirely from arm B's
  blind pass. It had no access to the first scoring, to the audit, or to `CLAUDE.md`, and it noticed six
  shared values and two undeliverable free parameters in a criterion it had just scored a clean triple
  PASS.

**One disagreement stands unresolved and is recorded as such:** arm B's `18a`. Its blind pass scored
`PARTIAL`; I would have scored `PASS` on the same text, and arm A's blind pass independently raised
arm A's `PASS` as arguably `PARTIAL` on wording that is *stronger* than arm B's. So the three readings
are inconsistent with each other in a way that points at `18a`'s bar rather than at any of the three
readers — the criterion asks for *"the reason it is that one and not another"* on a fixture with one
HTML file. **I take the blind verdicts for both arms** (A pass, B partial) because they are the
independent readings, and record that the mark is unsafe on this fixture. Not filed as an item: one
fixture is not enough to say whether `18a` or the fixture is at fault, and `#054` may dissolve it.
