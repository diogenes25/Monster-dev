# Stack: `dom-css`

A web page whose animation is plain CSS — no tween library already in use.

**You are here if** the project renders to a DOM and its existing effects are CSS
transitions or `@keyframes`, or it has no animation at all yet. Typically plain
HTML/CSS/JS, a static site generator, or a framework project whose styling is hand-written
CSS. **You are not here if** the project already uses GSAP, Framer Motion, Motion One or a
similar tween system — matching what a project already does beats introducing a second way
of animating.

## Animation primitive

CSS `@keyframes`, with `steps(N)` stepping `background-position` across the sprite sheet for
the gait, and a separate transform animation carrying the travel across the screen. Keeping
those two on separate elements is what lets the walk cycle loop while the crossing runs once.

## Where the asset goes

Wherever the project already keeps static files and references them from CSS or markup —
next to whatever `logo.svg`-equivalent it has. Follow the existing reference style; a
project that resolves assets through a bundler needs the sprite registered the same way its
other assets are.

## Example implementation

`index.html` at the repository root is a working `dom-css` implementation: sprite geometry in
custom properties, a `steps(N)` walk cycle, and a small script deriving the crossing duration
from the real viewport width. Read it for the technique, not to copy — §6 applies here as
everywhere else.

It is built on one specific sheet (`green-fuzz-classic`, hence `steps(23)`), so its frame
count, cell size and cycle time are that sheet's and not the technique's. Substitute the
figures for whichever sheet the client picked in §5.

---

*No measured pitfalls recorded for this stack yet. Entries appear here only once a test run
has demonstrated one, each with the run it came from.*
