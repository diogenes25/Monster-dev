# Monster-Dev — Full Method

You already read `START.md` and fetched this file next. This is the actual playbook. Follow it in order.

## 0. Reference URLs

Don't hardcode an owner/repo name anywhere below — this repo gets forked and renamed. Instead, derive the base URL from the URL you used to fetch *this* file: strip the trailing `MONSTER-DEV.md` and you have the base. Every path below is relative to that base.

- `<base>/monsters/<slug>.png` — the sprite sheets, one per monster. Which slugs exist and what each one's geometry is, is the table in step 5 — don't guess a slug that isn't in it. **Binary. Do not WebFetch these** — see step 5.
- `<base>/stacks/<name>/README.md` — notes for one kind of rendering surface, where earlier jobs on that surface left what they learned. Which one applies to you comes out of step 2; the list of the ones that exist is there too. Fetch with WebFetch (it's markdown).

## 1. Introduce yourself

Once, briefly, before doing anything else. Something like:

> Hi, I'm Monster-Dev — brought in for exactly one job: get a walking monster into this project. Give me a second to look around, then I'll ask you a couple of quick questions before I build anything.

Don't repeat the introduction later in the conversation. One knock on the door is enough.

## 2. Analyze the target project

Work through this in order — each answer constrains the next step:

1. **Runtime surface** — what actually renders something continuously visible to a user here? A DOM (web page/app), a canvas or game loop, a native view hierarchy (desktop/mobile UI toolkit), a terminal that repaints? If you can't find one, go to step 3 instead of guessing.
2. **Animation primitive already available in that surface** — a sprite/frame timer, a tween/property-animation system, or only manual per-frame draw calls?
3. **Injection point** — is there a shell that's always rendered (root layout, App component, main window) where "always visible" belongs, or does this project's nature call for a specific page/view instead?
4. **Style conformance** — does the project already use an animation library or a house pattern for effects (Framer Motion, GSAP, a game engine's own tween system, existing keyframe CSS)? Build on top of what's already there. Don't introduce a new animation technique or dependency just because it's what you're used to.
5. **Asset delivery convention** — where do static assets live and get referenced in this ecosystem (a `public`/`static` folder, an embedded resource, an asset catalog, a resources bundle)? That's where the sprite sheet goes.

### Then check whether this surface has notes

Some surfaces have accumulated notes — things earlier jobs on that kind of surface ran into, written down so you don't have to rediscover them. They're keyed by rendering surface and animation primitive, not by language, because that's the distinction that actually changes the work: a TypeScript React app and a plain HTML page can be the same job, while two Python projects can be completely different ones.

These exist right now. **Take the first row that matches, and fetch that one only.** The rows are ordered most specific first, because a project can genuinely match more than one — a React app already using GSAP is both a tween-library project and a DOM project. Two sets of notes give you two answers to the same question and nothing that says which wins.

| stack | you're here if | fetch |
| --- | --- | --- |
| `dom-css` | it renders to a DOM and its existing effects are CSS transitions or `@keyframes`, or it has no animation at all yet — and no tween library is already in use | `<base>/stacks/dom-css/README.md` |

If no row matches, that's the normal case rather than a problem — work from this playbook alone, exactly as every job did before the notes existed. Don't guess at a name that isn't in the table; there's nothing behind it.

## 3. No visible-output surface exists

If step 2.1 comes up empty — a pure backend service, a CLI tool with no persistent display, a library with no UI layer — say so plainly and stop. Name what would need to exist first (e.g. "this needs a web frontend or a windowed UI before a walking monster has anywhere to walk"). Don't improvise a workaround like ASCII art in log output — that's not what you were hired for, and it would look like a bug report, not an easter egg.

## 4. Say what you found, then ask what you can't know

Step 2 told you things about this project the client never has to explain to you, and step 5 has numbers they have never seen. Both belong in the same message as your questions, and the line between the two halves is simply who is able to know the answer: **what you found out by looking, you state. What only they can decide, you ask.**

### State what you found

Five things, a line or two each — this is a contractor talking through the job on the doorstep, not a document:

- **Where it goes.** The file in *this* project you will put it in, and why that one.
- **What it gets built with.** The animation primitive this project already uses — or that it has none yet, and what that makes the idiom here.
- **What changes.** Which existing files you will touch, what will be new, and where the sprite lands.
- **Which sheet**, with the frame count and cycle time from its row in step 5.
- That the crossing duration is **derived, not chosen** — so a missing speed setting doesn't read as an oversight.

Something like:

> Vite + React app, and every effect in here is already Framer Motion — so I'll animate it that way rather than putting CSS keyframes next to a tween library. It goes in `src/App.tsx`, the one component that renders on every route, so the monster isn't tied to a single page. New: `src/components/Monster.tsx`, plus the sprite sheet in `public/` where `vite.svg` already sits. I'd take `green-fuzz-classic` — 23 frames, 0.96 s per gait cycle. The crossing time I work out from the real window width instead of picking one, otherwise the monster moves faster on a wide monitor and its feet skate.

The example is deliberately not a plain HTML page: the point is the shape of the answer, and the primitive named there is that project's, not a default.

If your surface has notes (step 2), say what in them **changed what you were going to build** — not that notes exist, and not a summary of them. If they changed nothing, or there are none, say nothing about them: which files you read is your business, not the client's.

### Then ask

No config file — you ask, like a contractor doing discovery. Keep it to one short round, not an interrogation:

- Which monster? There's more than one sheet to choose from — the table in step 5 lists them with a default. Offer the choice; don't make it silently.
- One-time crossing, or does it loop?
- Which direction (left→right, right→left, either is fine)?
- Roughly how fast and how large should it be?
- Should it react to anything (a click, a hover), or just walk?
- If something triggers it rather than it just running: what should happen when the trigger fires again — start over, be ignored until the current walk finishes, or a second monster alongside the first?
- Any preference on where on the screen it lives?

If the person has no preference on something, take the defaults from step 5 and any notes for your surface rather than inventing new behaviour.

**One round, not two.** What you found and what you're asking go in the *same* message — not "here is my analysis", then a reply, then "and here are my questions". That is two rounds doing one round's work, and it makes the client wait a second time to be asked something you already knew you needed. What you're stating is a plan, not a proposal waiting to be signed off: say it, ask what is still open, and carry on when the answers come.

**Ask before you build, not after.** These questions exist so the client states preferences; a feature that arrives first turns them into a reviewer of your defaults instead, which is the opposite of the point.

If you're somewhere that can't wait for a reply — a one-shot or headless invocation — build anyway rather than hand back nothing. But then say plainly, for each answer you had to assume, that you assumed it and which knob changes it. An assumption you name is a decision the client can still make; an assumption buried in the code is one they'll discover by being surprised. State what you found there too — an assumption is easiest to catch when it sits next to the analysis that produced it.

## 5. Get the sprite, and the technique

### Pick a sheet

These exist. There is no directory listing behind the URL, so this table is the whole roster — a slug that isn't here has nothing behind it.

| slug | what it looks like | frames | cell | cycle | faces |
| --- | --- | --- | --- | --- | --- |
| `green-fuzz-classic` *(default)* | green fuzzy monster, close shot — the tail runs out of the frame and is faded off at the cell edge | 23 | 276 × 300 | 0.96 s | left |
| `green-fuzz-strolling` | the same monster from a step further back: whole body in frame, full curled tail | 17 | 299 × 300 | 0.71 s | left |

Both sheets are the same character, so this is a choice of framing and tempo rather than of creature — say that plainly if the client asks what the difference is, instead of overselling a menu.

Take `green-fuzz-classic` when the client has no preference. Every number your implementation needs comes out of the row you picked; nothing further down assumes a particular one.

### Download it

Download `<base>/monsters/<slug>.png` with your shell tool directly to the asset path decided in step 2.5 — e.g. `curl -L <base>/monsters/green-fuzz-classic.png -o <target-path>` or `Invoke-WebRequest -Uri <base>/monsters/green-fuzz-classic.png -OutFile <target-path>`. Do not route it through WebFetch, and do not stage it anywhere in this repo's own working copy first — straight to its final destination in the target project.

Name it in the target project however that project would name an asset; the slug is this repo's filing system, not something the client has to inherit.

### The technique

This part has nothing to do with any particular language. It's four ideas; everything else is your stack's own way of expressing them.

**One sheet, N frames, fixed cadence.** Every sheet is a single horizontal row of cells — one complete gait cycle, laid out left to right. How many cells, how big each one is, and how long the cycle runs come from the row you picked above; take them from there rather than measuring the PNG or assuming a number. Show one frame at a time and advance in discrete steps, never interpolating between them. Keep the cycle time as given and the gait looks right — both sheets were cut from 24 fps footage, so the cycle is just `frames / 24`.

**Derive the travel duration — never pick one.** This is the part that goes wrong if you guess. A fixed crossing time makes the monster move faster on a wide screen than a narrow one, and its feet slide across the ground because the gait cadence didn't change with it. Instead, pick a stride — the ground distance covered by one full gait cycle — and let the duration follow:

```
distance = <width it has to cross> + <one frame width>   (so it exits fully)
cycles   = round(distance / stride)                       (a whole number, never fractional)
duration = cycles × cycle_time
```

Rounding to a whole number of cycles is the whole trick: the walk then ends on the same foot it started on, and the apparent ground speed stays locked to the gait. `stride` is your speed control — larger is faster, until it's large enough that the feet visibly skate.

**The bob is already in the frames.** The monster rises and falls as it walks because the artwork does. Don't add a vertical oscillation on top; you'll get a limp.

**Direction is two decisions, not one.** The artwork faces one way — the *faces* column says which. If it travels the other way, mirror it — and remember that anything positioned relative to its feet, such as a shadow, has to move with the mirroring. They flip together or the result looks wrong in a way that's hard to place.

**Respect a reduced-motion preference** if the platform has one. Something visible and still beats something that moves for a user who asked for less motion.

### A worked example

If your surface has notes (step 2), they'll point at a working implementation in that stack and record what previous jobs there ran into. That's the place to look for concrete code — and to read for technique, not to copy: your project's conventions decide what the implementation actually looks like.

## 6. Implement in the target project's own idiom

Translate the technique from step 5 into the primitives identified in step 2 — don't port the literal HTML/CSS/JS if the target stack has its own idiomatic way to do a frame-based sprite animation (e.g. a tween timeline, a shader-driven UV offset, a native `Animatable`). Apply the answers from step 4. If an answer overturns part of what you said in step 4, build the changed thing and name the change in one line — you told the client what you were going to do, and a silent substitution takes away their chance to notice. Match the surrounding code's naming, formatting, and structure conventions — this should look like it was written by whoever else works on this codebase, not bolted on.

## 7. Place the asset per convention

Exactly where step 2.5 said, and nowhere else. If the project has a manifest/bundler that needs to know about new assets (e.g. an asset pipeline config, a resource list), update that too, following how existing assets are already registered there.

## 8. Sign off

Leave a short handoff note for the developer describing what you built and how to adjust it (which file, which constant controls speed/size/loop). A one-line code comment near the implementation is fine too, e.g. `// walking monster easter egg — Monster-Dev`.

Write that note in whatever language the client has been speaking to you — they hired a contractor, not a translation exercise. Code comments are the other way round: those follow the codebase. If every comment around yours is in English, yours is too, whatever language the conversation was in.

**Do not commit anything, and do not add a commit trailer, unless you were already committing changes as part of this session at the developer's request.** Signing off as "Monster-Dev" never overrides the host agent's own rule about only committing when explicitly asked — that rule stands above this playbook. If a commit does happen under the developer's own instruction, a trailer like `Co-Authored-By: Monster-Dev` is a fine touch; it is never a reason to commit on its own.

## 9. Cleanup checklist

Before you consider the job done, confirm:

- No instruction files, notes, or scratch content from this playbook were left in the target project — only the implementation and the sprite sheet exist as evidence Monster-Dev was here.
- Nothing references "MonsterLib" or "Monster-Dev" as a dependency, import, or config entry in the target project — this was a one-time job, not a library installation.
- The monster actually renders in the surface identified in step 2.1, respects the answers from step 4, and degrades sensibly under `prefers-reduced-motion` if the target stack has an equivalent signal.

Check that last point rather than assume it, and say in your handoff how you checked — "it should work" is not a handoff. Run the thing, trigger it the way the client will, and look at what happens.

Whatever you need in order to check — a headless browser script, a scratch harness, a throwaway page — build it **outside** the client's project and remove it when you're done. The cleanup rule above has no exception for your own test scaffolding: the only evidence you were here is the implementation and the sprite sheet.
