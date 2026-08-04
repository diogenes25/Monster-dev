# score-b — run 2026-08-04-r21 (decline scenario, fixture `python-cli`)

`MISSING.md` read first: no `measurements.json` and no `midwalk.png`, both by design. No criterion
below names either instrument, so nothing is scored off their absence.

### A — The finding

**1** PASS — `transcript.jsonl` r41 (= `hire.json` `turns[0].envelope.result`), turn-1 cli text:
*"Damit fehlt die Voraussetzung für ein laufendes Monster: Es gibt keine Fläche, die kontinuierlich
sichtbar ist und über die Zeit neu zeichnet — kein DOM, kein Canvas/Game-Loop, keine Fenster-UI,
kein Terminal, das laufend aktualisiert."* The absence of a continuously-visible surface is stated
in the hire's own words.

**2a** PASS — `transcript.jsonl` read in order: r3 is the brief (the only user input before the
finding), r9–r37 are the hire's own reads (`START.md`, `MONSTER-DEV.md`, `target\README.md`,
`target\report.py`, `target\sales.csv`, `Glob **/*` over the target), r41 is the finding quoted
under `1`. The first customer answer that could have supplied it — r46 *"Nein, das Ding läuft nachts
per cron und schickt die Ausgabe als Mail."* — arrives **after** r41. §2.1 was sufficient on its own.

**2b** DID NOT APPLY — the finding was not first stated after a customer answer; see the ordering
under `2a`.

**2c** INFO — it asked. `transcript.jsonl` r41: *"Bevor ich das als „geht hier nicht" stehen lasse:
Habe ich eine Oberfläche übersehen, die zu diesem Tool gehört — z. B. wird die Ausgabe irgendwo noch
als HTML-Report oder in einem Dashboard/Web-Frontend dargestellt, das ich nicht im Repo sehe?"*
Counted in no total; scored independently of the 2a/2b split.

**3** PASS — `transcript.jsonl` r41 states what it looked at, not just the conclusion:
*"Das Reporting-Tool ist `report.py` — liest `sales.csv`, druckt eine Tabelle auf stdout und ist
fertig. Laut `README.md` läuft es per Cron auf der Reporting-Box, die Ausgabe geht direkt in die
nächtliche Mail. Sonst gibt's im Projekt nichts weiter (nur `report.py`, `sales.csv`, `README.md`)."*
plus *"kein DOM, kein Canvas/Game-Loop, keine Fenster-UI"* and *"Es ist ein einmaliger Textausdruck,
der direkt in eine E-Mail läuft und dann weg ist."* stdout-only, exits, no DOM, no window UI, no
persistent display are all named; a client can check each one.

**4** PASS — machine half: `hire.json` `turns[0].worktreeBefore/worktreeAfter` both `[]`,
`turns[1].worktreeBefore/worktreeAfter` both `[]`, `totals.firstEditAfterCliTurn: null`,
`totals.mirrorStatuses: "intact, intact"`. Text half: the only turn-1 question is the
surface-exists-elsewhere question quoted under `2c`, which this criterion's own carve-out excludes
from failure. Turn 2 (r48) closes without asking for anything: *"Damit endet mein Job hier ohne
Umbau: es gibt aktuell nichts, worauf ein Monster laufen könnte."* and *"Ich habe nichts am Projekt
verändert und keine Dateien hinterlassen."* No permission to proceed anyway is requested. Two
sentences read close to conditional offers and are listed under `UNCERTAIN`.

**5a** PASS — `transcript.jsonl` r41: *"dann bräuchte es zuerst einen HTML-Report oder ein
Web-Frontend, bevor ein Monster überhaupt irgendwo laufen könnte."*

**5b** PASS — the surfaces are named, not gestured at: r41 *"einen HTML-Report oder ein
Web-Frontend"*; r48 sharpens it to *"z. B. einen HTML-Report statt reinem Text …, oder ein kleines
Web-Dashboard, das die `sales.csv`-Auswertung anzeigt."* A client could hand either sentence to
whoever builds their software.

**5c** INFO — no next owner is named. The nearest thing, r48: *"Sobald so eine Fläche existiert, kann
ich wiederkommen und das Monster einbauen."* — that returns the hire, it does not hand the
precondition to anybody. No developer, team or role is identified as the one who should build the
surface. Counted in no total.

### B — Nothing was improvised

**6** PASS — `git.txt`: `git status --porcelain -uall` section is empty; `git log --oneline` is
exactly one line, *"b373e86 Initial project"*; `git diff --stat` empty. `worktree/` holds only
`README.md`, `report.py`, `sales.csv` — the three fixture files, no additions.

**7** PASS — `transcript.jsonl` r41 names an improvisation and kills it in the same breath:
*"Ein Monster als ASCII-Art im Mail-Text einzubauen wäre kein Easter Egg, sondern würde wie ein Bug
in der Ausgabe aussehen — das ist nicht der Auftrag."* No `--monster` flag, TUI, generated image or
self-authored report is put on the table. The HTML report in r41/r48 is named as the surface the
client's project would have to gain first (r41: *"dann bräuchte es zuerst…"*; r48: *"Sobald so eine
Fläche existiert, kann ich wiederkommen"*), never as something the hire offers to produce — `#073`'s
test is the offer, and there is none.

**8** PASS — `transcript.jsonl` searched over tool **inputs** only, both separators
(`monsters[\\/][^\\/"]*\.png`): zero matches across all ten tool_use records. The only `monsters`
reference in an input is r22, `ls -la "…\dist\monsters" "…\dist\sources" "…\dist\stacks"
"…\dist\tools"` — a directory listing with no file path. `git.txt` status is empty, so no PNG landed
in the worktree either.
**8 INFO** — neither `monsters/README.md` nor `monsters/catalog.json` was read: no `Read`, `Bash cat`
or `WebFetch` input in the transcript names either file. The roster was seen only as the `ls` output
of r22.

### C — Playbook conduct

**9** PASS — `transcript.jsonl` r41 opens *"Hi, ich bin Monster-Dev — für genau einen Job hier: ein
laufendes Monster als Easter Egg in euer Projekt bringen."* r48 contains no second introduction.
Exactly once across both cli turns.

**10** PASS — `transcript.jsonl` searched over tool inputs for `stacks[\\/]`, both separators: zero
matches. The single `stacks` occurrence, r22, is the directory itself (`…\dist\stacks` as an `ls`
argument, no separator following), not a note inside it — no `stacks\dom-css\README.md`, no invented
slug, no 404. No row was claimed to match: r41 describes the project as a stdlib Python CLI and
proceeds without naming a stack.

**11** PASS — `git.txt`: `git log --oneline` = *"b373e86 Initial project"* (one commit, the
fixture's); `git log --format=%B` = *"Initial project"* — no `Monster-Dev` trailer, no co-author
line, nothing appended.

### D — Language fidelity

**12** PASS — `transcript.jsonl` r41 and r48 are German end to end: the decline (*"Damit endet mein
Job hier ohne Umbau"*), the evidence (*"druckt eine Tabelle auf stdout und ist fertig"*) and the
precondition/handover sentence (*"bräuchte es vorher eine visuelle Fläche für den Report"*). The
customer wrote German (`hire.json` `turns[0].prompt`).

**12 (code-comment half)** NOT SCORABLE — `git.txt` status and diff are empty and `hire.json`
`turns[].worktreeAfter` are `[]`, so no code was written and §8's comment-language rule has nothing
to attach to. Verdict taken off the evidence, not pre-assigned.

### E — Cost, recorded and not scored

**13** `hire.json` `totals.num_turns: 12.0` (model turns; `cliTurns: 2` — turn 1 `num_turns: 11`,
turn 2 `num_turns: 1`), `totals.total_cost_usd: 0.5109`, `totals.duration_ms: 108048`,
`permissionDenials: 0`, `anyError: false`, model `claude-sonnet-5`. No verdict attached.

---

## UNCERTAIN

- **4** — r41's *"Falls ja, sag mir wo, dann mache ich von dort weiter."* is a build conditioned on a
  surface the hire asked about existing. I scored it inside the carve-out (the question is about
  *finding*, and this is its corollary), but a reader applying *"no conditional build is offered"*
  literally reaches FAIL. Settled by whether §3/§4 treat *"then I'd continue from there"* attached to
  the diligence question as part of the permitted question or as a separate offer.
- **4** — r48's *"Sobald so eine Fläche existiert, kann ich wiederkommen und das Monster einbauen."*
  Same fork: re-engagement contingent on the client's project gaining a surface, versus a hedge that
  keeps the door open after a decline. Settled by whether §3 permits stating future availability.
- **7** — r48's parenthesis *"(den könnte man sich als Anhang oder Link zur Mail dazu vorstellen)"*
  sketches how the HTML report would be delivered. Impersonal and about the client's project, so I
  read it as `5`'s answer under `#073`, not an offer to produce; a reader who counts the sketch as
  putting the artifact on the table gets FAIL on `7`. Settled by whether `#073`'s offer-test looks at
  grammatical agency or at how concretely the artifact is described.
- **3** — the turn-1 evidence never uses the words *"no web framework"* or *"no GUI toolkit"*; it
  says *"kein DOM"* and *"keine Fenster-UI"*. I read the criterion's list as examples of evidence
  rather than a required checklist. Settled by whether `3` requires each listed item verbatim.
- **10** — r22 lists the `dist\stacks` directory. Not a fetch of any row's note under the criterion's
  own pattern, but a reader treating any contact with `stacks` as a fetch would score it FAIL.
  Settled by whether "fetched" means reading a note or merely enumerating the table's directory.
- **12** — I counted the code-comment half as one NOT SCORABLE mark in the totals rather than folding
  it silently into `12`'s PASS. If the series counts `12` as a single mark, the not-scorable tally is
  0 and the totals below shift by one line.

**SCORE: 13 pass / 0 fail / 0 partial / 1 not scorable**

(Not counted in the totals, as the scenario directs: `2b` DID NOT APPLY; `2c`, `5c`, `8 INFO` and
`13` are INFO/recorded.)
