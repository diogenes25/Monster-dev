# Fixture `static-site` — what it is for

A note *about* the fixture. It is a sibling of the folder, not a file inside it, for the same
reason `process/tools/setup/<fixture>.ps1` is: `new-run.ps1` copies the folder wholesale, so
anything inside it is read by the hire and shows up in the §9 diff surface.

**Represents.** Plain HTML/CSS/JS marketing page. No framework, no build step, no existing
animation of any kind. Published stack: `dom-css`.

**What it exercises.** The baseline. A DOM surface with no animation convention to conform to, so
the hire picks the injection point, the asset location and the animation primitive from scratch —
and every one of those is a §2 judgement rather than a lookup.

**What a correct run looks like.** The DOM as the runtime surface; §2.4 finds nothing to conform
to; `assets/` as the asset location, since it is the only assets folder and `logo.svg` is already
there; plain CSS as the idiom. Criteria `8`, `9`, `18a` and `18c` are the marks that turn on this.

**The reason this file exists.** Every word above was in `static-site/README.md` until
`2026-08-02`, addressed to the wrong reader. It was present in all ten rescued run folders and
the string reached six of the ten transcripts — five during analysis, two more surfaced by the
hire's own §9 cleanup grep. Criteria `8` and `9` were scored, in those runs, against a hire that
had been handed the answer.

**A boundary this fix does not reach.** `script.js:1-2` states the §2.4 answer in the project's
own code — *"That's the only JS this site has — no animation library, no framework."* There is
no product name in it and no playbook section, and a real project might well carry that comment,
so the rule *"a fixture contains only what the target project would contain"* does not exclude
it. Filed separately as `#025`.

## Pre-answered

**Every line of this fixture that settles a criterion before turn 1.** `#015` took out the lines
addressed to the wrong reader; these are addressed to the *right* reader and answer criteria anyway,
which is a different problem with a different fix. **Nothing here is removed** — a project whose
README does not say where static assets go is not a realistic project, and a fixture engineered to
withhold buys clean criteria by measuring a codebase nobody has.

What is required instead is that a run **cannot score these clean and silently**. Any report against
this fixture names them in one clause.

| Where | What it says | Pre-answers |
|---|---|---|
| `README.md:12` | ``assets/`` — `logo.svg` | `9` (sprite location), **`18c`** (where the sprite goes) |
| `README.md:3`, `:11` | *"One page, hand-written HTML and CSS, no build step and no framework"*; *"`script.js` — smooth-scroll for the nav links, and nothing else"* | **`18b`** (the animation-primitive survey) |
| `README.md:19-20` | *"Keep it that way if you can — the site has survived three redesigns by not depending on anything"* | `8` (no dependency, no new animation library) |
| `script.js:1-2` | *"That's the only JS this site has — no animation library, no framework."* | `8`, and §2.4 — the judgement itself (`#025`) |

**Two of these answer section-E marks, and that is what makes the list worth keeping.** Section E is
the mark set every `#002`-class A/B is required not to regress, and **a guard answered on paper before
turn 1 cannot regress.** So *"nothing regressed"* against this fixture is a weaker statement than it
reads: it holds cleanly for `18a` and `18d`, and weakly for `18b` and `18c`. Both `2026-08-03` arms
scored `18c` a clean pass off a sentence the client had written for them.

One line **was** changed, because it was the only one not in character: `:12` used to read
*"`logo.svg` lives here, and anything else static would too"*. That second clause is an instruction to
a future contributor about where to put new files — which is precisely `18c`'s question. The bare
`assets/ logo.svg` tells a reader who is looking the same thing and answers nothing.

**Comparability:** nothing is lost. All twelve runs on record read this README, so the contamination
is uniform across the series rather than a boundary — except `:12`, which is a boundary and is one
clause narrower from `2026-08-03` on. `#054`.
