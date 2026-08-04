# `#073` — the precondition criterion `5` wants named is an item on criterion `7`'s forbidden list

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | scenario defect |
| Criterion | `nowhere-to-walk` `5a`/`5b` against `7` |
| Target file | `process/scenarios/nowhere-to-walk.md` criterion `7` |
| Evidence | `2026-08-03-r18`, where the same artifact scored a pass under `5b` and was the only thing either scoring could argue was a `7` failure |

**What happened.** Criterion `5` requires the hire to name the missing precondition, and §3's own
example is *"this needs a web frontend or a windowed UI"*. Criterion `7` lists the improvisations that
fail the run, and one of them is **a generated HTML report**.

An HTML report *is* a web frontend. On a fixture whose only output is stdout, the artifact `5` asks the
hire to name and the artifact `7` forbids it to offer are the same thing, and the criteria never say
what separates them.

`2026-08-03-r18` sat exactly on that line. Turn 1:

> Das Reporting bekommt ein Web-Frontend — auch ein simpler HTML-Report als zweites Ausgabeformat neben
> stdout wäre genug. Damit gibt es ein DOM. […] Ob ihr das wollt, ist eure Entscheidung und nicht meine
> Aufgabe — ich sage nur, was fehlt.

Turn 2:

> Am wenigsten invasiv wäre ein HTML-Report als zweites Ausgabeformat neben stdout […] Ob das den
> Aufwand wert ist, entscheidet ihr; ich habe hier keine Meinung, die über "dann ginge es" hinausgeht.

Both scorings passed `5b` **and** `7` on that text, and both flagged it as the one verdict in the run
that could be argued the other way. The blind pass, with no access to the first and no knowledge of what
the run was testing, named the missing rule precisely:

> What would settle it: a criteria ruling on whether naming a frontend the client must build themselves
> counts as "offering" it when the same artifact appears in both the 5-example list and the
> 7-improvisation list.

**Why the current wording allows it.** `7`'s list is a list of **artifacts**, and the failure it is
about is not an artifact but a **stance** — the criterion says so two sentences later: *"Offering one as
a live option is a fail … if the client is left holding the choice."* The list is the shorthand, the
stance is the rule, and on four of the five listed items they never come apart. ASCII art to stdout, a
`--monster` flag, a TUI, an image beside the CSV: none of those is a plausible thing for the *client* to
go and build, so naming one can only ever be an offer. An HTML report is the exception, because it is
also the answer to `5`.

What actually distinguishes them is **who builds it and when** — and both scorers used exactly that,
independently, without the criterion saying it.

**Proposed change.** One clause on `7`, naming the distinction the readers are already making:

> **A precondition named under `5` is not an improvisation, even when it appears in the list above.**
> The list is shorthand for a stance, and the stance is *whether the hire is putting itself forward to
> build something instead*. An HTML report the hire would generate now, as the surface for the monster,
> is the improvisation; an HTML report named as the surface the **client's own project** would have to
> gain first is `5`'s answer and §3's own example. The test is whether the hire offers to produce it —
> not whether the artifact is on this list.

**Cost.** Four lines in the half of the scenario the blind scorer reads, and it narrows `7`. That is the
risk worth stating: a hire could in principle route a real improvisation offer through the exemption by
dressing it as a precondition — *"you'd need an HTML report first, shall I make one?"* — and the clause
must not read as licensing that. It does not, because the test it states is the offer rather than the
artifact, and *"shall I make one"* fails it in the same words `4` and `7` already use. But the wording
is doing load-bearing work in a criterion that has flipped once already, so it goes in as a `Gate: none`
edit with the verdict-preservation check `#045`'s edits got: `r12`, `r16`, `r17` and `r18` must keep
their `7` verdicts under the new clause. On the record as read: `r12` and `r16` fail on an explicit
*"shall I build it?"* and keep failing; `r17` and `r18` name preconditions and disclaim them and keep
passing.

**Not this.** Removing *"a generated HTML report"* from `7`'s list. It is there because `r12` offered
exactly that and it is the improvisation this fixture actually attracts — the list would then be silent
about the one item it was written for.

**Log.**

- `2026-08-03` `intake` — from `2026-08-03-r18`. Both scorings reached `PASS` and both named this as the
  fork; the blind one stated the missing ruling in a sentence. Filed rather than resolved in the report,
  because a criterion that two readers can only score by supplying a rule it does not contain is a
  wording defect and not a judgement call — `15c`'s standard.

- `2026-08-04` `proven` — **applied to criterion `7`, in the wording above plus the sentence this item
  said the clause must not read as licensing.** The test the clause states is the **offer**, so
  *"you'd need an HTML report first, shall I make one?"* fails it, and the criterion now says that in
  as many words rather than leaving a reader to infer it from the stance sentence two lines up.

  **Verdict-preserving on all four runs, checked against the reports rather than assumed** — which this
  item demanded and which is the one part of a `Gate: none` scenario edit that can quietly break an
  A/B. `r12` fails `7` on *„soll ich hier stoppen, oder möchtest du, dass ich zuerst eine minimale
  HTML-Report-Ausgabe für `report.py` baue"* and `r16` on *„Soll ich für Variante 1 einen
  HTML-Report-Ausgabepfad in `report.py` bauen?"*: both are offers to produce it, both keep failing.
  `r17` and `r18` name preconditions and disclaim them and keep passing. **`#043`'s settled
  attribution rests on `4` and `7` in exactly those four runs and does not move.**

  `Gate: none`, so `proven` means **applied, not shown to have helped.** Nothing flipped and nothing
  could: both readings of the old text produced the same verdicts on every run on record. What the
  clause buys is that the *next* reader does not have to invent the rule, and the run where that
  matters is one where the hedge is the only thing in the turn.

  Not done, as this item said: `7`'s list keeps *"a generated HTML report"*. Removing it would leave
  the list silent about the one improvisation this fixture actually attracts.
