# `#030` — nobody knows whether a hire still asks its questions when the requirement is written down inside the project

| | |
|---|---|
| Status | `formulated` |
| Gate | `run` |
| Attribution | scenario defect |
| Criterion | `4a`, `7`, `14a` — the three §4 marks |
| Target file | `process/fixtures/spec-in-repo/` (new), `process/fixtures/spec-in-repo.md` (new), `process/scenarios/spec-in-repo.md` (new) |
| Evidence | owner decision `2026-08-02`, choosing option (c) of `#014` |
| Blocked on | nothing — the fixture and the scenario are this item's to write |
| Proof design | see below |

**Split out of `#014` by owner decision (option c).** `#014`'s second half asked where the
description of the job should live. Answer (a) — in the published demo only — landed with `#014`
and is applied. Answer (b) — in the fixture, phrased as a customer wish — was **not** rejected;
it was recognised as a different thing. It is not presentation, it is an experiment, and this is
it.

**What is unknown.** Every one of the eleven sessions on record was handed a vague brief and a
project that says nothing about what is wanted. §4 exists because a real customer is vague, and
three criteria measure what the hire does about that: `4a` (asked about repeat behaviour
unprompted), `7` (asked **before** building), `14a` (offered the monster choice at all). Those
three are among the marks this project's measurement leans on hardest, and `7` is the one it has
misattributed three times.

The question nobody has asked: **does a hire still ask when the answer is written down next to
it?** A real client's repository often *does* contain the spec — a ticket pasted into a README, a
`TODO` in the markup, a design note. If a written requirement in the working directory suppresses
the §4 round, that is a playbook gap worth knowing about, because production projects will have
one far more often than `static-site` does.

**Why the current wording allows it.** Nothing is wrong. `static-site` is a fixture about a page
with no requirement in it, which is a legitimate case and the one every run so far has measured.
The gap is coverage, not defect: there is no second fixture posing the opposite case.

**Proposed change.**

> A new fixture `process/fixtures/spec-in-repo/`, identical to `static-site` except that the page
> carries the requirement in the customer's own voice — the text `#014` settled on:
>
> > *Dies ist eine Beispiel-HTML-Seite, in der ein Easter-Egg einprogrammiert werden soll: ein
> > Monster, das von links nach rechts läuft, wenn Alt+A gedrückt wird.*
>
> It states what the **customer wants** and never what Monster-Dev should do. That distinction is
> the whole of `#015`: a paragraph of the second kind reached six of the first ten hires and it is
> why `new-run.ps1` now deletes a run folder whose target names the product. This text names no
> product, no section and no technique, and it will survive that scan — which is exactly why the
> scan is not sufficient on its own and the fixture note has to say what the text is for.
>
> A new scenario `process/scenarios/spec-in-repo.md`, with the **same** brief and the **same**
> answer script as `alt-a-left-to-right`, so the only difference between the two arms is the
> fixture. Criteria `4a`, `7` and `14a` are the marks under test; everything else is carried over
> unchanged and is expected not to move.
>
> **Never `static-site`.** Putting this text in the fixture ten runs have already used would end
> comparability with all of them at once, and `static-site` is the baseline every A/B on the board
> is read against.

**Proof design.** *`Gate: run`.* This is a coverage run, not a regression, so it is stated as an
A/B rather than as a flip:

- **Arm A** — `static-site`, `alt-a-left-to-right`, Sonnet. Ten of these exist; the most recent
  clean one on the current playbook is the before-arm.
- **Arm B** — `spec-in-repo`, same brief, same answer script, Sonnet.
- **Held constant:** model, brief, answer script, playbook revision, mirror. The fixture is the
  only variable.
- **What each outcome means, named in advance so neither can be read as a success afterwards:**
  if `4a` / `7` / `14a` hold in arm B, the §4 round survives a written spec and the playbook needs
  nothing — a real result and a boring one. If any of the three fails in arm B and passed in arm
  A, that is a playbook gap with a before-fail on record, and §4 needs a sentence about a project
  that already states its requirement.
- **The bar is Sonnet.** Opus passing `7` unaided is on record from `phase2`, so an Opus arm would
  measure nothing.

One thing this design cannot separate, stated rather than discovered later: a hire that reads the
spec and does not ask may be *suppressed* or may simply have nothing left to ask. The answer
script's questions are the control — if the hire skips the round but the answers it assumed match
the script, that is the second reading.

**Cost.**

- **A second fixture is a second thing to maintain**, and this one has to stay byte-comparable to
  `static-site` apart from the one paragraph. If they drift, the A/B stops being about the
  paragraph. Mitigation: `spec-in-repo` is created by copying `static-site` and adding one block,
  and its fixture note says so.
- **A run costs $1.60–$4 and the honest expectation is a null result.** That is the point of
  naming both outcomes in advance; a null here is worth having because three criteria currently
  rest on a condition nobody has varied.
- **`#022` is also waiting on a second fixture** — the §3 decline path, against `python-cli`. Two
  items now want the next run and they want different fixtures. Not this item's to settle, but
  whoever schedules a run should read both.
- **It adds a fixture whose README-adjacent text is the kind `#015` just removed everywhere else.**
  A reader who finds it without the fixture note will read it as a regression. Mitigated only by
  the note, which is why the note is a deliverable and not documentation.

**Log.**

- `2026-08-02` `formulated` — split out of `#014` by owner decision, option (c). Arrives
  `formulated` rather than `grilled` because the proof design above has not been argued with yet:
  in particular, whether the most recent `static-site` run is a usable arm A or whether arm A has
  to be re-run on the current playbook is open, and that decides whether this costs one run or two.
