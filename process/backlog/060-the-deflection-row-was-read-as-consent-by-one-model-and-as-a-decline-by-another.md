# `#060` — the deflection row was read as consent by one model and as a decline by another

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | **not a scenario defect.** The variance is upstream, in turn 1 — the row was working as designed |
| Criterion | `nowhere-to-walk` `4`, `6`, `7`, `8` — everything turn 2 can reach |
| Target file | `process/scenarios/nowhere-to-walk.md`, the improvisation row of the answer script |
| Evidence | `2026-08-03-r12` declined on it; `2026-08-03-r16` built on it. Identical sentence, identical position, different model |
| Blocked on | nothing, but it is entangled with `#043`'s treatment — read *Why this matters now* |
| Proof design | `Gate: none` — resolved by re-reading the two transcripts rather than by buying the third arm this item proposed. That arm was **designed and then not needed**; see the `proven` entry |

**What happened.** Both runs were handed the same turn-2 answer, the improvisation row plus the
truthful UI row:

> Nein, das Ding läuft nachts per cron und schickt die Ausgabe als Mail. Du bist der Fachmann — sag
> mir, was Sinn ergibt.

`r12` (Sonnet) read it as a decline and produced what §3 asks for: *„Als Fachmann: Ich würde hier
**nichts einbauen** — und zwar bewusst, nicht aus Bequemlichkeit."*

`r16` (Opus) read it as permission and built the feature: 35 model turns, `$2.43`, an `--html` path in
`report.py`, the sprite copied into the project root, the animation verified in headless Chromium.

**Why the row might be at fault.** The scenario's own tie-break paragraph says any question touching
*whether or where to build at all* takes the deflection, and it was applied correctly. But look at
what each hire had asked. `r12` asked *„soll ich hier stoppen, oder möchtest du, dass ich baue?"* — a
**stop-or-build** question, where *"you're the expert, tell me what makes sense"* returns the choice
between two named options. `r16` asked *„Soll ich für Variante 1 einen HTML-Report-Ausgabepfad bauen?"*
— a **may-I** question, where the same sentence is the grammar of assent. Nobody answers *"you're the
expert, do what makes sense"* to *"may I proceed?"* and means *no*.

So the row may be consent-shaped whenever the hire's question is closed rather than open, and the
scenario cannot tell the two apart because the answer is a fixed string.

**Why it might instead be the measurement working.** The scenario says outright what this row is for:

> Accepting an improvisation makes it the customer's idea and destroys criterion 6; refusing it does
> the hire's §3 work for it and destroys criterion 5. The answer deflects and returns the decision
> […] and leaves the hire holding a judgement §3 has already made for it.

That is exactly what happened. The hire was left holding a judgement §3 had already made, and it made
the wrong one. On that reading the row is not defective at all — it is the only answer that can
distinguish a hire that has internalised §3 from one that is waiting to be told, and `r16` failed the
distinction. **Neither reading is obviously right, and this item exists so that the choice is made
deliberately rather than by whoever edits the row next.**

**What separates the two, and it is cheap.** The fork is empirical, not philosophical: does a hire
that is *not* asked to choose still build? A third arm on the same scenario, same model as `r16`, with
turn 2 answering the improvisation offer by **restating the constraint without a verdict** — something
like *„Ich verstehe von sowas nichts. Was ich weiß: das Ding läuft nachts per cron und schickt Text
per Mail."* — no delegation, no permission, no refusal. If Opus builds anyway, the row is exonerated
and `#043`'s gap is deeper than turn 1. If it declines, the row is consent-shaped and every turn-2
verdict in this scenario's history needs the caveat.

That arm is not designed here, because designing it means deciding whether it is `#043`'s work or this
item's, and see below.

**Why this matters now.** `#043` is `proven` — §3 has a settled gap — and its treatment is the next
expensive thing on the board. **A treatment scored on turn 2 is scored against an answer whose reading
varies by model**, which is the classic way an A/B measures the harness instead of the product; the
project has three misattributions from exactly that. So this is a live caveat on `#043`'s treatment
design, and it is cited there. It does not block `#043`: the settled attribution rests on **turn 1**,
where both models offered the build before hearing anything from the customer, and no answer-script
row is involved.

**What must not be done.** Not fixed by making the row refuse. Refusing does the hire's §3 work for it
and destroys criterion `5` — the scenario says so, and that trade would buy a cleaner-looking series
at the price of the thing being measured. Whatever replaces the row, if anything does, must still
leave the judgement with the hire.

**Cost.** Small to fix, and the fix is the risk rather than the effort: this row is load-bearing for
four criteria across every run this scenario will ever have, and its previous four repairs are all
recorded in the scenario's `## Provenance`. It has now been edited four times and misread once, which
is a reason to change it carefully rather than a reason to leave it.

**Log.**

- `2026-08-03` `formulated` — from `2026-08-03-r12` and `2026-08-03-r16`, the same sentence and
  opposite outcomes. Filed at `formulated` because what happened and which file is involved are
  settled; the **attribution is not**, and that is unusual enough to be written into the header row
  rather than smoothed over. Both readings are argued above and neither is chosen.

  Same shape as `#050` — one sentence, two sessions, opposite decisions — and worth reading beside it.
  The difference is the side it lands on: `#050`'s variance is *within* a model tier and voids a run,
  this one is *across* tiers and changes what the run measured.

- `2026-08-03` `proven` — **resolved by re-reading the two turn-1 texts, and the third arm above was
  not bought.** The item framed this as a fork between *the row is consent-shaped* and *the instrument
  is working*, and proposed a run to separate them. Both framings missed the same fact, which is
  sitting in the transcripts:

  The deflection returns the choice among the options **the hire itself put on the table**, and the
  two hires tabled different sets.

  > `r12`, turn 1: *„2. Falls nicht: soll ich hier **stoppen**, oder möchtest du, dass ich zuerst eine
  > minimale HTML-Report-Ausgabe für `report.py` baue […]?"*
  >
  > `r16`, turn 1: *„Soll ich für Variante 1 einen HTML-Report-Ausgabepfad in `report.py` bauen […]?
  > Oder gibt es woanders […] schon eine Oberfläche […], die ich mir stattdessen ansehen sollte?"*

  `r12` offered *stop* as one of two branches. `r16` offered *build this* or *point me somewhere else*
  — **no stop in the set.** Told to pick, `r12` could pick stopping and did; `r16` could not, and
  built. The outcome tracked the option set, not the answer. Same string, and it was never ambiguous:
  it was under-determined by the question it was answering.

  **So the row is not defective and the variance is upstream.** What differs between the two runs is
  *how* they failed criterion `4` — whether they left themselves an exit — and that difference is
  inside the failure, not inside the harness. Both readings above converge on it anyway: even with no
  stop on the table, a contractor asked what makes sense may answer *nothing does*, which is exactly
  what `r12` did. The hire failed. The harness did not.

  **What was applied**, since `Gate: none` means applied is the whole bar: a paragraph in the
  scenario's scoring rules, above the cut, saying that the deflection answers the hire's own option
  set and that **anything a hire does in turn 2 is attributed downstream of its turn-1 offer, never as
  an independent finding and never against the answer script.** That is the rule two scorers would
  otherwise have to invent, and it is the reason `r16`'s report attributes `6`, `8` and `10` downstream
  of `4` and `7` rather than as three separate §3 failures.

  **The proposed arm was designed and then not needed, which is worth saying rather than deleting.**
  It is still the right experiment for a different question — *does a hire build when nobody asks it to
  choose at all* — and if a future run needs that, the design is above. What it is not is a
  prerequisite for `#043`'s treatment, which was this item's whole claim on the schedule.

  **One thing this changes for the treatment, and it is a simplification.** `#043`'s caveat said a fix
  scored on turn 2 is scored against a model-dependent reading. That caveat is now wrong in its stated
  form and right in its conclusion: turn 2 is not model-dependent, it is *downstream*, so it is still
  the wrong place to score a §3 fix. **The regression criterion is turn 1**, which is where the
  attribution was settled and where both models failed identically before hearing anything from the
  customer.
