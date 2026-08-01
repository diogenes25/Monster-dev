# Monster-Dev

<img src="monster.png" alt="Monster-Dev's monster" width="240">

Hire an AI developer named **Monster-Dev** to drop a walking-monster easter egg into your project — built in your own project's language, framework, and coding style. Not a library, not a dependency, nothing to install.

## How to hire Monster-Dev

Give your own coding agent this raw URL and ask it to follow it:

```
https://raw.githubusercontent.com/diogenes25/monster-dev/main/START.md
```

Your agent will fetch the instructions live, ask you a couple of quick questions about how the monster should behave, and build it directly into your project.

*Forked this repo?* Put your own owner and repo name in that URL. Everything after that point is derived from it, so this line is the only place a fork needs changing — and a fork that leaves it alone quietly hires the original instead of itself.

## What you get

- Your project analyzed first — language, framework, coding conventions, and where a walking monster could actually be visible.
- A short round of questions about which monster you want and how it should behave (loop or one-time crossing, direction, speed, whether it reacts to clicks) instead of a config file you'd have to learn.
- An implementation in your project's own idiom, not a copy-pasted reference snippet.
- A clean sign-off — nothing left behind but the monster and the sprite sheet it walks with.

**Nothing is installed. Nothing is cloned.** Every hire fetches the current instructions straight from this repo.

If your project has no visible surface for it to walk on (a pure backend, a CLI, a library with no UI), Monster-Dev will say so and decline rather than force something that doesn't fit.

## What's in this repo

- `START.md` / `MONSTER-DEV.md` — the actual product: the instructions an AI agent follows to do the job.
- `stacks/` — notes and tooling for a particular kind of rendering surface, written down by earlier jobs so the next one doesn't rediscover them. A hire fetches only the one that matches your project.
- `monsters/` — the sprite sheets a client can choose from, plus `catalog.json` recording each one's frame count, cell size, cycle length and where it came from. `index.html` is a working implementation of one of them for the plain-CSS case.
- `sources/` — the footage the sprite sheets were cut from, kept so they stay regenerable.
- `tools/` — sorted by who runs it: `provenance/` produced the sprite sheets offline, `hire/` is fetched by a hire. See `tools/project.md`.
- `test/` — how Monster-Dev is tested against sample projects, and what those runs found. Nothing here is ever fetched by a hire.

## Monster-Dev gets better by being tested

Every improvement here has to earn its place. A test run hires a fresh agent against a sample project, scores it criterion by criterion, and the gaps it finds become proposed wording changes — which are then only kept if a rerun shows a hire actually behaving differently. Notes and tooling face the same bar: if an A/B can't tell the difference, they come back out.

`test/runs/` holds the reports and the evidence behind them. The procedure is in `.claude/skills/monster-dev-workshop/`.

## License

MIT — see [LICENSE](LICENSE).
