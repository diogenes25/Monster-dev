# Run report — `2026-08-01-live`

**The first run the way the README actually promises it.** No `<dist>` mirror, no `--add-dir`,
no path substitution — a customer sentence and a raw URL, and everything else fetched from the
public repo by the hire itself.

It closes the three criteria that had been deferred since the very first run.

Hire: Opus, 2 turns, 31 model turns, ~5.5 min, **$1.61**
Brief, in full:

> Auf meiner Seite soll ein Easter-Egg: wenn man Alt+A drückt, läuft ein Monster von links nach
> rechts durchs Bild. Deine Einweisung steht hier:
> `https://raw.githubusercontent.com/diogenes25/Monster-dev/main/START.md`

## §0 — base URL derivation: **proven**, and harder than intended

Neither `START.md` nor `MONSTER-DEV.md` names an owner or a repo anywhere. `START.md` says only
*"the same base URL you fetched this file from"*. The hire nevertheless reached
`MONSTER-DEV.md` and the monster roster — it listed both sheets with their frame counts (23 and
17), which appear nowhere else.

The test turned out stronger than designed. During this session the repository was called
`MonsterLib`, then `monster-dev` in the README, and finally `Monster-dev`. §0 exists for exactly
that sentence — *"this repo gets forked and renamed"* — and it was renamed twice for real before
anything fetched it.

## §5 — WebFetch for text, shell for the binary: **proven by hash**

| | |
|---|---|
| In the target project | `assets/monster-walk.png`, 1897 KB |
| SHA-256 | `789F5149A5369FD0FBDCB32BF2EDC2C12A8955C47C908E6E3705C03C7F3B82A3` |
| Published sheet, fetched independently | identical |

This is the one criterion that cannot be faked by self-report. WebFetch renders content as text;
a byte-identical 1.9 MB PNG cannot come out of it. The sheet was downloaded with a shell tool
straight to its destination, exactly as §5 requires.

The verifier also identified it from pixel size against `monsters/catalog.json`:
`green-fuzz-classic — 23 frames of 276×300, cycle 0.958s`. The implementation's `steps(23)`
matches the sheet it actually downloaded.

## §2 — stack resolution: **not evidenced, and that is a testability gap**

The hire named the `dom-css` technique and put the asset beside `logo.svg` — but both are
derivable from the project itself, and `stacks/dom-css/README.md` is currently a signpost with no
measured pitfalls in it. **A stack file with no distinctive content leaves no fingerprint**, so
this run cannot show whether it was read.

Recorded as unproven rather than passed. It becomes testable the moment the file carries one line
that a hire could not have derived on its own — which is another argument for eventually filling
it, independent of the deferred F3/F4 question.

## Criterion results

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 1 | Trigger starts it, load does not | **PASS** | 0 visible on load and after idle, 1 after real Alt+A |
| 2 | Travels left → right | **PASS** | x = −78 → 183 → 459 → 720 → 979 |
| 3 | Faces direction of travel | **PASS** | mirrored at every sample |
| 4a | Asked about repeat behaviour | **PASS** | question 5 — F2 holds live |
| 4b | Second trigger works | **PASS** | 0 after crossing, 1 on second press |
| 5 | No other trigger; page JS intact | **PASS** | bare `a` → 0; 3 nav links, scroll 0 → 199 |
| 6 | Introduced itself once | **PASS** | |
| 7a | Asked before building | **PASS** | working tree empty after turn 1 |
| 8 | Idiomatic, no dependency | **PASS** | plain CSS/JS, no build step |
| 9 | Sprite in `assets/` | **PASS** | beside `logo.svg` |
| 10 | Technique carried over | **PASS** | 10.56 s @ 1280 px, 4.80 s @ 420 px; discrete 184 px steps |
| 11 | `prefers-reduced-motion` | **PASS** | stands at 35 %, leaves after 4 s |
| 12 | No commit, no trailer | **PASS** | exactly `20c79b9 Initial site` |
| 13 | Only implementation + sprite | **PASS** | three files touched plus the sheet |
| 14a/b | Monster offered; default used with its numbers | **PASS** | both sheets offered; `green-fuzz-classic` confirmed from the catalog |
| 15 | Language fidelity | **PASS** | German throughout |
| 16 | No console errors; sprite loads | **PASS** | 200; pre-existing favicon 404 only |
| 17 | Frames advance | **PASS** | `background-position` stepped |

## A new implementation shape — and the harness bug it exposed

Every previous hire created the monster element in JavaScript on the trigger. This one put the
markup in `index.html` and toggled the `hidden` attribute.

The verifier scored that as **monster visible on page load**, because it located the element by
"paints the sprite sheet" and a hidden element still reports a background image in computed
style. It was counting *presence*, not *visibility*. Criteria 1, 5 and 4b all read as failures
for a page that behaves correctly.

Fixed: an element now only counts if `checkVisibility()` says it would really be seen. Re-run,
and every reading flipped to the truth.

**Third harness bug this session, same root cause every time.** The class-name coupling, the
mirror-on-one-element assumption, and now presence-versus-visibility all came from writing the
verifier against the implementation that happened to exist when it was written. Each new hire
invents a different shape, and each time the verifier mistook "different from what I saw before"
for "wrong". Worth stating as a standing rule: **assert on what the user would observe, never on
how the code achieves it.**

## Two judgements by the hire worth recording

- It matched on `e.code === 'KeyA'` rather than `e.key`, because Alt+A produces `å` on some
  macOS layouts and `e.key` would miss it. Nobody asked.
- It left out the shadow, with the reason: on a page with no ground strip it would float over
  changing content instead of lying on a surface — and noted that if one is added it has to flip
  with the mirroring, or it sticks to the tail instead of the leading foot. That is F4's content,
  arrived at independently for the fifth time.

## Cost

| Run | Model | Turns | Cost |
|---|---|---|---|
| `alt-a` | Opus | 33 | $1.88 |
| `phase1` | Opus | 33 | $2.56 |
| `sonnet-base` | Sonnet | 48 | $1.57 |
| `phase2` | Opus | 52 | $4.04 |
| `phase2b` | Opus | 32 | $1.84 |
| **`live`** | Opus | 31 | **$1.61** |

Cheapest Opus run so far, against the largest playbook so far — and fetching everything over the
network rather than from a local mirror. The saving is the same one `phase2b` measured: it asked
first, so it built once.

## What remains open

- **§2 stack resolution** — untestable while the stack file is content-free.
- **`test/`, `.claude/` and `CLAUDE.md` are now publicly fetchable.** That was the accepted trade
  for reproducibility, and the fetch path still protects it: nothing points a hire at them. But
  the local `<dist>` filter has no equivalent over real URLs, so **live runs can never be as
  cleanly isolated as local ones**. Keep behavioural measurement on mirrors; keep live runs
  scoped to fetch mechanics, as here.
