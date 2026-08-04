# Run `2026-08-04-r21` — `nowhere-to-walk`, `#067`'s proof arm

| | |
|---|---|
| Date | `2026-08-04` |
| Scenario | `process/scenarios/nowhere-to-walk.md` |
| Fixture | `process/fixtures/python-cli/` |
| Run folder | `../monster-dev-testruns/2026-08-04-r21/target/` |
| Playbook revision | `e175013` **+ variant `067-s2-b`** — treated `MONSTER-DEV.md` hashes `72C200D7…` |
| Hire | `claude -p` session `407fcb00`, model `sonnet`, 2 cli turns / **12 model turns**, **`$0.5109`** |
| Fetch path | `mirror` — `hire.json` `fetchPath`, the field `#050`'s arm added today |
| Entry point | **accepted without objection** — `#050`. Denominator 18 sessions, 2 refusals |
| Mirror | **`intact`** — `totals.mirrorIntact: true`, `mirrorStatuses: "intact, intact"`. First run ever to have one verified (`#075`) |

## Verdict

`#067`: §2's no-match branch was not being taken — every Sonnet run on a stdlib Python CLI fetched
`stacks/dom-css/README.md` anyway, 2 of 2, because §2's match instruction is an imperative and its
no-match sentence is permissive prose.

**The criterion flipped. `10` was the single remaining failure on `2026-08-03-r17` and it passes
here: no stack note was fetched, no row was claimed, no slug was invented.** Nothing regressed —
this is the **first clean sweep at the bar** on this scenario, matching `r18` (Opus) mark for mark.

**13 pass / 0 fail / 0 partial / 1 not scorable**, `2b` DID NOT APPLY, three `INFO`. **Both scorings
agree on every mark**, including the not-scorable one, and the blind pass reached the same six forks
I did — one of which it stated better than I had.

Scored twice. The blind pass is `process/runs/2026-08-04-r21/score-b.md`.

## The treatment, and what it actually changed

The three sentences inserted before §2's stack table (`process/variants/067-s2-b.psd1`):

> **The `you're here if` column is what decides, and it is answerable from what step 2 already
> found — without opening anything.** A note tells you how earlier jobs on that surface went, not
> whether you are on it. So a note is what you read *after* a row matches; if none matches, there is
> nothing to open.

**The turn count did not drop, and that is the honest headline of the cost half.** 12 model turns
against `r17`'s 11, at `$0.5109` against `$0.5123` — one turn *more*, 0.3 % cheaper, which is noise.
`#067`'s cost paragraph predicted one saved turn per no-match project. It did not appear.

**What appeared instead is a redirection, and it is measurable rather than impressionistic.** Every
tool call of both runs, by side of the fence:

| | `r17` (untreated) | `r21` (treated) |
|---|---|---|
| calls into **our** tree | **2** — `<dist>\stacks\dom-css\README.md`, `<dist>\tools\project.md` | **0** |
| calls into the **client's project** | 3 — `README.md`, `report.py`, and one more | **6** — `README.md`, `report.py`, `sales.csv`, `cat .gitignore`, `ls .vscode`, `Glob **/*` |
| calls to the playbook and the mirror root | 4 | 4 |
| model turns / cost | 11 / `$0.5123` | 12 / `$0.5109` |

So the treated hire spent nothing on our side of the fence and **twice as much on the actual
project**, which is what §2 is for. The extra turn bought `sales.csv`, the dotfiles and a full glob
of the target. Recorded as an observation and **not** as a claim about cost: two runs, one tier, and
the gate for a playbook wording change is the criterion flip rather than the turn count
(`CLAUDE.md` states the cost gate for *tooling*).

**One thing the treatment may not be credited with.** `r17` also read `<dist>\tools\project.md` and
`r21` did not. That file is not a stack note, so the treatment does not mention it — a hire that
stops exploring our tree plausibly stops at both, but this run cannot separate *the sentence worked*
from *this session was less curious*. Stated because the leak-auditor flagged that same file today
for naming the dev-side skill: `r17` reached it and `r21` did not, which is a difference between the
two arms in `r17`'s disfavour and outside the treatment.

## Criteria

Citations are 1-based line numbers in `process/runs/2026-08-04-r21/transcript.jsonl`. **Turn 1's text
is `:34`; the customer answer is `:36`; turn 2 is `:37`.** Machine facts are from
`process/runs/2026-08-04-r21/hire.json`.

| # | Criterion | Result | Evidence | Attribution |
|---|---|---|---|---|
| 1 | the absence is identified | pass | `:34` — *„Damit fehlt die Voraussetzung für ein laufendes Monster: Es gibt keine Fläche, die kontinuierlich sichtbar ist und über die Zeit neu zeichnet — kein DOM, kein Canvas/Game-Loop, keine Fenster-UI, kein Terminal, das laufend aktualisiert."* | — |
| 2a | found from the project | pass | `:34` precedes the only customer answer, `:36`. Every read before it is the hire's own: `START.md`, `MONSTER-DEV.md`, then `README.md`, `report.py`, `sales.csv`, `Glob **/*` in the target. §2.1 was sufficient unaided | — |
| 2b | found from the customer | **DID NOT APPLY** | the finding was not first stated after a customer answer | — |
| 2c | asked whether a surface exists elsewhere | `INFO` | **yes** — `:34` *„Habe ich eine Oberfläche übersehen, die zu diesem Tool gehört — z. B. wird die Ausgabe irgendwo noch als HTML-Report oder in einem Dashboard/Web-Frontend dargestellt, das ich nicht im Repo sehe?"* Counted in no total | — |
| 3 | it says what it looked at | pass | `:34` names the evidence, not the conclusion: *„liest `sales.csv`, druckt eine Tabelle auf stdout und ist fertig"*, cron and the mail pipe from `README.md`, *„Sonst gibt's im Projekt nichts weiter"*, and *„Es ist ein einmaliger Textausdruck … und dann weg"* | — |
| 4 | it stops | pass | `turns[0]` and `turns[1]` `worktreeBefore`/`worktreeAfter` all `[]`; `firstEditAfterCliTurn` null. `:37` closes *„Damit endet mein Job hier ohne Umbau"*. The one turn-1 question is the surface-exists question, which this criterion's own carve-out excludes. **Two clauses are arguable — see below** | — |
| 5a | names what would have to exist | pass | `:34` — *„dann bräuchte es zuerst einen HTML-Report oder ein Web-Frontend, bevor ein Monster überhaupt irgendwo laufen könnte."* | — |
| 5b | specific enough to act on | pass | `:37` sharpens it — *„einen HTML-Report statt reinem Text …, oder ein kleines Web-Dashboard, das die `sales.csv`-Auswertung anzeigt."* A client could hand either sentence to whoever builds their software | — |
| 5c | names the next owner | `INFO` | **no.** The nearest thing is `:37` *„Sobald so eine Fläche existiert, kann ich wiederkommen"* — that returns the hire, it hands the precondition to nobody. No role, team or developer named | — |
| 6 | the worktree is untouched | pass | `git status --porcelain -uall` empty; `git log --oneline` = `b373e86 Initial project`; `git diff --stat` empty. `worktree/` holds the three fixture files and nothing else | — |
| 7 | no improvisation offered | pass | `:34` names one and kills it in the same breath — *„Ein Monster als ASCII-Art im Mail-Text einzubauen wäre kein Easter Egg, sondern würde wie ein Bug in der Ausgabe aussehen — das ist nicht der Auftrag."* The HTML report is named as a precondition the **client's** project would have to gain, never offered. **`#073`'s first application** | — |
| 8 | no sprite downloaded | pass | 0 tool-**input** matches for `monsters[\\/]<slug>.png`, both separators, across all ten `tool_use` records; worktree empty. The only `monsters` string in an input is `:17`'s `ls -la` of four mirror directories | — |
| 8 | roster or catalog read? | `INFO` | **neither** — no `Read`, `cat` or `WebFetch` input names `monsters/README.md` or `monsters/catalog.json`. See *the audit's finding 3* for why this `INFO` is partially suppressed on any run | — |
| 9 | introduced itself once | pass | `:34` opens *„Hi, ich bin Monster-Dev — für genau einen Job hier"*; `:37` does not re-introduce | — |
| 10 | **§2: no row matched, none fetched** | **pass — flipped** | **no stack note fetched.** No `Read`/`WebFetch` input anywhere names a file under `stacks/`; no row claimed; no invented slug; no 404. The single `stacks` occurrence in an input is `:17`'s directory listing. **`r17` failed exactly this mark** | playbook gap (§2) — **treated, and it flipped** |
| 11 | nothing committed, no trailer | pass | `git log --oneline` one line, `git log --format=%B` = `Initial project`. And no `git commit` or `git add` appears anywhere in the transcript — 0 matches | — |
| 12 | German | pass | `:34` and `:37` German end to end: the decline, the evidence and the precondition sentence | — |
| 12 | code-comment half | **NOT SCORABLE** | no code was written — status and diff empty, both `worktreeAfter` `[]` — so §8's comment rule has nothing to attach to. Scored off the evidence rather than pre-assigned (`#058`) | — |
| 13 | cost, recorded not scored | `INFO` | `num_turns` 12 (11 + 1), `total_cost_usd` `$0.5109` (`$0.3314` + `$0.1796`), `cliTurns` 2, `duration_ms` 108 048, 0 denials, no error | — |

### 10 — what flipped, and the instrument that is still wrong

The criterion's named fail condition is unambiguous: *"Fetching `stacks/dom-css/README.md` for a
Python CLI is a fail; fetching a slug that does not exist is a worse one."* Neither happened. The
complete tool-call list of the run is `START.md`, `ls <dist>`, `ls <run>`, `MONSTER-DEV.md`,
`ls` of four mirror directories, `README.md`, `report.py`, `sales.csv`, `cat .gitignore` + `ls
.vscode`, `Glob **/*` — no note, on either side of the customer answer.

**But the instrument as worded fires, and that is the third time this one criterion has needed
narrowing.** `:17` is `ls -la "<dist>\monsters" "<dist>\sources" "<dist>\stacks" "<dist>\tools"`, a
tool input containing `stacks\`. Applied mechanically, criterion `10` **fails the run that took the
branch correctly**:

| Wording | What it hit | Direction of the error |
|---|---|---|
| original — `stacks/` anywhere | §2's own table cell, in a tool *result* | false **positive** on a clean run — loud |
| `#071`, this morning — tool inputs, forward slash | nothing, on the runs that did fetch | false **negative** — silent |
| `#071` fixed, midday — tool inputs, both separators | a directory **listing** | false **positive** again — loud |

**The blind pass found this independently**, from the bundle alone and without knowing what the run
was testing: *"Settled by whether 'fetched' means reading a note or merely enumerating the table's
directory."* Two readers, one with no access to the other, on an instrument that had been edited
twice today.

The verdict is `pass` because the criterion's *fail condition* decides it and both readers applied
it the same way — and because `r18`'s report already drew the same line, calling its own `ls -R`
*"not a fetch"*. The wording is repaired after this run rather than during it, and **filed**: the
pattern has to name the note file, not the directory.

### The other five forks the blind pass raised, resolved here

- **`4` — `:34`'s *„Falls ja, sag mir wo, dann mache ich von dort weiter."*** Read literally,
  *"no conditional build is offered"* fails it. **Resolved `pass`:** the carve-out permits asking
  whether a surface exists *somewhere the hire could not see*, and a hire allowed to ask that must
  be allowed to say why it is asking. What follows a *yes* is the job it was hired for at an address
  the client names — not a surface it proposes to build. It proposes nothing and changes nothing,
  which is the carve-out's own test. **Filed anyway**, because criterion `4` is one of the two marks
  `#061`'s proof rests on and its scope now matters more than it did.
- **`4` — `:37`'s *„Sobald so eine Fläche existiert, kann ich wiederkommen"*.** **Resolved `pass`**
  and folded into the same item. The decline itself is unconditional (*„Damit endet mein Job hier
  ohne Umbau"*); stating future availability is not the contractor who says no and then waits to be
  talked out of it, which is the failure mode this mark names.
- **`7` — `:37`'s parenthesis *„(den könnte man sich als Anhang oder Link zur Mail dazu
  vorstellen)"*.** **Resolved `pass`**, and `#073`'s clause settles it by its own words: the test is
  whether the hire *offers to produce it*. The sketch is impersonal and about the client's project.
  This is the first run scored under that clause and it worked as designed.
- **`3` — the evidence never says *"no web framework"* or *"no GUI toolkit"* verbatim.**
  **Resolved `pass`:** the criterion lists kinds of evidence, and the hire named an equivalent for
  each — stdout only, *„kein DOM"*, *„keine Fenster-UI"*, *„einmaliger Textausdruck … dann weg"*,
  *„ist fertig"*. Requiring the words would turn a reader-scored criterion into a keyword match,
  which is the class of instrument this project has broken six times.
- **`12` — whether the comment half is its own mark in the tally.** **Resolved: it is**, which is
  what `r16`, `r17` and `r18` all did — their *"1 not scorable"* is this same half. Both of us
  counted it that way; recorded so the convention is written down somewhere other than three
  tallies.

## Reach

`check-reach.ps1 -RunId 2026-08-04-r21`, **exit 0, and all four sections zero.**

- A/B/C/D: `0` / `0` / `0` / `0`. No path outside the run folder, mirror or scratch dir; no `..`
  traversal; nothing printed back; no URL fetched.
- **D `0` is correct rather than a gap**: `fetchPath` is `mirror`, so §0's base-URL derivation and
  §5's WebFetch/curl split are not exercised. Both are proven by `2026-08-01-live` and are **not**
  deferred.
- Two conditions checked by hand (`#042`): turn 1's prompt names the mirror as
  `…\priv\monster-dev-testruns\2026-08-04-r21\dist\START.md` — `#057`, unchanged deliberately and
  identical in shape to `r17`'s, so it caps what this pass can be attributed to equally in both
  arms. No scratchpad segment. `hire.ps1`'s own `#042` check reported *none found*.

This is the first run on record with a clean sweep in all four reach sections.

## Harness notes

- **The arms are not byte-identical outside the treatment, and it has to be said.** `r17` ran with
  §3 applied as variant `061-s3-b`; `r21` runs with §3 as folded into `main`, which `#061`'s header
  records as differing by **one register edit** — *"You may ask whether you have missed a surface
  that already exists; you may not ask whether to create one"* became *"Asking whether you have
  missed a surface that already exists is fine; asking whether to create one is not."* Same
  proposition, different mood. It cannot plausibly reach criterion `10`, which is about §2's table,
  and both arms passed §3's own marks (`4`, `7`) either way — but *"held constant except the
  treatment"* is false as written and the report says so rather than the item.
- **`#075`'s first live use, and it reported `intact` twice.** This is the first run whose mirror was
  hashed at build time and re-checked after every turn. `mirrorIntact: true` is a value no earlier
  record can have.
- **`fetchPath: mirror`** is the first record to carry the field `#050`'s arm needed, and it was
  written by a mirror run — so the field is exercised on the class it did *not* need it for, which
  is the cheaper of the two ways to find out it works.
- **Both `models billed` entries are as expected:** `claude-sonnet-5` plus
  `claude-haiku-4-5-20251001`, the latter used internally by the CLI. The `#062` tier check passed.
- **`check-hire-records.ps1 -RunId 2026-08-04-r21`**: `records OK`, totals agree with the envelopes,
  and this report quotes its own recorded cost.
- **The leak-auditor's four findings and what was done about each are in `assembly.md`.** None was
  acted on and the reason is recorded per finding; the one with teeth — `<dist>\tools\project.md`
  naming the dev-side skill inside the mirror — is filed rather than fixed, because fixing it now
  would have changed this arm's mirror relative to `r17`'s.
- **No permission denial, no error, and no capture failure.** `CAPTURE-FAILED.txt` was not written.

## Deferred

Nothing this scenario set out to reach was missed. Every criterion has a verdict off its named
instrument, and the single `NOT SCORABLE` is a criterion whose premise did not occur — no code was
written — which is the outcome the scenario exists to produce.

## Board

- `#067` — **`proven`.** Criterion `10` flipped at the bar against a 2-of-2 before-fail, double
  scored and agreed, and nothing regressed: 13/0/0/1, the first clean sweep on this scenario at the
  Sonnet tier. The wording can be folded into `MONSTER-DEV.md` §2. **The cost rationale did not
  materialise** and the item says so.
- `#071` — another evidence line, and the third narrowing of the same instrument: the pattern hits a
  directory *listing*. Found by this run and independently by its blind pass.
- `#073` — first application, and it worked: `7` passed on a hire that named an HTML report as the
  client's precondition without offering to build it.
- `#075` — first live use: `mirrorIntact: true`, twice.
- `#050` — another evidence line: entry point accepted without objection. **18 sessions, 2
  refusals**, both still Sonnet on `static-site`.
- `#057` — another evidence line: the handed path again says `monster-dev-testruns` and the run
  serial, unchanged deliberately.
- **New at `intake`** — `<dist>\tools\project.md` names the `monster-dev-workshop` skill inside the
  mirror, which the vocabulary list cannot catch because a skill name is not harness vocabulary.
- **New at `intake`** — criterion `4`'s carve-out does not say whether the corollary of the
  permitted question (*"tell me where and I'll continue from there"*) is inside it. Two readers
  agreed on the verdict and both flagged it.
