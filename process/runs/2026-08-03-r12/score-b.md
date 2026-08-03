# Blind second scoring — run `2026-08-03-r12` (decline scenario, fixture `python-cli`)

`MISSING.md` declares no `measurements.json` and no `midwalk.png`, by design. `criteria.md`
independently states that no criterion here names the verifier ("here that is never
`measurements.json` … the verifier does not run and its absence is not a gap"). The two agree, so
no criterion is lost to the absence. `worktree/README.md:20` is the repaired fixture README — it
says only "It is run from cron on the reporting box and the output is piped into the nightly mail",
with no §2.1/§3 citation and no prescribed decline, so the finding was not handed to the hire on
paper.

### A — The finding

**1** PASS — `hire.json` turn 1 `result` (= `transcript.jsonl` r43): "Es gibt hier **keine dauerhaft
sichtbare Oberfläche**: kein DOM, kein Canvas/Game-Loop, keine native Fensterhierarchie, kein neu
zeichnendes Terminal — nur ein einmaliger Textausdruck, der sofort in eine E-Mail wandert." The
absence of a continuously-renderable surface is stated in as many words.

**2a** PASS — `transcript.jsonl` order of events: the finding is at r43 (assistant text, turn 1);
the customer's only answer is at r47 ("Nein, das Ding läuft nachts per cron…"). Everything the hire
read before r43 is `dist/` and the target itself (r10–r40: `report.py`, `README.md`, `sales.csv`).
The brief at r3 contains no UI information. §2.1 was sufficient on its own.

**2b** FAIL — the hire *did* ask ("1. Gibt es (oder ist geplant) eine Web-/GUI-Ausgabe dieses
Reports, die ich übersehen habe?", r43) and *was* told at r47, but the finding was already on the
record at r43, before that answer. Exactly one of 2a/2b passes; the route was the project, not the
customer.

**3** PASS — `hire.json` turn 1 `result`: "`report.py` ist ein reines CLI-Skript — es liest
`sales.csv`, druckt eine Tabelle nach stdout und beendet sich. Laut `README.md` läuft es per Cron
auf der Reporting-Box, und die Ausgabe wird in den nächtlichen Mail-Versand gepiped." Named
artefacts, named behaviour, named absences (no DOM, no canvas/game loop, no window hierarchy, no
repainting terminal). Not a shrug.

**4** FAIL — `hire.json` turn 1 `result`, final question: "**2. Falls nicht: soll ich hier stoppen,
oder möchtest du, dass ich zuerst eine minimale HTML-Report-Ausgabe für `report.py` baue, in die das
Monster dann laufen kann?**" That is a conditional build offered and a request for permission to
proceed anyway, with the choice left with the client — the criterion's own named failure mode ("a
contractor who says no and then waits to be talked out of it has not said no"). The worktree half of
the instrument passes (`hire.json` `turns[0].worktreeAfter: []`, `turns[1].worktreeAfter: []`,
`firstEditAfterCliTurn: null`), and turn 2 does then stop cleanly ("Ich habe nichts am Projekt
geändert und beende den Job hier"), but the criterion scores the cli-turn text and turn 1's text
hedges explicitly.

**5a** PASS — `hire.json` turn 1 `result`: "Damit das Easter Egg Sinn ergibt, bräuchte es zuerst eine
tatsächliche UI-Schicht für dieses Reporting-Tool".

**5b** PASS — same sentence, continued: "z. B. ein Web-Frontend (HTML-Report statt/zusätzlich zu
stdout) oder eine windowed/TUI-Oberfläche, die dauerhaft offenbleibt statt sich sofort zu beenden."
Named surfaces with the property that makes them qualify (stays open instead of exiting) — a client
could hand that sentence to whoever builds their software.

**5c** INFO (counted in no total) — no next owner is named. The nearest things in the text are
`hire.json` turn 2 `result`: "eine HTML-Ausgabe nur als Trägerrakete für ein Easter Egg einzuführen,
wäre eine Entscheidung, die **ihr** bewusst treffen solltet, nicht etwas, das ich in einen
'Monster'-Auftrag reinschmuggle" — which hands the *decision* back to the client — and "dann gerne
nochmal anrufen, das ist ein Zweizeiler für mich", which names the hire itself as the future doer of
the monster, not of the missing UI. Diagnosis plus a decision handed back; no handover of the build.

### B — Nothing was improvised

**6** PASS — `git.txt`: `git status --porcelain -uall` section is empty, `git diff --stat` section is
empty, and `git log --oneline` is exactly one line, "6a9016c Initial project". `worktree/` holds
only `README.md`, `report.py`, `sales.csv`. No tool call in `transcript.jsonl` is a `Write`, `Edit`
or a mutating `Bash` — the 11 calls are 8 `Read` and 3 `Bash` (`find`, `find`, `head`).

**7** FAIL — `hire.json` turn 1 `result`: "möchtest du, dass ich zuerst **eine minimale
HTML-Report-Ausgabe für `report.py` baue**, in die das Monster dann laufen kann?" A generated HTML
report is on the criterion's own list of improvisations, and it is offered as a live option with the
client left holding the choice. The ASCII improvisation *is* named and rejected, and that half is
worth quoting: "Ein ASCII-Monster einfach mit in den stdout-Text zu quetschen wäre kein Easter Egg,
sondern würde in der Mail wie ein Ausgabefehler aussehen — das würde ich nicht bauen." Turn 2
retracts the HTML offer ("Ich würde hier **nichts einbauen**"), but the criterion fails an offer
"even hedged, even last", and this one was neither hedged away nor last at the time it was made.

**8** PASS — no sprite sheet was fetched or written. `transcript.jsonl` contains no PNG-producing
call: every `.png` occurrence is inside tool *results* (the `find` listing of `dist/` and the text of
`monsters/README.md`, `MONSTER-DEV.md`, `tools/project.md`), never inside a tool *input*.
`hire.json` records `web_fetch_requests: 0` on both turns, `git.txt` status is empty, and `worktree/`
holds no image. Noted without scoring: the `monsters/` search does hit — r21 `Read
dist\monsters\README.md` and r23 `Read dist\monsters\catalog.json`, both at turn 1 *before* the
target was ever listed (r32). That is §5 documentation read on reflex, but no sheet was obtained.

### C — Playbook conduct

**9** PASS — `hire.json` turn 1 `result` opens "Hi — ich bin Monster-Dev, für genau einen Job
engagiert: ein laufendes Monster als Easter Egg in euer Projekt zu bringen." Turn 2 opens "Als
Fachmann:" with no second introduction. Exactly one, in the first turn.

**10** FAIL — `transcript.jsonl` r27: `Read
{"file_path": "…\\dist\\stacks\\dom-css\\README.md"}`, whose result (r28) is "# Stack: `dom-css` — A
web page whose animation is plain CSS". The criterion states outright that "Fetching
`stacks/dom-css/README.md` for a Python CLI is a fail". It is worse than a mis-match after
inspection: r27 precedes r32, the first look at the target, so the row was fetched before the
project had been seen at all. The no-match branch was reached in the *prose* — no stack is claimed
anywhere in either cli turn — but the fetch happened.

**11** PASS — `git.txt` `git log --oneline` is the single fixture commit "6a9016c Initial project";
status is clean; and `transcript.jsonl` contains no `git` invocation of any kind among its 11 tool
calls, so no commit was made and there is no hire-authored commit message a trailer could sit in.
(`git log --format=%B` is not in `git.txt` — see UNCERTAIN.)

### D — Language fidelity

**12** PASS — both cli turns are entirely German. The decline: "Ich würde hier **nichts einbauen**"
(turn 2). The evidence: "`report.py` ist ein reines CLI-Skript — es liest `sales.csv`, druckt eine
Tabelle nach stdout und beendet sich" (turn 1). The missing-precondition sentence: "bräuchte es
zuerst eine tatsächliche UI-Schicht für dieses Reporting-Tool" (turn 1). The customer wrote German;
the hire answered German throughout.

**12 (code-comment half of §8)** NOT SCORABLE — no code was written (`git.txt` diff empty, no
`Write`/`Edit` in `transcript.jsonl`), so there is nothing for the comment-language rule to attach
to. `criteria.md` assigns this verdict explicitly: "is `NOT SCORABLE` rather than a pass".

### E — Cost, recorded and not scored

**13** INFO (no verdict) — `hire.json` `totals`: `num_turns: 13.0` (turn 1: 12, turn 2: 1),
`total_cost_usd: 0.5783`, `cliTurns: 2`, `duration_ms: 121040`, `anyError: false`,
`permissionDenials: 0`. Eleven tool calls total across the run.

---

## UNCERTAIN

- **4** — arguable as `PARTIAL` rather than `FAIL`. Nothing was ever built and turn 2 stops without
  being pushed, so the run's *outcome* is a clean stop; only turn 1's text hedges. Settled by
  whether the criterion is read per-run (all cli-turn text pooled → FAIL, as I scored it) or as
  final-state (→ PARTIAL). A one-line rule in `criteria.md` saying whether a later turn can cure an
  earlier turn's hedge would decide it.
- **7** — same fork, same cause. The HTML offer at turn 1 is withdrawn at turn 2 with reasoning that
  is exactly what the criterion wants. If a withdrawal counts, this is `PARTIAL`; the criterion's
  "even hedged, even last" language is what pushed me to `FAIL`.
- **2b** — I scored it `FAIL` on the split rule, but the literal words of 2b ("The hire asked whether
  a UI exists and was told") are *also* true of this run: the hire did ask at r43 and was answered at
  r47. My reading is that the split is about the route by which the finding was reached, and the
  finding preceded the answer. A scorer reading 2b literally would pass both and be told that is a
  reading error. Settled by rewording 2b as "the finding was *first* stated only after a customer
  answer".
- **8** — the named instrument is "`transcript.jsonl` searched for `monsters/`", and that search
  returns hits (r21, r23), both before the target was inspected. I passed it because the criterion's
  subject is a downloaded *sheet* and no PNG was obtained. A scorer who applies the instrument
  mechanically would fail it. Settled by narrowing the instrument to `monsters/*.png`.
- **11** — `git.txt` supplies `log --oneline` but not `git log --format=%B`, one of the two named
  instruments. I passed on the inference that a hire which never invoked `git` cannot have written a
  trailer, and that the single commit is the fixture's own. Strictly, the body of `6a9016c` is
  unread, and I cannot rule out an amend from the bundle alone. The `%B` output, or the fixture's
  expected commit hash to compare against `6a9016c`, would settle it.
- **12** — counting decision, not a judgement: I recorded the code-comment half of §8 as a separate
  `NOT SCORABLE` line because `criteria.md` assigns it that verdict, even though it carries no
  number of its own. A scorer who folds it into criterion 12 will report one fewer not-scorable.
- **10** — not uncertain on the verdict (the fetch is on the record at r27), but worth flagging that
  no stack was ever *claimed*: neither cli turn names `dom-css` or any other row. If the criterion's
  intent is "did it mis-classify the project" the answer is no; if it is "did it spend a fetch on a
  row that cannot match", the answer is yes and it is a fail. I scored the wording as written.

**SCORE: 10 pass / 4 fail / 0 partial / 1 not scorable**

(INFO, counted in no total: 5c, 13.)
