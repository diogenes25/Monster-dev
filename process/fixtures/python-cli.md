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
