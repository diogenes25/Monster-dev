# Fixture `gsap-site` — what it is for

A note *about* the fixture, kept outside the folder so `new-run.ps1` cannot copy it into the
target. See `static-site.md` for why that rule exists.

**Represents.** A small site that already animates with GSAP — `animations.js` and a pinned
`gsap` dependency. Published stack: none yet; this fixture is what would produce one.

**What it exercises.** §2.4, style conformance. The project has an established animation
primitive, and the question is whether the hire notices and builds the walk cycle with it — a
`gsap.timeline()` / `gsap.to()` tween over the sprite position — instead of introducing plain CSS
`@keyframes` from scratch. Reusing `index.html`'s reference technique verbatim is the wrong
answer here, and it is the *attractive* wrong answer, which is the whole point of the fixture.

**Where the convention is visible, and how loudly.** Three places, deliberately graded: the
`gsap` dependency in `package.json`, `animations.js` itself, and the README's house rule. The
README states that motion goes through `animations.js` and that two animation systems once
fought each other — it does **not** say "no CSS keyframes", because a fixture that spells out the
prohibition measures instruction-following instead of §2.4.

**Not a fixture about a build.** GSAP loads from `cdn.jsdelivr.net` in `index.html`, and nothing
installs the declared dependency. A hire never registers an asset through a bundler here, so this
fixture does not close the asset-registration gap — that needs a fixture with a real build, which
does not exist.

**The reason this file exists.** `gsap-site/README.md` used to name §2.4 by section number, state
the expected implementation, and mark the wrong answer as wrong. It has never been hired against,
so nothing on record is damaged by it — it would have damaged the first run instead.
