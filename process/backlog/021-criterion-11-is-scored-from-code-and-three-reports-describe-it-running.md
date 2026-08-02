# `#021` — the verifier cannot emulate reduced motion, criterion `11` is scored by reading CSS, and three reports describe watching it behave

| | |
|---|---|
| Status | `formulated` |
| Gate | `none` |
| Attribution | harness artefact |
| Criterion | `11` |
| Target file | `process/tools/verify-run.mjs`, `process/scenarios/alt-a-left-to-right.md` |
| Evidence | seven reports on record; `verify-run.mjs` scanned `2026-08-02`; raised by the blind second scoring of `2026-08-01-plan-opus` |
| Proof design | — |

**What happened.** Criterion `11` is *"`prefers-reduced-motion` handled (§5, §9)"*. It has passed in
every run on record. `verify-run.mjs` contains no `prefers-reduced-motion`, no `reduce`, and no CDP
emulation call of any kind — grepped `2026-08-02`, zero matches. Nothing in the harness has ever put
a browser into reduced-motion mode.

So `11` is scored by reading the stylesheet. Four reports say so plainly:

| Run | Evidence recorded for `11` |
|---|---|
| `sonnet-base` | `style.css:123` |
| `plan-sonnet` | reduce-branch in all three stylesheets |
| `alt-a` | CSS media query kills both animations, **plus** a JS branch that removes the element via `setTimeout` |
| `phase1` | media query plus a JS branch, since no `animationend` fires |

Three others do not:

| Run | Evidence recorded for `11` |
|---|---|
| `live` | stands at 35 %, leaves after 4 s |
| `phase2` | stands visible, then leaves |
| `phase2b` | stands at ~40 vw, leaves after 2.5 s |

Those three are written as observations — a position, a duration, a sequence. There is no
reduced-motion measurement in any `measurements.json`, and no code in the harness that could produce
one. Either somebody opened a browser by hand and did not record it, or the sentence describes what
the CSS says it would do, written in the past tense of something watched. Both are a problem, and
the second is the one this project has a name for.

**Why the current wording allows it.** `11` says *handled*, and does not say what settles it. Every
other criterion in section D names its instrument — `getBoundingClientRect().x` at two moments,
`spriteHttpStatus`, `bg` values across samples, and the scenario is explicit that positions come
from measurement *"not eyeballed screenshots"*. `11` sits in section B, among criteria that genuinely
are read off the code, so nothing marked it as the one behavioural claim in that group.

**This is `#009`'s shape in a third disguise.** `#009` is titled *"The verifier keeps measuring a
proxy for visibility, and the proxy keeps being wrong"* and closed after two. It is filed separately
rather than as a third evidence line on it, because `#009` is `proven` and its two disguises were
both about criteria `1`, `4b` and `5`. Same failure mode, different criterion, different fix.

**Proposed change.**

> **The verifier emulates it, and `11` is scored on what comes back.** CDP has
> `Emulation.setEmulatedMedia({features:[{name:'prefers-reduced-motion',value:'reduce'}]})`.
> `verify-run.mjs` takes a second pass with it on and records: whether the element appears at all,
> its `x` at two moments (it must not travel), and whether it is gone by the time the normal-motion
> crossing would have ended.
>
> **`11` names its instrument, like everything else in section D:**
>
> > **11** With `prefers-reduced-motion: reduce` emulated: the monster does not travel — `x` at two
> > moments is unchanged — and it does not stay on screen indefinitely. Code that contains a
> > `@media (prefers-reduced-motion: reduce)` block is **not** a pass on its own; that is the
> > proxy `#009` was about.

**Proof design.** *`Gate: none`.* Harness artefact — fix the harness, rerun, record nothing against
the product.

It repairs nothing retroactively. `11`'s seven passes were scored on code presence, and the three
that read as observations cannot be re-sourced. The honest handling is the one used for `15c` and
section E: a boundary line in the scenario saying `11` changed meaning here, and a note in the three
reports that their evidence line is not reproducible.

**Cost.**

- **A second verifier pass per run**, which is cheap in wall-clock and free in the numbers the gates
  are stated in — the verifier runs after the hire, outside `num_turns` and `total_cost_usd`.
- **`11` may start failing**, and that would be the point. Nobody knows today whether any of the
  seven implementations actually behaves under reduced motion, only that all seven contain a media
  query. A criterion that has never failed and cannot fail is not measuring.
- **Three reports gain a caveat.** Same cost as `#015` and `#018`, and the same reason for paying it.
- **It touches the file `#007` also touches.** Both edit `verify-run.mjs`'s measurement set; doing
  them in one pass is cheaper and makes one boundary in the scenario instead of two.

**Log.**

- `2026-08-02` `intake` — raised by the blind second scoring of `2026-08-01-plan-opus` under `#016`,
  which passed `11` and then put it in `UNCERTAIN`: *"scored PASS on code presence alone;
  `measurements.json` never exercises `prefers-reduced-motion`, so 'handled' is unverified at
  runtime."*
- `2026-08-02` `formulated` — verified beyond what the scorer could see: it had one bundle, so it
  could only say its own run was unmeasured. Grepping `verify-run.mjs` shows the capability has never
  existed, and reading all seven reports shows three of them describing behaviour anyway.
