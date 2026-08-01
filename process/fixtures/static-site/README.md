# sample-static-site

A minimal, plain HTML/CSS/JS marketing page. No framework, no build step, no existing animation of any kind.

**Expected Monster-Dev behavior:** find the DOM as the runtime surface, notice there's no existing animation library or pattern to conform to, pick `assets/` as the natural place for the sprite sheet (it's the only assets folder here), and decide for itself where the monster should live (there's only one page) and how to animate it (plain CSS is the obvious idiomatic choice here, mirroring `index.html`'s own reference technique closely).
