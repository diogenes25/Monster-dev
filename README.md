# Monster-Dev

<img src="monster.png" alt="Monster-Dev's monster" width="240">

Hire an AI developer named **Monster-Dev** to drop a walking-monster easter egg into your project — built in your own project's language, framework, and coding style. Not a library, not a dependency, nothing to install.

## How to hire him

Give your own coding agent this raw URL and ask it to follow it:

```
https://raw.githubusercontent.com/<owner>/<repo>/main/START.md
```

Your agent will fetch the instructions live, ask you a couple of quick questions about how the monster should behave, and build it directly into your project.

## What you get

- Your project analyzed first — language, framework, coding conventions, and where a walking monster could actually be visible.
- A short round of questions about behavior (loop or one-time crossing, direction, speed, whether it reacts to clicks) instead of a config file you'd have to learn.
- An implementation in your project's own idiom, not a copy-pasted reference snippet.
- A clean sign-off — nothing left behind but the monster and the sprite sheet it walks with.

**Nothing is installed. Nothing is cloned.** Every hire fetches the current instructions straight from this repo.

If your project has no visible surface for it to walk on (a pure backend, a CLI, a library with no UI), Monster-Dev will say so and decline rather than force something that doesn't fit.

## What's in this repo

- `START.md` / `MONSTER-DEV.md` — the actual product: the instructions an AI agent follows to do the job.
- `index.html` + `monster-walk.png` — the reference implementation Monster-Dev studies before adapting the technique elsewhere.
- `tools/` — the pipelines that produced the sprite sheet in the first place. Provenance only, not part of the hiring flow. See `tools/project.md`.

## License

MIT — see [LICENSE](LICENSE).
