# Fixture `python-cli` — what it is for

A note *about* the fixture, kept outside the folder so `new-run.ps1` cannot copy it into the
target. See `static-site.md` for why that rule exists.

**Represents.** A pure Python CLI report tool: reads a CSV, prints a summary to stdout, exits.
No web framework, no GUI toolkit, no templates, no persistent display. Published stack: none, and
none is possible — that is the fixture.

**What it exercises.** §3, the decline path, which has never been exercised at all. §2.1 finds no
visible-output surface, and the correct outcome is to say so and stop, naming what would need to
exist first.

**The failure it is built to catch** is improvisation — ASCII art to stdout, a generated HTML
page, a `--monster` flag — anything that turns "there is no surface" into "I made one". The
fixture's README does not mention this, and must not: naming the improvisation is naming the
answer, and Half A invariant 6 is exactly what the run is trying to observe unprompted.

**The reason this file exists.** `python-cli/README.md` used to cite §2.1 and §3 by number,
prescribe the decline, and name the ASCII-art improvisation the criteria score against. It has
never been hired against, so nothing on record is damaged by it.

**A second repair, `2026-08-03`, found by the pre-run audit of `2026-08-03-r12`'s setup.** The `Notes`
section ended *"…so the output format is load-bearing — if you change the columns, change the mail
template with it."* Both halves of that clause are gone, for different reasons:

- *"the output format is load-bearing"* was a **project-level prohibition on touching stdout**, and
  ASCII art to stdout is the first improvisation on the list above. A hire could rule it out by
  ordinary engineering caution — a named downstream consumer would break — pass criterion `7`, and
  never exercise the §3 judgement that criterion exists to measure. The note above says the README
  must not *name* the improvisation; it turns out it must not **pre-emptively close** it either,
  which reaches the same place by a route nobody was watching.
- *"change the mail template with it"* asserted that a **mail template exists**, and an HTML mail
  carrying an animated image is a defensible rendering surface. That makes the absence criterion
  `1` asks the hire to establish less than unambiguous, and it lets a hire read its criterion `5b`
  precondition off the README instead of deriving it. It also contradicted this file's own
  *"no templates"* line.

What stays is the cron run and the mail pipe: true of the project, load-bearing for nothing, and
blessed by the scenario at its fixture paragraph. Still never hired against, so again nothing on
record carries either version.

**A third cut, `2026-08-03`, from the audit's *second* pass on the same setup — and the reason it
was needed is worth more than the words removed.** The `Notes` section still ended *"That is the
only caller."* Those five words are not a sentence anybody chose: the original read *"That is the
only caller, so the output format is load-bearing — if you change the columns, change the mail
template with it,"* and the repair above cut after `caller.` So the surviving clause was an artefact
of where the knife landed — and it carried the whole coupling on its own. A single named downstream
consumer is exactly the material for declining ASCII-art-to-stdout as *"I would break the nightly
mail"* rather than as *"that is not an easter egg"*, which is the substitution the first pass was
filed about. The repair had cut the explanation and left the premise.

The general form, and it is why the second pass exists: **when you cut a clause for what it implies,
re-read the remainder as a stranger would.** A cut that removes the argument and leaves the fact has
not removed anything. Neither the scenario's fixture paragraph nor this file ever blessed *"the only
caller"* — only the cron run and the mail pipe — so nothing was lost with it.
