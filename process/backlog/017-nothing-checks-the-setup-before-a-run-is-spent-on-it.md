# `#017` — nothing looks at the run folder and the mirror before a hire, so a setup that answers the question is found afterwards or never

| | |
|---|---|
| Status | `proven` |
| Gate | `none` |
| Attribution | owner decision |
| Criterion | whichever the setup happens to pre-answer — `8`, `9` and §2.4 so far |
| Target file | `.claude/agents/leak-auditor.md` (new), `SKILL.md` Half B, between steps 4 and 5 |
| Evidence | `#015` — three fixtures, ten runs, found `2026-08-02` by looking on purpose |
| Proof design | — |

**What happened.** Two checks run before a hire and both are mechanical. `build-dist.ps1` verifies
that `process/`, `.claude/` and `CLAUDE.md` are absent from the mirror and deletes one that leaked.
`check-isolation.ps1` walks the run folder's ancestry for `CLAUDE.md` and confirms one commit. Both
answer *"did the harness leak a file it names"*.

Neither answers the question `#015` turned out to need: **does anything in this setup already answer
what the run is trying to measure?** The fixture READMEs passed both checks for ten runs while
telling the hire to *pick `assets/`* and that *plain CSS is the obvious idiomatic choice* — the
substance of criteria `9` and `8`. The two fixtures nobody has run yet cite `MONSTER-DEV.md` section
numbers and prescribe the answer outright.

It was found by reading the fixture on purpose, prompted by an unrelated question. Nothing in the
procedure would have produced that reading.

**Why the current wording allows it.** The procedure's leak model is a **path** model. Guardrail 4
is about `process/` and `.claude/`; step 2 is about what the mirror contains; step 4 is about the
ancestry. `new-run.ps1`'s header states the rule that would have caught it — *"A recipe stored
beside the fixture would be copied into the target with everything else"* — but states it about
recipes, and the fixture's own files are the one thing every check treats as legitimately present.

**Proposed change.**

> A new step in Half B, after the isolation check and before the hire: an **audit of the assembled
> setup against the scenario's own criteria**.
>
> `.claude/agents/leak-auditor.md`, a subagent restricted to `Read`, `Grep` and `Glob`. It receives
> the run folder path, the `<dist>` path and the scenario file, and reports each place where the
> setup pre-answers something the scenario intends to measure: `file:line`, the criterion it
> short-circuits, and the quote. It never speaks to a hire, so it may hold the criteria.
>
> In-process is correct here, unlike `#016`'s scorer: the auditor's whole job *is* to hold the
> criteria and look for them in the setup. There is no independence to protect.

**Where this stops and `#015` starts, because conflating them costs a deterministic check.**

`#015` owns the **mechanical** half — the case-insensitive `Monster-Dev` / `MonsterLib` scan in
`new-run.ps1`, and moving fixture notes out to `process/fixtures/<name>.md`. That must stay a script:
it is exact, it is cheap, and it can delete the run folder.

This item owns only the **judgement** half — what no string scan can reach. A fixture whose CSS
already contains a `@keyframes` plus `steps()` pattern hands over the animation primitive without
naming anything. A mirror in which §5's roster plus a single stack note makes the sheet choice
trivial. An answer script whose fallback happens to resolve a fork the criteria score. None of those
contains a product name.

**Proof design.** *`Gate: none`* by lane. Its kill condition, since the dev side has none:

> Point it today at all three fixtures and at a freshly built mirror. It passes only if **at least
> one finding is not already in `#015`**. If everything it reports is already on the board, it is a
> re-reader rather than a check, and the file is deleted.

That bar is deliberately awkward. The three README leaks are now written down, so finding them
proves nothing — the auditor has to earn its place on what has *not* been looked at, which is the
CSS, the answer script, the mirror's own composition, and the two fixtures that were only skimmed.

**Result, `2026-08-02` — passed, and not narrowly.**

First pass, against a freshly built mirror and a fresh `static-site` run folder, blind to
`process/backlog/`: **10 findings, of which 5 were nowhere on the board.** Two became items on their
own evidence after being verified by hand:

- **`#018`** — three files *in the mirror* describe the harness. `README.md:41` tells the reader that
  *"a test run hires a fresh agent against a sample project, scores it criterion by criterion"*, and
  **eight of ten transcripts contain that sentence**, including all four Sonnet runs. Worse than
  `#015`, which at least left the bar model's arm clean.
- **`#019`** — the run folder's parent lists every previous run and its mirror. One hire did list it.

Three more that stand and are not yet items: the fixture's `script.js:1` comment states the §2.4
answer independently of the README, so `#015`'s fix does not reach it; the answer script's fallback
selects exactly the sheet `index.html` is built on, so criteria `10` and `14b` cannot separate a
derivation from a copy; and `monsters/README.md` gives a hire a reason to pick the default that has
nothing to do with the client.

It also **independently re-derived `#001`** — that §8 regulates code comments, so section C's
premise *"unregulated in the playbook"* is false — without having read the item.

One qualification about how it was invoked: the agent registry loads at session start, so on the day
it was written the pass was run by having a general-purpose agent read
`.claude/agents/leak-auditor.md` and follow it. The prompt is what was under test and the prompt is
what passed. The registry picked the definition up later in the same session, so `leak-auditor` is
now a callable subagent type — but no finding above depended on that.

**Cost.**

- **A judgement step in a procedure that is otherwise mechanical.** Every other pre-hire check
  returns a deterministic pass or fail; this one returns an opinion, and an opinion that blocks a run
  is worse than none if it is noisy. Mitigation: it reports, it does not gate. A finding is read by
  the person who then decides.
- **It runs before the expensive part, on the cheap side of the run.** That is the one thing clearly
  in its favour and worth stating: a finding here saves a whole run, and a finding after the hire
  saves nothing.
- **It is another reader that must never be pointed at a hire.** Same class of hazard as everything
  under `process/`, and the same mitigation: it lives in `.claude/`, which the mirror excludes by
  folder name. That exclusion has to be *verified* after this lands, not assumed — it is the
  invariant `CLAUDE.md` says silently invalidates everything.
- **Overlap with `#015` is a live risk, not a theoretical one.** If the mechanical scan is ever
  dropped because "the auditor covers it", a deterministic check has been traded for a
  probabilistic one.

**Log.**

- `2026-08-02` `intake` — from the question whether to build a PM / developer / Monster-Dev team
  harness. The team was rejected; setting up a run is one of the two places a single unopposed reader
  has actually been wrong.
- `2026-08-02` `formulated` — motivated by `#015`, which was found by accident. The scope was cut to
  the judgement half so the string scan stays a script.
- `2026-08-02` — kill condition run the same day and passed: 10 findings, 5 not on the board, two of
  them (`#018`, `#019`) verified by hand and filed.
- `2026-08-02` `proven` — SKILL.md Half B step 4b is in place (`:278-291`), between the isolation
  check and the hire, as specified.
- `2026-08-02` — a defect found by the PM pass over the board, and it is this item's own stated
  hazard arriving from the other direction. `leak-auditor.md` shipped telling the auditor that
  `new-run.ps1` scans for `Monster-Dev` and `MonsterLib` and not to re-find what it finds. That scan
  does not exist — it is `#015`, still `formulated` — so for the interval between this item landing
  and `#015` landing, the deterministic check had been traded away before it was built. Fixed in
  `leak-auditor.md`: the paragraph now names the three refusals `new-run.ps1` actually has
  (`:83-87`, `:93-99`, `:104-110`), puts product names back in the auditor's scope, ranked last, and
  says to delete itself when the scan lands. The Cost bullet above predicted this trade in one
  direction only; it happens in both.
