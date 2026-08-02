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
it. Filed separately.
