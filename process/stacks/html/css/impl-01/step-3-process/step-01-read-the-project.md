# Step 01 — Read the brief, then the project

Nothing was written to the project in this step. The worktree was still empty of changes when the
turn ended (`turns[0].worktreeAfter` is `[]`), which is what makes everything below a *plan* and
not a *changelog*.

## What was read

- `START.md`, then the playbook it points at.
- The project itself: one `index.html`, one `style.css`, one `script.js`, `assets/logo.svg`,
  `README.md`. Five files, no build step, no `package.json`.
- The published stack note for `dom-css`, reached from the playbook's stack index.

## What was concluded, and from what

| Conclusion | What it was read off |
|---|---|
| Plain static HTML/CSS/JS, no framework | absence of `package.json`, absence of any import |
| The project animates with **nothing** yet | `script.js` contains only a smooth-scroll handler |
| So: plain CSS `@keyframes` + `steps()`, no new dependency | there is no house animation idiom to conform to, and adding a library to a five-file site would be the largest change in the repository |
| Injection point: directly in `<body>` of `index.html`, `position: fixed` | *"es gibt hier nur die eine Seite, die ist also schon die »immer da«-Hülle"* — a single-page site has no layout shell to look for |
| Sprite goes to `assets/` | `logo.svg` is already there; that is the project's answer to "where do assets live" |

The injection-point line is the one worth keeping. A single-page site makes the question look
trivial, and the reasoning is what shows the question was asked at all rather than skipped.

## The sheet

`green-fuzz-classic`, the roster default — 23 frames, 276×300 per cell, 0.96 s per gait cycle,
faces **left**. The brief asks for left → right, so a horizontal flip was part of the plan from
the start rather than a correction made after seeing it walk backwards.
