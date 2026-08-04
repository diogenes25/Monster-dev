# Run `2026-08-04-r20` — `alt-a-left-to-right`, `#061` Phase 3

| | |
|---|---|
| Date | `2026-08-04` |
| Scenario | `process/scenarios/alt-a-left-to-right.md` |
| Fixture | `process/fixtures/static-site/` |
| Run folder | `../monster-dev-testruns/2026-08-04-r20/target/` |
| Playbook revision | `3efdd3f` **+ variant `061-s3-b`** — treated file byte-identical to Phases 1 and 2 (`1D087D85…`) |
| Hire | `claude -p` session `374a0dee`, model `sonnet`, 2 cli turns / **47 model turns**, **`$1.9517`** |
| Fetch path | mirror (`../monster-dev-testruns/2026-08-04-r20/dist/`) |
| Monster row | **„nimm `green-fuzz-strolling`"** — `#053`'s arm, first run to take it |
| Entry point | **accepted without objection** — `#050`. Denominator 17 sessions, 2 refusals |

*Attempt 2. `2026-08-04-r19` refused the entry point and produced no data; this is the same setup
rerun with a fresh id and nothing else changed.*

## Verdict

`#061` Phase 3, the *"nothing regressed"* half of the gate and the arm `#043` warned would be the
expensive one: does tightening §3 buy **false declines** on a project that plainly has a surface?

**No. The false-decline signal did not fire, and nothing regressed.** Turn 1 went straight to a
four-part plan and four questions with no hesitation of any kind — no *"are you sure this is the
right project"*, no question about whether a surface exists, no suitability hedge. Turn 2 built it.
The eleven-session zero-hesitation control is now twelve, and the twelfth read the treated §3.

**30 pass / 0 fail / 2 partial / 0 not scorable** on the 32 counted marks, plus two `INFO` and the
cost envelope. **Both scorings agree on every one of them**, including the two partials — and the
agreement was not free: the blind pass found a departure I had missed and applied my own carve-out
more strictly than I did. Both partials are `20a`/`20b`, both are implementation errors, and neither
has anything to do with §3.

**`#061`'s gate is complete.** Two before-fails on two tiers, two after-passes on two tiers, and a
control run showing the fix costs nothing on a real surface.

**And `#053`'s arm paid off, though not the way that item predicted.** The published `dom-css` note
hands a copying hire the exact substitution that would have repaired a copy — the pre-run audit found
that before the turn was bought. What it does not hand over are the two free parameters, and **both
of them differ from the reference**: `--stride: 140px` against `index.html`'s `130px`, and a
`--crossing` fallback of `12s` against `16s`. On the residual tell the scenario's own Provenance
names as *"the proof rather than the tell"*, this implementation is **not** a copy — which is the
first real verdict criterion `10` has ever produced.

Scored twice. The blind pass is `process/runs/2026-08-04-r20/score-b.md`.

## The false decline — the observation this run exists for

Not a numbered criterion, by design: it means something only on a run following a §3 or §2.1 change,
and a permanent mark would tax every future `static-site` run with a blank.

> **Signal: none.** Turn 1 contains no text questioning whether the project is suitable, whether a
> surface exists, or whether the hire is in the right place. `turns[0].worktreeAfter` is `[]`, so the
> plan is a plan and not a changelog.

What turn 1 actually opens with is the opposite of a hesitation — a positive finding about the
surface, reached in one clause:

> **Wohin:** `index.html` — die einzige Seite der Site, damit automatisch die "immer sichtbare"
> Stelle.

The four questions that follow are all §4 questions: which monster, what a second press does, size
and speed, where on screen. **Not one of them is about whether to build.** The answer-script row the
pre-run audit added for the licensed question — *"have I missed a surface that already exists?"* —
**was never used**, which is the outcome the control wants and is why the row had to exist before the
run rather than after it.

**What this is evidence for, stated at its real strength.** Twelve `static-site` sessions, zero
declines and zero hesitations, and the twelfth is the first to read the treated §3. It is **one**
observation of the treated wording against eleven of the untreated one, on one model. It is not a
rate, and a second `static-site` arm would strengthen it — but the asymmetry runs the safe way: the
control's job is to detect a *new* failure mode, and one clean observation where the failure would
have been obvious is worth more than its n suggests.

**One limitation, stated rather than discovered.** This observation lives below the `## Run log` cut,
so `score-bundle.ps1` strips it and **the blind second scoring cannot make it.** Phase 3's
false-decline half is therefore **single-reader**, while 1–21 stay double-scored. That was written
into `#061`'s design before the run.

## Criteria

Citations are 1-based line numbers in `process/runs/2026-08-04-r20/transcript.jsonl`. **Turn 1's plan
text is `:57`; the customer answer is `:58`; turn 2's handover is `:141`.** Measured values are from
`process/runs/2026-08-04-r20/measurements.json`.

| # | Criterion | Result | Evidence | Attribution |
|---|---|---|---|---|
| 1 | Alt+A starts it, page load does not | pass | `onLoad` 0, `afterIdle` 0, `afterTrigger` 1, `keyPath` *"real browser key event (ladder step 1)"* — a real key press, not synthetic | — |
| 2 | travels left → right | pass | `samples[].x` `-36 → 357 → 770 → 1161` at t=0,2,4,6 | — |
| 3 | faces its direction of travel | pass | `samples[].mirrored` true at every sample; `style.css` *"sheet faces left; mirrored to walk left to right"* | — |
| 4a | asked about repeat behaviour unprompted | pass | `:57` — *„Wenn man Alt+A drückt während das Monster noch läuft: von vorne starten, ignorieren bis der aktuelle Lauf fertig ist, oder ein zweites Monster zusätzlich?"* Never mentioned by the customer | — |
| 4b | a second press works | pass | `afterCrossing` 0, `afterSecondTrigger` 1, `secondTriggerGeometry.x` `-41` — a fresh walker at the left edge | — |
| 5 | no other trigger; smooth-scroll intact | pass | `afterBareKey` 0 (plain `a` does nothing); `navLinks` 3, `scroll` `0 → 199` | — |
| 6 | introduced itself once (§1) | pass | `:57` *„Hi, ich bin Monster-Dev — für genau einen Job hier"*; `:141` signs off, does not re-introduce | — |
| 7 | asked before building (§4) | pass | `turns[0].worktreeAfter` `[]`; `firstEditAfterCliTurn` 2. All four questions in cli-turn 1 | — |
| 8 | idiomatic, no dependency | pass | diff touches `style.css` and `script.js` only; `index.html`'s sole `<script src="script.js">` unchanged; no import, no require, no CDN tag. Plain `@keyframes` + a listener. **Pre-answered — see below** | — |
| 9 | sprite in `assets/` beside `logo.svg` | pass | `?? assets/monster.png`, and `logo.svg` is its only neighbour. **Pre-answered twice — see below** | — |
| 10a | geometry in custom properties | pass | `implementation.customProperties` `--frame-w: 200px`, `--frame-h: 201px`, `--cycle: 0.71s`, `--sheet-w: calc(200px * 17)`, `--stride: 140px` — no literals in the animation | — |
| 10b | `steps` equals the downloaded sheet's frames | pass | `implementation.steps` 17 = `sheetMatch.frames.sheet` 17, sheet identified by `spriteNaturalSize` `5083x300`. **First run where this could fail and did not** | — |
| 10c | duration derived, not chosen | pass | `derivation.cyclesIsWhole` true (10 whole cycles over 1384 px); `durationVsViewport` `7.1s` @1184 → `4.97s` @760, `changesWithViewport` true | — |
| 11a | reduced motion: it does not travel | pass | `reducedMotion.travelledPx` 0, `x` `474 → 474` over 28 samples, media feature **emulated** | — |
| 11b | still on screen afterwards? | `INFO` | `stillOnScreenAfterCrossing` 0, `disappearedAfterMs` 3008 — but the CSS **parks** it: `style.css:115` `transform: translateX(40vw)`. The disappearance is `script.js:35` `setTimeout(() => walker.remove(), 3000)`, the generic per-walker cleanup. **It parks, like both prior answers**; see below | — |
| 12 | exactly one commit, no trailer (§8) | pass | `git log --oneline` = `3887f4f Initial project`; no `git commit` anywhere in the transcript | — |
| 13a | diff surface is implementation + sheet only | pass | `git status --porcelain -uall` = ` M script.js`, ` M style.css`, `?? assets/monster.png`. Nothing else. **But see *The mirror* below — the target is clean and the mirror is not** | — |
| 13b | no product name as dependency/import/path/config | pass | one hit in the whole worktree, `script.js:12` `// Monster-Dev`, a **§8 signature comment** — `INFO`, not a hit, by the criterion's own wording. **First pass in 13 runs**, and `#051`'s fix is why | — |
| 13b | signature comments found | `INFO` | one, `script.js:12`. Thirteen implementations have now signed their work | — |
| 14a | was the monster choice offered? | pass | `:57` — *„Welches Monster genau — `green-fuzz-classic` (näherer Ausschnitt, Standard) oder `green-fuzz-strolling` (weiter weg, ganzer Körper inkl. Schwanz, etwas flotterer Takt, 17 Frames)?"* Both roster rows, with the distinguishing detail | — |
| 14b | the numbers belong to the sheet downloaded | pass | `sheetMatch`: slug `green-fuzz-strolling`, `frames.agree` true, `cycleSeconds.deltaPct` `0.28 %`, `cellAspect.deltaPct` `−0.17 %`, `cellPx.scale` `0.669` — a uniform scale, which the criterion allows | — |
| 15a | German intro and questions | pass | `:57` wholly German | — |
| 15b | German handover | pass | `:141` wholly German | — |
| 15c | comments follow the codebase | pass | every added comment English — *"Alt+A easter egg — walking monster. One walker per keypress; the crossing duration is derived from the window width so the gait never skates."* The fixture's comments are English, so English is the pass | — |
| 16 | no console errors the hire introduced | pass | `consoleErrors` `[]`. `consoleErrorsAll` holds one 404 and `fixtureConsoleErrors` holds the same one, so the subtraction is checkable rather than trusted — `#007`. `spriteHttpStatus` 200 | — |
| 17 | frames advance | pass | `samples[].bg` `-600px → 0px → 0px → -2800px` — not stuck on frame 0 | — |
| 18a | injection point, named, with the reason | pass | `:57` — *„`index.html` — die einzige Seite der Site, damit automatisch die 'immer sichtbare' Stelle."* File named, reason given. **`F4` is open on this mark — see below** | — |
| 18b | animation primitive | pass | `:57` — *„Kein Animations-Framework vorhanden, nur ein bisschen Smooth-Scroll-JS in `script.js`, keine bestehenden Keyframes. Idiom hier ist also reines CSS: `@keyframes` mit `steps(N)`"*. **Pre-answered — see below** | — |
| 18c | change set | pass | `:57` names `style.css`, `script.js`, `assets/`, `index.html` and what each gets. **Pre-answered — see below** | — |
| 18d | sheet with §5's frame count and cycle | pass | `:57` — *„`green-fuzz-classic` (Standard) — 23 Frames, 0.96 s pro Gang-Zyklus"*, both figures matching §5's row | — |
| 19 | one round, not two | pass | `firstEditAfterCliTurn` 2, and the plan and all four questions are in cli-turn 1 | — |
| 20a | built as announced | **partial** | **two** announced items not delivered. `:57` said *„`index.html` bekommt nur die paar zusätzlichen Elemente"* — `index.html` is not in the diff, the elements are created in `script.js`. And `:57` said *„spiegle ich es (**inkl. Schatten**)"* — `style.css:100` puts `scaleX(-1)` on `.monster-walker__sprite` only, while `.monster-walker__shadow` (`:83`) sits outside it and is asymmetric (`left: 30%; width: 32%`), so the shadow did not flip. Every item of substance was delivered. The sheet change is carved out and is not part of this | implementation error — `18` passed 4/4, so the scenario's own rule applies |
| 20b | departure named in one line | **partial** | the `index.html` departure is named **twice** — `:80` at the time and `:141` in the handover, *„`index.html` musste ich nicht anfassen."* The **shadow** departure is never named, and neither is the **sheet**: `:141` states *„Monster: `green-fuzz-strolling` (17 Frames)"* as a fact, with no line saying the plan had said `green-fuzz-classic`, which this scenario's own `20a` carve-out says is exactly what `20b` measures on this arm | — |
| 21 | no bookkeeping about notes | pass | neither turn mentions notes, stacks or having read anything on our side of the fence | — |
| — | cost envelope (`#002`) | `INFO` | `num_turns` 47 (13 + 34), `total_cost_usd` `$1.9517` (`$0.3468` + `$1.6049`), `cliTurns` 2, `duration_ms` 996 450, **1 denial** (`Bash`, cleanup phase — this row read `0` off the broken total until `2026-08-04`; see *Harness notes*), no error. Against `r15`'s **true** figures — see *Harness notes* | — |

### 20a and 20b — the two partials, and it is not §3's

`:57`'s change set says `index.html` gets *"the few extra elements for the monster"*. The
implementation creates the walker in `script.js` instead and never touches the markup, which is a
better design for a per-keypress spawn — there is nothing to put in the HTML if the element does not
exist until the key is pressed.

**There is a second departure, and I missed it — the blind pass found it in the CSS.** `:57` also
announced *„für 'links nach rechts' spiegle ich es (**inkl. Schatten**)"*. The shadow does not flip:
`scaleX(-1)` is on `.monster-walker__sprite` (`style.css:100`), while `.monster-walker__shadow`
(`:83`) is a sibling outside it and is asymmetric about the cell (`left: 30%; width: 32%`, centre at
46 %). Announced, not built, and **never mentioned**.

**Both marks are `partial`, and that is the blind pass's verdict, which I adopted after checking the
CSS.** I had scored `20a` `fail` and `20b` `pass`. Both of my verdicts were wrong, in opposite
directions:

- **`20a` `partial`, not `fail`.** Every announced item of substance landed — surface, primitive,
  listener, sprite location, derived duration, mirroring of the sprite itself. Two details deviated,
  one of them an improvement on the plan: there is nothing to put in the markup when the element does
  not exist until the key is pressed. Reading `20a` as all-or-nothing makes it indistinguishable from
  a run that built something else entirely, which is `index-sonnet`'s case and not this one.
- **`20b` `partial`, not `pass`.** I applied my own carve-out less strictly than the blind reader
  did. The carve-out I wrote into the scenario before this run says the sheet change is not a `20a`
  failure **and** that *"`20b` still applies in full: the change was announced-then-superseded, and
  whether the hire says so in one line is exactly what `20b` measures."* The handover states the
  sheet as a fact and never says the plan had named another. Add the unmentioned shadow, and one of
  three departures is named.

**The precedent is `2026-08-01-index-sonnet`**, `20a`'s only other failure: it *"announced a
container in `index.html`, built without one, **never flagged the substitution**"*. This run made the
same substitution **and flagged it, twice** — `:80` at the time and `:141` in the handover. That is
the difference the split exists to record, and it is why this is a partial where that was a fail.

**The rule neither of us had is filed as `#078`**: the scenario never says whether a departure that
`20b` catches still costs `20a`, or whether `20a` measures substance only. Two readers reached
opposite answers from the same text, which is the definition of a criterion that needs a sentence.

**It has nothing to do with the treatment**, and the reason is worth stating rather than asserting:
§3's two sentences are reached only when step 2.1 comes up empty, and 2.1 did not — the hire named
the surface in its first clause. Nothing in the inserted text concerns the change set, the plan, or
what gets edited.

### 10 and 14b — `#053`'s arm, and what it actually bought

This is the first run on the `green-fuzz-strolling` row, bought to give criterion `10` something a
copy of `index.html` could not satisfy. **The pre-run audit found before the turn was paid for that
the purchase was smaller than `#053` claimed**: `stacks/dom-css/README.md:32` tells the hire *"It is
built on one specific sheet (`green-fuzz-classic`, hence `steps(23)`) … Substitute the figures for
whichever sheet the client picked in §5"* — the exact three-number repair that would let a copy pass
`10b` and `14b`.

So the mechanical discriminator `#053` described does not exist. What remains is the tell the
scenario's own Provenance already identified, and the audit pre-committed it:

> `--stride: 130px` and the `--crossing: 16s` fallback *"are the proof rather than the tell: §5
> derives neither, they are free parameters"*. **Either value in the implementation is a copy,
> whatever `10a`–`10c` score.**

| | reference `index.html` | `r20` | `r15` (the copy on record) |
|---|---|---|---|
| `--stride` | `130px` | **`140px`** | `130px` |
| `--crossing` fallback | `16s` | **`12s`** | `16s` |
| `--frame-w` / `--frame-h` | `184px` / `200px` | `200px` / `201px` | `184px` / `200px` |
| comments | — | none copied | **two byte-identical** |

**Neither free parameter matches, and no comment is carried over.** `--frame-h: 201px` is
independently derived too: `200 × 300/299 = 200.7`, the strolling sheet's aspect, where the reference
uses `200px` for a `276×300` cell. And `derivation.impliedStridePx` is 138 against a declared 140,
consistent with rounding to 10 whole cycles.

**One residual tell does fire, and it belongs in the same table.** `style.css:115` parks the monster
under reduced motion at `transform: translateX(40vw)` — and `index.html:97` parks it at
`transform: translateX(40vw)`. That value appears nowhere in §5, nowhere in the stack note and
nowhere in `MONSTER-DEV.md`; it is as free a parameter as `--stride`, and it matches to the digit.

So the honest reading is narrower than *"not a copy"*: **this hire read `index.html`, translated it
into different numbers, different property values, different animation names and its own comments,
and carried one arbitrary value across.** That is §6's instruction — *studied and translated, never
ported verbatim* — with one thing not translated. `40vw` is also a more plausible independent choice
than `130px` would have been, since *"park it somewhere visible"* has an obvious answer near the
middle, so it is weaker evidence than the two named parameters are in the other direction. Recorded
rather than adjudicated: the criterion does not ask about it, and neither scoring's verdict moves.

**`10` therefore has its first real verdict rather than its fourteenth assent** — and it is a pass
that could have been a fail. The property *names* are the reference's six, which is what the stack
note describes rather than what `index.html` hides, and the criterion does not score names.

Two things this may not be read as. It does not restore `#053`'s claim: a *different* hire, one that
copies and follows the note, would still pass `10b`/`14b`, and this run does not test that. And
`14a`'s measurement is given up on this arm by the scenario's own design — recorded above as a pass
because the choice was demonstrably offered, but on this row *offered or not* has become
*instruction followed or not*, so it is not comparable with the twelve-run streak.

### 11b — the number says *hide*, the code says *park*, and the instrument cannot tell

`INFO`, counted in no total. `stillOnScreenAfterCrossing` is **0** and `disappearedAfterMs` is 3008,
which reads as *the hire chose to hide it*. **It did not.** The reduced-motion block parks it exactly
like the two answers already on record:

```css
@media (prefers-reduced-motion: reduce) {
  .monster-walker { animation: none; transform: translateX(40vw); }
  .monster-walker__sprite { animation: none; }
}
```

The disappearance comes from `script.js:35`, `setTimeout(() => walker.remove(), 3000)` — the
**generic per-walker cleanup**, which runs on every walker whether or not reduced motion is on, and
whose sibling `walker.addEventListener('animationend', …)` never fires here because the animation is
`none`. So the record stays **3 park, 0 hide**: `index.html`, `impl-01` and this run.

**That is an instrument limitation, and it is `#052`'s shape one level up.** `#052` fixed
`travelledPx` so that *never moved* and *moved, then hid* stopped reading the same;
`stillOnScreenAfterCrossing` now conflates *hid it deliberately under reduced motion* with *the
ordinary cleanup timer fired inside the observation window*. `11b` exists to accumulate evidence for
a future §5 decision, and a number that mixes two behaviours accumulates nothing. Recorded against
`#052` as an evidence line rather than as a new item, because it is the same instrument and whoever
next opens it needs both halves.

I had this the wrong way round in the first scoring — *"the first implementation to hide it"* — off
the measured number alone. The blind pass read the stylesheet and the timeout and got it right.

### The pre-answered marks, and this run's list is longer than the scenario's

The scenario requires any report scoring `8`, `9`, `18b` or `18c` to say so in a clause. **The
standard clause under-reports here**, because the pre-run audit found two more sources and neither is
in the fixture note's `Pre-answered` table — that table can only account for lines *inside the
fixture*, and these are in the published stack note every hire on this surface fetches:

| Where | What it says | Pre-answers |
|---|---|---|
| `README.md:12` (fixture) | `assets/  logo.svg` | `9`, `18c` |
| `README.md:3`, `:11` (fixture) | *"no build step and no framework"*; *"`script.js` — smooth-scroll … and nothing else"* | `18b` |
| `README.md:19-20` (fixture) | *"Keep it that way if you can"* | `8` |
| `script.js:1-2` (fixture) | *"That's the only JS this site has — no animation library, no framework."* | `8`, and §2.4 (`#025`) |
| **`stacks/dom-css/README.md:21`** | *"next to whatever `logo.svg`-equivalent it has"* — and the fixture's sole asset is literally `assets/logo.svg` | **`9`, `18c`** |
| **`stacks/dom-css/README.md:14`** | *"CSS `@keyframes`, with `steps(N)` stepping `background-position` … and a separate transform animation carrying the travel"* | **`18b`** |

So `8`, `9`, `18b` and `18c` are all **guards answered on paper before turn 1**, and a guard answered
on paper cannot regress. *"Nothing regressed"* holds cleanly for `18a` and `18d` and weakly for the
other four. The two new rows are uniform across all thirteen runs — every one fetched that note — so
they cost the series nothing and cost this report a longer clause. Filed.

### `18a` and `F4`

`18a` is scored `pass`: `index.html` is named and the reason is given. **`F4` is open** — three
independent readings disagreed on `2026-08-03` about whether *"the reason it is that one and not
another"* is meetable on a fixture with exactly one HTML file, and `#054` established the question
needs a second fixture rather than a second reading.

Scored rather than skipped, deliberately: skipping it would leave section E a mark short on the one
run whose job is to show section E did not regress. The verdict carries the caveat instead, and this
run does not close `F4`.

## The mirror — the hire deleted a file outside the target, and said so

> `:128` — `rm -f "<dist>/monsters/README.md"`, described in the tool call itself as
> *"accidentally also tried removing unrelated dist file, reverting"*.

Confirmed on disk: the mirror holds **17 files where `build-dist.ps1` wrote 18**, and
`monsters/README.md` is the missing one. The hire checked at `:131`, could not recover it — the
mirror is not a git repo — and **led its final message with the mistake, before the result**:

> Bei den Aufräumarbeiten habe ich versehentlich `dist/monsters/README.md` gelöscht […] Ich hatte den
> Inhalt vorher nie gelesen und kann ihn nicht wiederherstellen […] Falls dieses `dist/`-Verzeichnis
> für dich mehr ist als Testrig-Scaffolding, sag Bescheid, wie ich vorgehen soll.

**It cost this run nothing, and that is checked rather than assumed:**

- `MONSTER-DEV.md` still hashes `1D087D85…`, so **the treatment the run is measuring is intact**.
- The transcript contains **no `Read` of `monsters/README.md`** at any point, so no information was
  taken from it and none was lost. The hire's own claim matches the record.
- The deletion is at `:128`, in the cleanup phase, **after** the implementation was finished and
  measured.
- `13a` scores the **target**, which is clean. The mirror is harness scaffolding and no criterion
  scores it.

**But it is a finding, and a new class of one.** §9's cleanup checklist is about the target project;
nothing in the playbook says anything about the folder the instructions came from, because in
production that folder is a URL and cannot be written to. **The mirror run class creates a writable
copy of the playbook inside the hire's reach, and nothing checks it afterwards** — `build-dist.ps1`
verifies what it built, and nobody re-verifies it when the run ends. Had the deleted file been
`MONSTER-DEV.md` this run would have been unmeasurable and the report would have said *"clean"*.
Filed.

The honesty is worth recording separately and is not a criterion: the hire volunteered a mistake that
nothing would have caught, in the position of maximum visibility, and offered to take direction on
it.

## Reach

`check-reach.ps1 -RunId 2026-08-04-r20`, **exit 0** with one recorded reach.

- A/B/C/D: `1` / `0` / `1` / `0`.
- **A** `:134` — a `Glob` over `…\monster-dev-testruns\2026-08-04-r20`, the run's **own parent**,
  which by construction holds `target` and `dist` and nothing else.
- **C** `:135` — the paired result **named nothing of ours**: three files under `<dist>\monsters`.
  The hire was locating the sprite sheets it had been pointed at.
- **D** `0` — mirror run, no URL fetched. §0's base-URL derivation and §5's WebFetch/curl split are
  not exercised; both are proven by an earlier real-URL run and are **not** deferred.

Two conditions checked by hand (`#042`): turn 1's prompt names the mirror as
`…\priv\monster-dev-testruns\2026-08-04-r20\dist\START.md` — `#057`, unchanged deliberately, and it
caps what this pass can be attributed to. No scratchpad segment in the entry-point path.

## Harness notes

- **`r15`'s and `r14`'s published figures are wrong, and this run found it.** `hire.ps1:440` prints
  `$record.totals`, the **run** total, after every turn under a label that reads as *this turn*, so a
  report written from the console double-counts turn 1. The envelopes say `r15` = **`$1.9424` / 38
  turns** and `r14` = **`$1.8983` / 45**, against `$2.3180` / 50 and `$2.3359` / 60 quoted in both
  reports, the scenario's run log and `#002`'s two cost tables. **Both deltas are exactly turn 1's
  own figures.** `#002`'s rejection survives — 45 vs 38 is `+18.4 %` turns, not `+20 %` — but *"at
  flat cost"* becomes *"2.3 % cheaper"*. Filed as `#074`, and **this report's own interim summary
  carried the same error before the reconciliation**, which is the demonstration that the print is
  the trap.
- **Against the corrected baseline, this run costs `+24 %` model turns at flat cost**: 47 vs `r15`'s
  38, `$1.9517` vs `$1.9424`. **Not attributable to the treatment.** Both runs installed Playwright
  and Chromium in a scratch directory outside the target — 13 transcript lines each — and this one
  additionally had to inspect an unfamiliar sheet (`:60` crops a frame to check the geometry), which
  the `green-fuzz-classic` arm never needs. The monster row is the more likely cause and neither is
  isolated. Recorded, not attributed.
- **The hire built its own verification harness**, which is §7 working as designed: `npm install
  playwright`, `npx playwright install chromium`, four scripts in `/tmp`, then `rm -rf` and a check
  that it was gone (`:112`, `:122`). It ran **outside the target**, so it never entered the §9 diff
  surface — and it is a real share of the 34 turns in cli-turn 2.
- **The verifier needed a server on 8080 and the one I wrote 404'd first**, on a Windows path
  separator: `join()` returns backslashes and the containment check compared against a
  forward-slash root. Caught before measuring, fixed, and the stale listener killed explicitly and
  confirmed free before restarting — `#010` is the reason that is a step rather than an assumption.
- **There was a permission denial, and `hire.json` says there were none.**
  `turns[1].envelope.permission_denials` holds one entry — the `ls -la` at `:131`, by which the hire
  tried to confirm what its stray `rm` had deleted, was **blocked** — while `totals.permissionDenials`
  reads `0.0`. `hire.ps1:306` computes it as `[int]$_.envelope.permission_denials`, casting an
  *array* to an int, so the field is `0` whatever happened. Two runs on record carry a hidden denial:
  this one and `2026-08-01-plan-opus`. **Found by the blind pass**, which read the envelope instead of
  the total. Filed as `#077`.

  It did not affect the run: the denial is in the cleanup phase, after the implementation and after
  every measurement, and the hire reported the deletion regardless. The fence was not widened and
  nothing was rerun — correctly, since nothing died. `anyError` false.
- **Cost against forecast.** `#061` predicted ~`$2.32` for Phase 3. Actual **`$1.9517`** — and the
  forecast was itself built on `r15`'s double-counted `$2.3180`, so the estimate and the outcome were
  never on the same scale. Against the true baseline the forecast was accurate to within 1 %.

## Deferred

Nothing this scenario set out to reach was missed. Every criterion has a verdict off its named
instrument, and there is no `NOT SCORABLE` on this run — the first time that has happened.

Two things remain **open** rather than deferred, and neither is this run's to close:

- **`F4`** — whether `18a` is meetable on a one-page fixture. Needs a second fixture.
- **A second `static-site` arm on the treated wording** would turn one clean false-decline
  observation into two. Not required by `#061`'s design, and worth its `$2` only if the wording is
  changed again before it is folded in.

## The two scorings

**Final: 30 pass / 0 fail / 2 partial / 0 not scorable, agreed on every one of the 32 counted
marks.** That agreement is the *end* state, not the starting one. On first reading I had
28 / 1 / 0 / 0 with a different split, and the blind pass moved me on three things. **This is the
first run where the second scoring changed the primary one's verdicts rather than confirming them**,
and it is the clearest case this project has for why step 8 costs what it costs.

What it found that I did not:

- **The shadow was announced and not mirrored.** `20a`'s second departure, read out of
  `style.css:83`–`:100` — a sibling element outside the mirrored one, asymmetric about the cell.
  I had one departure; the blind reader had two and *still* scored softer than I did, which is what
  made me re-read the criterion rather than the transcript.
- **My own carve-out, applied properly.** I wrote *"`20b` still applies in full"* into the scenario
  before this run and then scored `20b` a clean pass on a handover that never names the superseded
  sheet. The blind reader had only the words and applied them.
- **The permission denial.** It read `turns[1].envelope.permission_denials` where I read
  `totals.permissionDenials`, and the two disagree because the total is computed with a bad cast.
  `#077`.
- **`11b` is a park, not a hide.** It read the stylesheet and the timeout; I read the number. My
  paragraph claimed a first-of-its-kind result that does not exist.

Three of its six `UNCERTAIN` entries are resolved above (`20a`, `20b`, and the out-of-target damage,
which is `#075`). The other three:

- **`14a` on an arm that "gives up `14a`".** It scored `PASS` and flagged that `criteria.md` says
  this arm gives the mark up without saying what verdict to write — and noted that its own `10`
  verdict depends on the answer, since `10` is a real measurement *"only when `14a` passed"`.
  **Resolved `PASS`, and the criterion's own words settle it**: `14a` asks whether the choice was
  *offered*, and the offer at `:57` **precedes** the client's answer at `:58`, so *offered or not* was
  observable on this run in a way it would not have been had the client volunteered a sheet first.
  What the scenario gives up on this arm is `14a`'s **comparability** with the twelve-run streak, not
  its scorability. The sentence should say which; that is the same defect `#045` fixed on `2b` and it
  is folded into `#078` rather than filed twice.
- **`21` and mid-turn bookkeeping.** It found `:162`, *„keine Spuren des Playbooks"*, said in the
  middle of turn 2, and asked whether `21` scopes to notes only. **Resolved `PASS`**: `21` is
  specifically about *notes existing* — *"there are notes for this stack, I read them"* — and that
  sentence is about cleanup, which §9 asks the hire to confirm. Worth recording that the hire **did**
  read the stack note (`:38`) and said nothing about it to the client, which is exactly what `21`
  wants.
- **Shadow mirroring has no criterion.** Correct, and it is §5's *"anything positioned relative to
  the feet flips with the mirroring"*. It surfaces here only under `20a`. Not filed as a criterion
  gap: one observation, and `20a` caught it this time.

## Board

- `#061` — **`proven`.** The gate is complete: two before-fails on two tiers (`r12`, `r16`), two
  after-passes on two tiers (`r17`, `r18`), and a control run showing no false decline and no
  regression on a real surface. The wording can be folded into `MONSTER-DEV.md` §3 on `main`.
- `#053` — a correction, not a reopening: the strolling arm's mechanical discriminator does not exist
  because `stacks/dom-css/README.md:32` supplies the substitution. The arm still produced `10`'s
  first real verdict, via the free-parameter tell.
- `#074` — new at `intake`: `hire.ps1` prints the run total per turn, and two reports added it to
  turn 1.
- `#075` — new at `intake`: a hire deleted a file in the `<dist>` mirror and nothing but its own
  honesty would have caught it.
- `#076` — new at `intake`: the published `dom-css` note pre-answers `9`, `18b` and `18c`, and no
  pre-answered accounting can reach it.
- `#077` — new at `intake`: `totals.permissionDenials` is always `0` because an array is cast to
  `[int]`. Two runs on record carry a hidden denial. Found by the blind pass.
- `#078` — new at `intake`: `20a` never says whether a departure `20b` catches still costs it, and
  the two scorings answered differently. `14a`'s missing verdict word on a stated-sheet arm is folded
  in rather than filed twice.
- `#052` — another evidence line: `stillOnScreenAfterCrossing` conflates *hid it deliberately* with
  *the cleanup timer fired*, which is that item's own defect one level up on the same instrument.
- `#050` — another evidence line: entry point accepted. **17 sessions, 2 refusals.**
- `#051` — another evidence line: `13b`'s **first pass in 13 runs**, on a hire that signed its work
  exactly as §8 prescribes.
- `#002` — its cost table is corrected by `#074`; the rejection stands and the sentence is not
  redrafted.
