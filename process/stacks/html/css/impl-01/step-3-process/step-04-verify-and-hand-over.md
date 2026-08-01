# Step 04 — Verify, then hand over

## Checked, not asserted

Monster-Dev drove the page in headless Chrome before reporting, installing the driver into its
own scratchpad and leaving nothing behind in the project. What it confirmed:

- the legs actually step, rather than the whole sprite gliding as one image
- the flip is right — sheet faces left, rendered facing right
- a second Alt+A during a crossing is ignored, verified from a monotonically advancing position
  rather than from the code
- after the crossing ends, Alt+A arms again
- no console errors

## Handover

Written in German, matching the conversation. Code comments were written in **English**, matching
the codebase — the fixture's own `script.js` opens `// Smooth-scroll to in-page sections`. Those
two go opposite ways on purpose: prose follows the customer, comments follow the code.

Sign-off marker in both edited files: `// walking monster easter egg — Monster-Dev`.

## What was *not* done

**No commit.** The customer never asked for one, so the work was left in the worktree:

```
 M index.html
 M script.js
 M style.css
?? assets/monster-sprite.png
```

Four entries, nothing else. No playbook copy, no notes file, no leftover scratch directory in the
project — the only two things that crossed over are the implementation and the sprite.

## Cost of the whole job

| | |
|---|---|
| Rounds with the customer | 2 |
| Model turns | 41 (11 planning, 30 building) |
| Cost | $1.84 |
| Wall clock | 7.5 min |
| First turn that touched a file | 2 |
