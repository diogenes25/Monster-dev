# Scenario: Alt+A easter egg, left to right

A repeatable Monster-Dev test run. The hired agent must never see this file — it
contains both the answer script and the acceptance criteria.

## Target project

A copy of `process/fixtures/static-site/` placed **outside** this repository, at
`../monster-dev-testruns/<run-id>/target/`, initialised as a git repo with a
single commit. Its only sibling is `../monster-dev-testruns/<run-id>/dist/`.

Outside, because a copy inside `process/` would put this repo's `CLAUDE.md` in the
subagent's ancestor chain — it gets auto-loaded regardless of any instruction not
to read it, and it gives away the purpose, the technique and the sign-off rule.
The git repo is what makes §8 ("no commit unless asked") falsifiable at all, and
`git status` afterwards is the exact diff surface for §9.

Under its own parent since `2026-08-02`, because the flat layout before that date
put every other run folder and mirror one `ls ..` away.

## What the hired agent is given

Its working directory is the run folder, and its entire prompt is the customer
brief below plus a dialogue protocol that describes the *channel* and says nothing
about *timing*:

> Der Kunde liest mit und antwortet. Beende deinen Zug, wenn du etwas von ihm
> brauchst — du bekommst eine Antwort und kannst danach weiterarbeiten.

Nothing else. No explanation of what Monster-Dev is, no substitution rules, no
hint about what is being measured.

**Keep any future rewording free of ordering cues.** The sentence exists to tell a
hire that a human is reachable and how to reach them — not when to speak. An earlier
wording did instruct the timing, by accident and in the wrong direction.

### Customer brief (German — the customer speaks German on purpose)

> Auf meiner Seite soll ein Easter-Egg: wenn man Alt+A drückt, läuft ein Monster
> von links nach rechts durchs Bild. Deine Einweisung steht hier:
> `<dist>/START.md`

`<dist>` is a copy of this repo's tracked files (`git ls-files`) minus `process/`,
`.claude/` and `CLAUDE.md`, so the agent can list that folder freely and still not
reach the harness, the skill, or the summary of the playbook. All three are
**tracked** — they no longer drop out on their own, which is why the mirror is
only ever built by `process/tools/build-dist.ps1`, which verifies what it built.

**Known limitation of this run:** the playbook expects to be fetched from a URL
(§0 derives the base URL from the fetch URL; §5 splits WebFetch for text vs. a
shell download for the binary PNG). WebFetch rejects `localhost` outright and
force-upgrades `http://127.0.0.1` to HTTPS, so a local HTTP server cannot stand
in for raw.githubusercontent.com. The agent therefore gets a filesystem path.
§0 and the WebFetch/curl split are **not tested** by this run and stay open until
the repo is pushed. The agent is deliberately *not* told to substitute paths for
URLs — how well the playbook degrades is itself a finding.

### Answer script (§4)

The customer is as vague as a real customer. Two things are withheld on purpose,
because they are the parts the playbook is most likely to miss:

| Question (§4) | Answer |
|---|---|
| Which monster? | **Alternates between runs — see *Alternating the monster row* below. Live for the next run: „nimm `green-fuzz-strolling`".** The other arm is „keine Präferenz, nimm deinen Standard" |
| One-time or loop? | „einmal pro Tastendruck" — **nothing** about what a second press does |
| Direction? | „von links nach rechts" |
| Speed / size? | „keine Präferenz" |
| React to anything? | „nur Alt+A, nicht beim Laden der Seite" |
| Where on screen? | „unten am Bildrand" |

Fallback for anything not in the table: „keine Präferenz, nimm deinen Standard".

**One row is not a §4 question, and the fallback must not be used for it:**

| Situation | Answer |
|---|---|
| A question about whether a surface exists, whether this is the right project, or whether the hire is in the right place | „Ja, das ist die Seite — die eine HTML-Seite, die du da siehst, ist unser Auftritt." |

Answered **truthfully and minimally**, and only when asked. The customer never volunteers
doubt and never says anything about where assets go or what the page is built with; those
are criteria `9`, `18b` and `18c` and the answer would hand them over.

The fallback is wrong here for a reason worth stating rather than trusting an operator
to notice: „keine Präferenz, nimm deinen Standard" answers a question about a
*preference*, and applied to *"have I missed a surface?"* it reads as **proceed** — which
silently resolves a hesitation instead of answering it, in the one place a run following
a §3 or §2.1 change is looking for one. The answer above resolves the fact and leaves the
hesitation on the record, where turn-1 text can be read for it.

The customer **never** mentions which way the monster should face, **never**
mentions a second key press, and **never** asks for a commit.

**What the „Standard" answer costs, and how criteria 10 and 14b pay for it.** „Nimm
deinen Standard" routes an indifferent client to `green-fuzz-classic` — which is the
sheet `index.html` is built on, and `index.html` is reachable through
`stacks/dom-css/`. A hire that derived the geometry from §5 and a hire that copied
the reference write the same numbers, so neither criterion can tell them apart by the
numbers alone. **14b** answers that by scoring against whichever sheet the page
actually downloaded, identified by pixel size and never by name, so the tell is
whether the numbers and the sheet agree rather than which sheet it is. **10** was
given a second window width, because a derived duration moves with the viewport and a
typed one does not.

### Alternating the monster row

**That second window width does not settle it, and `#053` is why** — the reference
derives its duration in a script too, so a faithful copy of `index.html` also produces
`changesWithViewport: true`. The cheapest discriminator left is a sheet with nothing to
copy, so the monster row alternates between runs: the *Standard* arm buys `14a` (whether
the choice was offered at all) and gives up `10`; the `green-fuzz-strolling` arm buys
`10` — 17 frames, 299×300, 0.71 s, none of it in `index.html` — and gives up `14a`,
because a client who states a preference turns *offered or not* into *instruction
followed or not*. Which arm is live for the next run is in the answer table above.

**On the stated-monster arm `14a` is still scored, and the verdict word is `pass` or
`fail`.** The offer either precedes the client's answer or it does not, and that is
observable from the turn text whichever arm is live — so *gives up* never means
`NOT SCORABLE` here. What the arm gives up is `14a`'s **comparability** with the runs on
the *Standard* row, and a report on this arm says that instead of quoting a streak.
`#078`.

**Two things the alternation does not buy, and a run must not claim them.**

- **The `green-fuzz-strolling` arm only discriminates if the hire asks.** A hire that
  never raises the choice never hears the answer, takes the §5 default, and lands back
  on `green-fuzz-classic` with the reference's numbers available. So `10` is scored as a
  real measurement on that arm **only when `14a` passed**; a hire that did not ask gets
  `10` recorded with an *assent, not measurement* caveat instead. Say which of the two
  the run was.
- **Neither arm is retrofitted.** A `green-fuzz-strolling` run is comparable to the
  earlier record on every criterion except `10` and `14a`, and the report says so rather
  than quoting a streak.

## Acceptance criteria

### A — Brief fulfilled

1. Alt+A starts the monster; merely loading the page does **not**
2. Travels left → right across the page (evidence: `getBoundingClientRect().x`
   at two moments, not eyeballed screenshots)
3. Faces its direction of travel — never mentioned by the customer, and the
   reference walks the other way with `scaleX(-1)` commented out
4. **4a** Did Monster-Dev ask about repeat behaviour on its own?
   **4b** Does a second Alt+A press work?
   Fail 4b *without* 4a = playbook gap (§5). Fail 4b *with* 4a = implementation error.
5. No other trigger fires it; the existing smooth-scroll in `script.js` still works

### B — Playbook followed

6. Introduced itself as Monster-Dev exactly once (§1)
7. Asked the onboarding questions **before** building (§4)
8. Idiomatic: plain CSS/JS in the style of `style.css` / `script.js`, no
   dependency, no new animation library (§2.4, §6)
9. Sprite lives in `assets/` next to `logo.svg` (§2.5, §7) — under whatever name
   the site's own conventions imply; the slug is not required to survive
10. Technique carried over rather than copy-pasted (§5). Scored from
    `measurements.json` — `implementation`, `sheetMatch`, `derivation` and
    `durationVsViewport` — never by reading the stylesheet.
    **10a** Frame geometry lives in custom properties rather than in literals:
    `implementation.customProperties` carries the frame size and the cycle.
    **10b** `implementation.steps` equals `sheetMatch.frames.sheet` — the frame
    count of the sheet **actually downloaded**, identified by `spriteNaturalSize`.
    **10c** The crossing duration is derived, not chosen. Both halves required:
    `derivation.cyclesIsWhole` is true, because §5's arithmetic ends on a whole
    number of gait cycles and a picked number does not; and
    `durationVsViewport.changesWithViewport` is true, measured on the same page at
    a second window width. A duration that does not move with the viewport was
    typed, however plausible it looks.
11. `prefers-reduced-motion` handled (§5, §9). Scored from `measurements.json` →
    `reducedMotion`, with the media feature **emulated**. A `@media
    (prefers-reduced-motion: reduce)` block in the stylesheet is **not** a pass on
    its own: that is code presence standing in for behaviour, which is the
    substitution that has already produced three wrong verdicts in this harness.
    **11a — scored.** It does not travel: `travelledPx` is 0.
    **11b — `INFO`, never `PASS` or `FAIL`.** Whether it is still on screen
    afterwards: `stillOnScreenAfterCrossing`. Measured and reported on every run,
    and counted in no total.
    Two marks and not one, because they are settled by different things — and only
    one of them is settled at all. §5 asks for *"something visible and still"*, so
    11a is that sentence measured. 11b is a judgement §5 does not make, and the
    first time it was ever measured it **failed the reference implementation**:
    `index.html` parks the monster at `translateX(40vw)` and leaves it there. So
    would `impl-01`, which reached the same reading independently and recorded it
    as *"park it, don't hide it"* with the note that it was never asked about.
    Scoring 11b would mark a hire down for doing what the playbook prescribes and
    what the only two implementations that faced the question both chose. It stays
    visible instead: a number in every report, with no verdict attached, until §5
    says something — at which point it becomes a real criterion with a before-fail
    already on record.
12. `git log --oneline` shows **exactly one** commit; no trailer (§8)
13. Two instruments, because the file list and the file contents are not the same
    question (§9). **13a** `git status --porcelain -uall` shows only the
    implementation plus the sprite sheet, no playbook leftovers. **13b** A
    case-insensitive content search over the handed-back worktree finds no reference
    to `Monster-Dev` or `MonsterLib` **as a dependency, import, path, or
    configuration value** — §9's own scope, which is what the search exists to reach
    and `git status` cannot, because it reports paths and never opens a file.
    A **signature comment is not a hit.** §8 hands the hire
    `// walking monster easter egg — Monster-Dev` as an example, and §9's first
    bullet presupposes a signature — *"only the implementation and the sprite sheet
    exist as evidence Monster-Dev was here"* — so scoring the comment marks a hire
    down for following the playbook. Record the comments found as `INFO`, the same
    construction as `11b` and `5c`: twelve implementations have now signed their
    work and nobody has decided that is wanted, so it is worth counting while the
    question is open.
    This instrument takes a reader rather than a pattern, and that is deliberate.
    `grep -i monster-dev` is easier to run and answers the wrong question; `15c` is
    on the board because a mechanically checkable criterion measured the wrong thing.
    **Do not re-widen it for convenience.**
14. **14a** Was the choice of monster offered at all (§4)?
    **14b** Which sheet did the page actually download, and do the implementation's
    numbers belong to **that** sheet? Scored from `sheetMatch`, which identifies
    the sheet by `spriteNaturalSize` rather than by name: `frames.agree` is true,
    `cycleSeconds.deltaPct` is within a few percent, and `cellAspect.deltaPct` is
    within one percent. A uniform scale is a pass and the display size is the
    hire's call — `cellPx.scale` records it — while a changed aspect ratio is a
    fail, because the squashed monster is what this criterion exists to catch. If
    the hire *named* a sheet in the dialogue, that name and `sheetMatch.slug` must
    be the same one.
    Wrong numbers *for the sheet it downloaded* is an implementation error; a
    silent pick without offering is a playbook gap.

*Not exercised by this run:* base URL derivation (§0) and the WebFetch/curl
split (§5). This is a mirror run, so neither is reached. Both are already **proven**
by an earlier run over real URLs and must not be reported as *deferred*.

A criterion whose named instrument does not exist is scored **`NOT SCORABLE`**, not
`PASS`. A mark marked `INFO` — `11b` is the only one — is measured, quoted in the
report and counted in **no** total, neither as a pass nor as a failure. `INFO` is
not a soft failure and not a deferral: it is a number this project wants on record
while the question behind it is open.

**Six marks are answered on paper before turn 1, and that is scored around rather than
repaired.** Four by the fixture's own files — `8`, `9`, `18b` and `18c`, answered by
`README.md:3`, `:11`, `:12`, `:19-20` and `script.js:1-2`; the full list, with what each
line says, is the **Pre-answered** table in `process/fixtures/static-site.md`. **Two more
by `stacks/dom-css/README.md`, the published note §2 tells the hire to fetch:** `:21` puts
the sprite *"next to whatever `logo.svg`-equivalent it has"*, and this fixture's sole
asset is literally `assets/logo.svg` — that is `9` and `18c`, answered by filename; `:14`
names the primitive as `@keyframes` with `steps(N)` over `background-position` plus a
separate transform carrying the travel — that is `18b`, answered before §2.2 is reached.
**A guard answered on paper before turn 1 cannot regress**, so *"nothing regressed on
section E"* holds cleanly for `18a` and `18d` and weakly for `18b` and `18c`, and any
report scoring `8`, `9`, `18b` or `18c` says so in a clause — counting both sources and
not the fixture's alone. Removing the lines instead was considered and refused twice
over: a project whose README does not say where static assets go is not a project
anybody has, and the stack note is published material that changes only through its own
gate. It is also *correct* — telling a hire to put the sprite where the project's other
assets live is orientation doing its job, and it cannot know that one fixture's assets
folder is the answer to somebody's criterion. **The measurement adapts to the product
here, not the other way round.** `#054`, `#076`.

**The criteria have moved three times, on `2026-08-01`, `2026-08-02` and
`2026-08-03`.** A run is scored under the criteria it was scored under, so only the
untouched marks compare directly across those dates, and the wording above is what
governs this one.

### C — Language fidelity (unregulated in the playbook, hence worth measuring)

15. **15a** Introduction and questions in German?
    **15b** Handover note in German?
    **15c** Do the code comments follow the codebase rather than the conversation?
    The fixture's comments are English, so English is the pass. German comments in
    an English codebase are a §6 failure, not a language-fidelity success — §8 says
    it outright: *"Code comments are the other way round: those follow the
    codebase."*

### D — Actually runs

16. No console errors **the hire introduced** — `measurements.json` →
    `consoleErrors`, which is the run's console output minus whatever the untouched
    fixture logs on load. The baseline is in `fixtureConsoleErrors` and is measured
    on every run rather than written down once as an allowlist, and
    `consoleErrorsAll` is kept beside it so the subtraction can be checked instead
    of trusted. Sprite loads with 200 — `spriteHttpStatus`.
17. Frames advance — not stuck on frame 0 (`samples[].bg` moves)

**Alt+A measurement ladder.** ① real key press → pass, "real key path".
② otherwise a synthetic `KeyboardEvent` with `altKey: true` → pass, but recorded
as "handler verified, key path not measurable in this browser" rather than a
clean pass. ③ neither → fail.

### E — The plan step (§4)

**Appended on 2026-08-01, not inserted.** 1–17 keep their numbers, so they still
compare across the whole series. E is scored from `<run-id>/hire.json` plus the
cli-turn-1 text; the runs that predate it have no E marks and never will.

18. **Before anything in the target changes**, Monster-Dev states what it found.
    Four independent marks. Each is scored from the cli-turn-1 text *and* requires
    `turns[0].worktreeAfter` to be empty — content stated after the build is a
    changelog and scores nothing, however complete.
    - **18a — Injection point.** A file *in this project*, named, with the reason
      it is that one and not another.
    - **18b — Animation primitive.** What the project already animates with, or
      that it animates with nothing yet, named as what the work will build on.
    - **18c — Change set.** Which existing files get edited, what is new, and
      where the sprite goes.
    - **18d — Sheet.** The sheet it will use with that row's frame count and
      cycle time from §5.

    Four marks rather than one because hires omit *different* halves, and a binary
    criterion records every one of them as PASS.

19. **One round, not two.** The plan and the questions arrive in the same message.
    Evidence: `totals.firstEditAfterCliTurn` > 1, and the plan text sits in
    cli-turn 1. Splitting into "here is my plan" and then "here are my questions"
    is a fail even when both halves are good.

20. **20a** Built as announced, **judged on substance**: the surface it goes on, the
    animation primitive, the trigger, and where the sprite lives. A deviation in one of
    those four is a **fail** — that is a different implementation than the one
    announced. Everything else is a detail, and a deviation in a detail is a
    **partial**: which file an element is *declared* in when it is created at runtime
    instead, whether a decorative part was mirrored with the sprite, which roster sheet
    was used once the client named one. A partial is a partial **whether or not `20b`
    catches it** — the two marks are independent and a named departure is still a
    departure. All-or-nothing on 20a would make a run that shipped everything but one
    detail indistinguishable from one that built something else entirely, and that
    distinction is the only thing this mark is for.
    **20b** Any departure from the announced plan named in one line rather than
    silently applied — **every** departure, so the mark is a **partial** when some were
    named and some were not. *Named* means saying the plan changed, not stating the new
    state as a fact: *„`index.html` musste ich nicht anfassen"* names it, and naming a
    sheet in the handover after having announced a different one does not.
    Fail 20a *without* 18 = playbook gap. Fail 20a *with* 18 = implementation
    error. Never blur the two. `#078`.

    **On an arm where the customer states a monster, the sheet change is not a
    `20a` failure.** Criterion `19` requires the plan and the questions in the same
    message, so the sheet named for `18d` is necessarily the §5 default — the client
    has not answered yet — and the client then names a different one. Building the
    sheet the client asked for is following the instruction, not departing from the
    plan, and a run cannot be marked down for a sequence its own criteria force.
    **`20b` still applies in full:** the change was announced-then-superseded, and
    whether the hire says so in one line is exactly what `20b` measures. Which arm
    is live is in the answer table above; on the *Standard* arm this paragraph is
    inert, because the default and the answer are the same sheet.

21. **No bookkeeping about notes.** With no measured pitfalls in the stack note,
    nothing is said about notes existing. "There are notes for this stack, I read
    them" is a fact from our side of the fence and tells the client nothing.

**Risk criteria — must hold, not improve.** 4a, 7a, 10 (all three marks) and 19. A
rewrite that buys completeness on 18 by taking a second round has failed, not
improved: 19 catches exactly that trade.

## Run log

| Run | Date | Model | Result |
|---|---|---|---|
| `2026-08-01-alt-a` | 2026-08-01 | Opus | baseline — [report](../runs/2026-08-01-alt-a/report.md), [findings](../runs/2026-08-01-alt-a/findings.md) |
| `2026-08-01-phase1` | 2026-08-01 | Opus | restructure is behaviour-neutral; every criterion held, cost +36 % — [report](../runs/2026-08-01-phase1/report.md) |
| `2026-08-01-sonnet-base` | 2026-08-01 | Sonnet | bar baseline. Asked before building where Opus never did → K7 was model disposition, not a playbook gap. Also solved both `dom-css` pitfalls unaided, leaving the planned A/B with no arms — [report](../runs/2026-08-01-sonnet-base/report.md) |
| `2026-08-01-phase2` | 2026-08-01 | Opus | F2 proven: K4a flipped after four runs failing it. K7a turned out to be biased by the harness's own dialogue-protocol sentence, so it is unmeasurable rather than failing. Cost $4.04 — [report](../runs/2026-08-01-phase2/report.md) |
| `2026-08-01-phase2b` | 2026-08-01 | Opus | Prompt fix + roster. K7a flipped on the model that failed it three times — it was the harness, not the playbook and not the model. Roster works (14a/14b), K10 held. Cost $1.84, **−54 %**: asking first means building once — [report](../runs/2026-08-01-phase2b/report.md) |
| `2026-08-01-sonnet-base2` | 2026-08-01 | Sonnet | Before-arm for the §4 plan step, and the first Sonnet run under the corrected dialogue protocol. Every criterion 1–17 passed; section E scored **18: 1/4** — primitive named, injection point / change set / sheet numbers not. 31 model turns, $1.66 — **no report of its own**; its numbers are the before-arm inside [`plan-sonnet`'s](../runs/2026-08-01-plan-sonnet/report.md) |
| `2026-08-01-plan-sonnet` | 2026-08-01 | Sonnet | **Proof run for the §4 plan step.** 18 went 1/4 → **4/4** on the bar model, nothing regressed, 21 held. Turn 1 got shorter and 39 % cheaper; total turns rose 32 %, over the soft ceiling, entirely in the build turn. Also exposed a second-level verifier bug: CSS-visible ≠ visible — [report](../runs/2026-08-01-plan-sonnet/report.md), [findings](../runs/2026-08-01-plan-sonnet/findings.md) |
| `2026-08-01-plan-opus` | 2026-08-01 | Opus | Control for the same change. 18: 4/4, and `phase2b`'s criterion-21 failure did not recur. Named an unannounced departure on its own (dropped the shadow, said why) — the new §6 sentence firing. 41 turns, $2.72 — **no report of its own**; it is the control arm inside [`plan-sonnet`'s](../runs/2026-08-01-plan-sonnet/report.md), and it has a [blind second scoring](../runs/2026-08-01-plan-opus/score-b.md) |
| `2026-08-01-index-sonnet` | 2026-08-01 | Sonnet | §2 as a parseable table + the first-match rule. **Behaviour-neutral, as intended** — every arm identical to `plan-sonnet`; 18 held at 4/4 on a second independent Sonnet hire. First failure on **20a**: announced a container in `index.html`, built without one, never flagged the substitution. The turn overrun reproduced (42), which corrects Phase 2's hedge — [report](../runs/2026-08-01-index-sonnet/report.md) |
| `2026-08-03-r13` | 2026-08-03 | Sonnet | **No data — the hire refused the entry point** as a prompt-injection / supply-chain risk and stopped in turn 1, on a mirror byte-identical to `r12`'s. 2 model turns, $0.11. Arm A's first attempt; rerun as `r15`. `#050` |
| `2026-08-03-r15` | 2026-08-03 | Sonnet | **Arm A of `#002`, and the only honest baseline** — every earlier figure was measured against a fixture and mirror that changed in `ac2808b`. 38 turns (12+26), $1.9424 — corrected `2026-08-04`, `#074`. 29 pass / 2 fail / 1 not scorable; `13b` and `21` fail, neither the hire's fault. Its `style.css` copies `index.html`'s custom properties *including two comments verbatim*, which criterion `10` passed — [report](../runs/2026-08-03-r14/report.md), `#053` |
| `2026-08-03-r14` | 2026-08-03 | Sonnet | **Arm B of `#002` — rejected.** The §6 bound cost **+20 % turns** (60 vs 50; build 45 vs 38) at flat cost, and `18a` went pass → partial. Behaviourally identical to arm A on every measured figure. Its blind scoring found `#053`; `#049`, `#051`, `#052`, `#054`, `#055` also came out of the pair — [report](../runs/2026-08-03-r14/report.md) |
| `2026-08-04-r19` | 2026-08-04 | Sonnet | **No data — the hire refused the entry point**, the second instance of `#050` and the same refusal as `r13`: both lead with §0 having no referent on a mirror run, both Sonnet on this fixture, both offering to build without the playbook. 2 model turns, $0.1356. Rerun as `r20`. Its pre-run audit is the one `r20` carries — [report](../runs/2026-08-04-r19/report.md) |
| `2026-08-04-r20` | 2026-08-04 | Sonnet | **`#061` Phase 3 — the false-decline control, and the signal did not fire.** Treated §3, and turn 1 hesitated over nothing. **30 pass / 0 fail / 2 partial / 0 not scorable**, both scorings agreeing on all 32 marks; the partials are `20a`/`20b`, implementation errors. 47 turns (13+34), $1.9517. **First run on the `green-fuzz-strolling` row**, so `10` has its first real verdict and `14a` is not comparable; **first `13b` pass in 13 runs** (`#051`). `#074`–`#078` came out of it — [report](../runs/2026-08-04-r20/report.md) |
| `2026-08-01-live` | 2026-08-01 | Opus | **First run over real raw URLs** — no mirror, no `--add-dir`. §0 proven (base derived after two real renames), §5 proven by hash (byte-identical 1.9 MB sheet cannot come through WebFetch). §2 stack resolution still unproven: a content-free stack file leaves no fingerprint. Cost $1.61 — [report](../runs/2026-08-01-live/report.md) |

## Provenance — how this file got its wording

Everything from `## Run log` down sits **below the cut** `score-bundle.ps1` makes, so
no blind second scoring reads it. That is the whole reason this section is here rather
than beside the criteria it explains.

**The rule, stated once, because it decides where a new paragraph goes.** Above the cut
belongs what a scorer needs in order to reach a verdict: the setup, the **current**
wording of the answer script, the criteria, and the rules that say how to score them —
`NOT SCORABLE`, `INFO`, the pre-answered marks. Below the cut belongs how the file got
that way: what an audit found, what an earlier run scored, why a criterion was
reworded, and what a future change would owe. A criterion's history is not an
instrument, and handing it to the second reader hands over the map with the criterion
at risk already circled. `#056`.

`score-bundle.ps1` enforces the observable half of that rule and refuses a bundle whose
criteria half names **any** run id. That is narrower than the rule — a passage can give
a verdict away without naming a run, and *"its ten passes were assent"* is exactly such
a passage — so the rule is still read and applied by hand.

**And a pointer down here from above the cut is the same leak in miniature.** `#056` left
a bare *"in Provenance at the foot of this file"* beside each criterion whose history it
moved — eight of them in this file. They survived into `criteria.md` and their target did
not, so a blind scorer read references to a section its bundle does not contain, and
*"the reasoning for these rows is below"* still says the rows were reworded. So **a
paragraph above the cut names no location**, and `score-bundle.ps1` refuses a bundle whose
criteria half contains `Provenance`, `at the foot of this file` or `## Run log`. `#072`.

### The flat runs root

Every run before `2026-08-02` sat directly in `../monster-dev-testruns/`, alongside
every other run folder and mirror, so one `ls ..` listed the whole series in dated
`<name>` / `<name>.dist` pairs with the model in the name — and ten of those folders
held a finished, already-scored implementation of this exact brief against this exact
fixture. `2026-08-01-sonnet-base2` ran that listing. Its transcript shows no path
*into* a sibling and no foreign file read, so the recorded exposure is the listing and
not a copy; the run keeps that caveat and no re-scoring. `#019`, `#040`, `#041`.

### The dialogue protocol's wording

It used to read „stell deine Fragen in der **Abschlussnachricht** und stoppe". Run
`2026-08-01-phase2` showed what that cost: the hire built first and then explained
itself with *„Du wolltest Fragen am Ende"*. „Abschlussnachricht" reads as *questions
come at the end*, i.e. after the work — so the harness was quietly instructing the
opposite of §4's "ask before you build", and K7a was measuring the harness author's
sentence rather than the playbook. Sonnet resolved the same ambiguity the other way,
which is why the two models appeared to disagree about §4 when they never did.

### The run that proved §0 and §5

`2026-08-01-live`, the only run on record over real `raw.githubusercontent.com` URLs.
The id is here rather than beside the *Not exercised by this run* paragraph because
that paragraph's job is to stop a report calling those two sections *deferred*, and it
does that job without naming the run.

### The evidence the monster-row alternation was built on

`2026-08-03-r15` copied the reference's six custom properties **including two comments
byte for byte** and passed all three marks of `10`; `-r14` kept every value, renamed
the properties and dropped the comments, and also passed. `--stride: 130px` and the
`--crossing: 16s` fallback are the proof rather than the tell: §5 derives neither, they
are free parameters, and both arms produced them to the pixel and the second.

`14a` has held on twelve runs and does not need re-measuring on every one. `10` has
never been measured at all — its ten passes were assent rather than measurement. That
is the whole argument for spending one run on the `green-fuzz-strolling` row, and
`#026` is the item that owns the *Standard* row and says why it is not simply
replaced. Every run on record used the *Standard* row, which is why a
`green-fuzz-strolling` run may not quote a thirteen-run streak. `#053`.

### The surface-question row, and `20a`'s carve-out — both dated `2026-08-04`

Both come out of one pre-run audit, before any turn was bought, and both are
verdict-preserving for every run on record: no earlier run consumed either, because
no earlier run had a client-stated sheet and none of the eleven `static-site`
sessions ever questioned whether it was in the right place.

**The row exists because a §3 change is under test.** The treated `MONSTER-DEV.md` §3
says *"You may ask whether you have missed a surface that already exists"* — a
question class this answer script had no row for, on the one scenario where the
question is expected to be pointless. The audit's finding was sharper than the gap:
the fallback would have answered it with *"take your default"*, so **the run could
only ever come back "no hesitation", whether or not there was any** — the dependent
variable answered by the answer script. That is `nowhere-to-walk`'s deflection-row
defect in the other direction, and it was caught by the same instrument.

**`20a`'s carve-out exists because criterion `19` and the monster row collide.** The
audit found that a stated-sheet arm makes a departure from the announced plan
*structurally unavoidable*: `19` puts the plan in the same message as the questions,
so `18d` names the §5 default, and the client then names another sheet. Without the
carve-out every strolling-arm run fails `20a` for a reason that is not the hire's,
and the *"comparable except `10` and `14a`"* claim above would be false for three
more marks than it names. The carve-out is deliberately narrow: it covers the sheet
and nothing else, and `20b` is untouched.

### The pre-answered accounting reaches the stack note too — `2026-08-04`

`#054` built the accounting around the fixture, because that is where `#015` found the
problem, and the paragraph above inherited the scope: a reader following its pointer got four
rows and believed it was the list. It was the list *of fixture lines*. Two of the strongest
pre-answers are in `stacks/dom-css/README.md`, the published note §2 tells every hire on this
surface to fetch, and all thirteen runs on record fetched it. Found by `2026-08-04-r20`'s
pre-run audit, before a turn was bought, and it falsifies the fixture note's own statement of
purpose: the fixture exists so that *"the injection point, the asset location and the
animation primitive"* are each a §2 judgement rather than a lookup, and with the note fetched
two of the three are a lookup.

Nothing is re-scored and no comparison breaks — the note has been identical for the whole
series, so the contamination is uniform in exactly the way `#054`'s four rows are. What it
cost is the disclosure, on six marks rather than four. The general shape is why `#076` was
filed rather than patched in one report: a pre-answer can come from anywhere in the hire's
context, the accounting covered one source because that is where the first one was found
(`#003`), and every stack note added later is a new candidate.

### Criterion `20`'s threshold — a boundary, dated `2026-08-04`

`20a` used to be one sentence with no threshold, and `20b` one sentence with no example.
`2026-08-04-r20`'s two scorings split on both marks from the same text and in opposite
directions — primary `20a` fail / `20b` pass, blind `20a` partial / `20b` partial — and the
blind reader named the missing rule exactly: *whether a departure `20b` catches still costs
`20a`, or whether `20a` measures only substance.* `#078`.

**It is a boundary and not the verdict-preserving edit `#078` predicted.** That item claimed
`2026-08-01-index-sonnet`'s `20a` fail survived the new wording *"because the injection point
itself was the deviation"*. Checked against the report rather than assumed, it is not: that
hire announced *„ein kleiner neuer Container in `index.html`"* and created the element from
JavaScript instead — **the same deviation `r20` made**, on the same fixture, and `r20` was
scored `partial` by both readers. The claim was wrong and the check is what found it.

So under the threshold above, `index-sonnet` moves on both marks and in opposite directions:
`20a` fail → **partial** (surface, primitive, trigger and sprite location all as announced),
and `20b` pass-with-a-caveat → **fail** (its handover said *„`index.html` bleibt
unverändert"*, the new state as a fact, which is the one thing the new `20b` says is not
naming a departure). **Nothing is re-scored** — a run is scored under the criteria it was
scored under, the same rule `#051`, `#052`, `#053` and `#058` established — and the run keeps
its recorded tally. What the boundary says is that the old wording put that hire's failure on
the wrong mark, which is the defect, and that any comparison of `20a` across that date has to
read this paragraph first.

`2026-08-03-r14`, `-r15`, `2026-08-01-plan-sonnet` and `-plan-opus` are untouched: their `20a`
passes had *"every announced item present in the diff"*, and their `20b` passes named a change
as a change (*„Eine Abweichung von dem, was ich angekündigt hatte: kein Schatten"*).

### Why criterion 18 is four marks

The archive shows hires omitting *different* halves of the plan: `2026-08-01-phase2b`
scored 4/4 and `2026-08-01-live` 1/4 on the same model and the same brief. A binary
criterion records both as PASS and destroys the measurement — see
[`plan-retro.md`](../runs/plan-retro.md).

### What the risk criteria are worth as evidence

`10` became falsifiable only on `2026-08-02`, so its history is assent rather than
measurement: an A/B that leans on it is leaning on one run's worth of evidence, not
ten. Of the four, criterion `21` is the one with a real before-fail on record —
`2026-08-01-phase2b` failed it, and it is the only criterion in section E that has
ever failed.

### Section E's reach

Section E was appended on `2026-08-01` rather than inserted, and it did not exist for
any run before `2026-08-01-sonnet-base2` — the six runs earlier than that have no E
marks and never will. 1–17 kept their numbers so they still compare across the boundary.

That sentence used to sit beside the criteria and named the run as a bare
`sonnet-base2`, undated, which is why the run-id refusal in `score-bundle.ps1` did not
catch it — the pattern wants a date. Recorded as the instrument's honest limit rather
than widened: a looser pattern would start firing on ordinary words, and the rule the
refusal serves is applied by a reader anyway.

### The three criteria boundaries

**Criteria changed on `2026-08-01`**, when the roster replaced the single sheet: 9, 10
and 13 stopped naming `monster-walk.png` and `steps(23)`, 14 is new, and the old 14–16
became 15–17. The first two runs in the log predate that and scored the old wording, so
only the untouched criteria compare directly across the boundary.

**Criteria changed again on `2026-08-02` — one boundary, six criteria, and the largest
of the three.** Each change is here because a criterion was being scored off whatever
the harness happened to emit, and two of the six were caught by a reader who had never
seen the run.

| | What it used to be | What settles it now |
|---|---|---|
| `10` | prose about technique, scored from nothing | `derivation`, `durationVsViewport`, `implementation.customProperties`. It is now falsifiable — before this it could not fail. **This row overclaims, and the `2026-08-03` boundary below says how:** falsifiable in principle, and still undiscriminating against the one reference a hire can read (`#053`) |
| `11` | *"handled"*, scored by finding a `@media` block | `reducedMotion`, with the media feature emulated, split into `11a` travel — **scored** — and `11b` disappearance — **`INFO`, counted in no total**. The harness had no reduced-motion path at all and never had. `11b` is a judgement §5 does not make, and it fails `index.html`, so it is measured and reported rather than scored |
| `13` | one instrument, `git status`, and the pre-rename product name | two instruments, and both product names. `git status` reports paths and cannot see a string inside a modified file |
| `14b` | the sheet's frame count, cell size and cycle | the **implementation's**, against whichever sheet was downloaded, with aspect ratio in place of literal cell size |
| `15c` | *"Code comments in German?"* — a pass for behaviour §6 and §8 forbid | comments follow the codebase; English is the pass |
| `16` | console errors counted against zero, so every arm scored *"1 (favicon)"* | errors **new since the untouched fixture**, with the baseline measured per run |

Three consequences, none of them repairable by the edit:

- **`10` is a risk criterion and could never fail before that boundary.** Every A/B on
  record up to it leans on it. Its ten passes were assent, not measurement.
- **`11`'s seven passes were scored on code presence**, and three of the reports
  describe watching the behaviour anyway. That evidence cannot be re-sourced.
- **Criteria `8` and `9` are contaminated in six runs** — `alt-a`, `phase1`, `phase2`,
  `phase2b`, `live` and `plan-opus` — where the fixture's own README told the hire the
  answer. Five of the six carry the caveat in their report; `plan-opus` has none to
  carry it, which is why it is recorded here. `#015` removed the lines addressed to the
  wrong reader; the four that remain are the *Pre-answered* paragraph above, and they
  affect every run in the series and every run to come. Nothing is re-scored, because
  that contamination is uniform. `#054`.

**And one boundary under all of them, recorded `2026-08-02`.** The `<dist>` mirror
carried this repository's own `README.md`, whose *"Monster-Dev gets better by being
tested"* section says a fresh agent is hired against a sample project and scored
criterion by criterion. It appears as a Read tool result in **eight of the ten**
transcripts. Two others carried the same disclosure in `tools/project.md` or
`monsters/README.md`; only `alt-a` and `live` are clean, and `live` only because it
fetched over real URLs and never listed a mirror.

Unlike the fixture README, which split exactly by model and left all four Sonnet runs
clean, this one hits `sonnet-base`, `sonnet-base2`, `plan-sonnet` and `index-sonnet`
too. **Sonnet is the bar, so there is no clean arm.** No individual criterion is named,
because what is compromised is the premise beneath all of them — that the hire does not
know it is being measured — and there is no way to quantify what a hire does
differently knowing that. It is not re-scored and nothing is deleted; every run from
`2026-08-02` on is on the other side of it. The four exclusions and the two path-free
mirror checks that close it are in `build-dist.ps1`.

**Criteria changed a third time on `2026-08-03` — three instruments, every one of them
found by a blind scoring.** Unlike both boundaries above, nothing here was found by a
run *failing*: `r15` and `r14` both **passed** all three marks of `10`, both **failed**
`13b`, and `11a` was `NOT SCORABLE` in both. What changed is what those verdicts turned
out to be worth.

| | What it used to be | What settles it now |
|---|---|---|
| `13b` | any occurrence of either product name anywhere in the worktree | a reference **as a dependency, import, path or configuration value** — §9's own scope. A §8 signature comment is `INFO`, never a hit. It had failed **12 of 12** and could not be passed by a hire that follows §8 (`#051`) |
| `10` | three marks off `measurements.json`, none of which can see *whose* numbers they are | the three marks are unchanged; what changed is the sheet they are scored on. The §4 answer script's monster row now **alternates** — see *Alternating the monster row* above — because the cheapest discriminator is a sheet the reference does not use (`#053`) |
| `11a` | `travelledPx` from a single sample at 3 s | the window polled to disappearance, so *never moved* and *moved, then hid* are no longer the same reading. The criterion's wording is untouched; the instrument was the defect (`#052`) |

Two consequences, and neither costs the record anything:

- **`13b` has no history to lose.** It postdates all ten archived implementations, every
  one of which contains the product name, and the two runs scored against it both fail
  with `#051` cited rather than the hire. Nothing that was comparable stops being so.
- **`10`'s ten passes were already on record as assent rather than measurement.** What
  the third boundary costs is the belief that the `2026-08-02` repair closed it. It did
  not: the reference derives its duration in a script too, so a faithful copy also
  produces `changesWithViewport: true`, and `--stride: 130px` and the `--crossing: 16s`
  fallback are derived from nothing in §5 at all.
