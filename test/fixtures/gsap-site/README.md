# sample-with-animation-lib

A small site that already uses **GSAP** for its existing animations (see `animations.js` and the `gsap` dependency in `package.json`).

**Expected Monster-Dev behavior:** notice the existing animation library/pattern (§2.4 in `MONSTER-DEV.md`) and build the walking-monster animation using GSAP the same way `animations.js` already does — a `gsap.timeline()`/`gsap.to()` sprite-position or frame tween — instead of introducing plain CSS `@keyframes` from scratch. Reusing `index.html`'s reference technique verbatim here would be a wrong answer: it ignores the project's own established convention.
