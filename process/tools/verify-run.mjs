// Independent acceptance test for a Monster-Dev run.
// Drives headless Chrome over CDP with no dependencies (Node 22 has global WebSocket + fetch).
// The trigger is sent as a real browser-level key event, not a synthetic DOM event.
//
// The monster is found by its sprite, never by a class name: every hire names things
// differently — `.monster-walk` in one run, `.monster-walker` in the next — and a verifier
// that keys on a name ends up measuring the naming instead of the behaviour.
//
//   node process/tools/verify-run.mjs <out.json> [--url ...] [--key KeyA] [--modifier alt]
//                                     [--fixture static-site] [--baseline-port 8099]

import { spawn } from 'node:child_process';
import { createServer } from 'node:http';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';

// The roster, so the verifier knows every sheet a hire could have been given and what each
// one's pixel dimensions are. Read from the catalog rather than restated here: a second copy
// of these numbers is a second thing to forget when a sheet is regenerated.
const CATALOG = JSON.parse(readFileSync(new URL('../../monsters/catalog.json', import.meta.url), 'utf8'));

const args = process.argv.slice(2);
const OUT = args[0];
// A fixed name beside OUT, not a stem derived from it. `OUT.replace(/\.json$/, '-midwalk.png')`
// wrote `measurements-midwalk.png` for the documented invocation, while `score-bundle.ps1` copies
// `midwalk.png` — the two never agreed, and a copy that finds nothing produced a bundle without
// the screenshot and without a line saying so. All ten runs on record hold `midwalk.png` because
// the #012 backfill normalised them by hand, so this is the name that already exists on disk and
// the mismatch was latent rather than fired (#035). Two names for one file is what caused it;
// this is the one place either is written.
const SHOT = join(dirname(OUT), 'midwalk.png');
const opt = (name, fallback) => {
  const i = args.indexOf(`--${name}`);
  return i === -1 ? fallback : args[i + 1];
};
// Not named PAGE_URL: that would shadow the global one this file already used to read the catalog
// above, and the shadow wins from the top of the module — so `new URL(...)` on line 17 would
// throw before this line ever runs.
const PAGE_URL = opt('url', 'http://127.0.0.1:8080/index.html');
const KEY_CODE = opt('key', 'KeyA');
const MODIFIER = opt('modifier', 'alt');
const CHROME = opt('chrome', 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe');
const PORT = Number(opt('port', '9333'));
// The untouched fixture, served by this script rather than by whoever runs it. A second server to
// start by hand is a second server to leave stale, which is exactly how `2026-08-01-*` measured the
// wrong arm and reported it confidently.
const FIXTURE = fileURLToPath(new URL(`../fixtures/${opt('fixture', 'static-site')}/`, import.meta.url));
const BASELINE_PORT = Number(opt('baseline-port', '8099'));
// The narrow viewport of the second travel measurement. 1200 is the window Chrome is started with.
const NARROW_WIDTH = Number(opt('narrow-width', '760'));

const MODIFIER_BIT = { alt: 1, ctrl: 2, meta: 4, shift: 8, none: 0 }[MODIFIER] ?? 1;
const KEY_CHAR = KEY_CODE.replace(/^Key/, '').toLowerCase();
const VK = KEY_CHAR.toUpperCase().charCodeAt(0);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const results = { url: PAGE_URL, trigger: `${MODIFIER}+${KEY_CODE}` };
const consoleErrors = [];

// Origin-blind, because the fixture and the run are served from two different ports and the same
// error therefore reads as two different strings. Everything else in the message is kept: a
// comparison that normalised more than the origin would start matching errors that differ.
const fingerprint = (m) => m.replace(/https?:\/\/[^/\s)]+/g, '<origin>').trim();

const TYPES = {
  '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript', '.json': 'application/json',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.svg': 'image/svg+xml', '.ico': 'image/x-icon',
};
// Enough of a static server to load one fixture once. Deliberately not reused for the run itself:
// the run is served by whatever the procedure already serves it with, and this one exists only so
// the baseline cannot be forgotten.
const serve = (dir, port) => new Promise((resolve, reject) => {
  const srv = createServer((req, res) => {
    const rel = normalize(decodeURIComponent(req.url.split('?')[0])).replace(/^(\.\.[/\\])+/, '');
    const file = /[/\\]$/.test(rel) || rel === '' ? join(dir, 'index.html') : join(dir, rel);
    if (!existsSync(file) || !file.startsWith(dir)) { res.writeHead(404); res.end('not found'); return; }
    res.writeHead(200, { 'content-type': TYPES[extname(file).toLowerCase()] ?? 'application/octet-stream' });
    res.end(readFileSync(file));
  });
  srv.on('error', reject);
  srv.listen(port, '127.0.0.1', () => resolve(srv));
});

// Locates the monster by the fact that it paints a sprite sheet, never by a class name.
// Returns the outermost element under <body>, since that is what carries the travel.
//
// The filename is a weaker signal than it used to be, deliberately: §5 tells a hire to name the
// asset the way the target project names assets, so it may be a catalog slug, `monster-walk.png`
// as older runs produced, or something of the project's own. Hence a substring list rather than
// one literal name — and the natural-size check further down, not this, is what confirms which
// sheet was actually used. A locator miss surfaces as zero monsters found, which fails the run
// loudly instead of mis-scoring it quietly.
const SPRITE_HINTS = [...CATALOG.monsters.map((m) => m.slug), 'monster', 'walk'];
const FIND_MONSTER = `(() => {
  const hints = ${JSON.stringify(SPRITE_HINTS)};
  const urlOf = (el) => el.tagName === 'IMG'
    ? (el.currentSrc || el.src || '')
    : getComputedStyle(el).backgroundImage;
  // Visible, not merely present. Hires differ on where the element comes from: most create it
  // on the trigger, but one placed the markup in index.html and toggled the hidden attribute.
  // Counting
  // presence scores that second shape as "monster on page load" — a failure the page does not
  // actually have. So the element only counts if it would really be seen.
  const shown = (el) => typeof el.checkVisibility === 'function'
    ? el.checkVisibility({ checkOpacity: true, checkVisibilityCSS: true })
    : !!(el.offsetParent || el.getClientRects().length);
  const painted = [...document.querySelectorAll('body *')].find((el) => {
    const u = urlOf(el);
    return u && u !== 'none' && hints.some((h) => u.toLowerCase().includes(h)) && shown(el);
  });
  if (!painted) return null;
  let node = painted;
  while (node.parentElement && node.parentElement !== document.body) node = node.parentElement;
  const m = urlOf(painted).match(/url\\(['"]?(.*?)['"]?\\)/);
  return { node, painted, spriteUrl: m ? m[1] : urlOf(painted) };
})()`;

const chrome = spawn(CHROME, [
  '--headless=new', `--remote-debugging-port=${PORT}`, '--window-size=1200,800',
  '--no-first-run', '--no-default-browser-check',
  `--user-data-dir=${process.env.TEMP}\\monster-verify-profile`,
  'about:blank',
], { stdio: 'ignore' });

let ws, msgId = 0, baseline;
const pending = new Map();
const send = (method, params = {}) => new Promise((resolve, reject) => {
  const id = ++msgId;
  pending.set(id, { resolve, reject });
  ws.send(JSON.stringify({ id, method, params }));
});

const evaluate = async (expression) => {
  const r = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
  if (r.exceptionDetails) throw new Error(`${expression} -> ${r.exceptionDetails.exception?.description}`);
  return r.result.value;
};

// "Is a monster on screen right now?" — CSS-visible is not enough, and this is the second time
// that has bitten. `live` caught the first level: counting mere presence scored a hire that kept
// the markup in `index.html` as "monster on page load". The fix was `checkVisibility()`, which
// has no idea where the element is. `plan-sonnet` parks the walker one frame-width off the left
// edge at rest and slides it in on the trigger — CSS-visible the whole time, seen by nobody. That
// read as failures on criteria 1, 5 and 4b for a page that behaves exactly as asked.
//
// Geometry sampling deliberately keeps using the CSS-visible element: a crossing has to stay
// trackable while it is still off-screen, which is where every crossing begins.
const count = () => evaluate(`(() => {
  const found = ${FIND_MONSTER};
  if (!found) return 0;
  const r = found.node.getBoundingClientRect();
  const onScreen = r.width > 0 && r.height > 0
    && r.right > 0 && r.left < innerWidth && r.bottom > 0 && r.top < innerHeight;
  return onScreen ? 1 : 0;
})()`);

// Mirroring can sit on the sprite itself or on any wrapper above it — one hire put it on the
// sprite, the next on a wrapper so the shadow would flip with it. Reading only the painted
// element therefore reports "not mirrored" for a perfectly mirrored monster, so walk the chain.
const geometry = () => evaluate(`(() => {
  const found = ${FIND_MONSTER};
  if (!found) return null;
  const r = found.node.getBoundingClientRect();
  const s = getComputedStyle(found.painted);
  let mirrored = false;
  for (let el = found.painted; el && el !== document.body; el = el.parentElement) {
    const m = new DOMMatrixReadOnly(getComputedStyle(el).transform);
    if (m.a < 0) mirrored = !mirrored;   // negative horizontal scale flips it
  }
  return { x: Math.round(r.x), y: Math.round(r.y), mirrored, bg: s.backgroundPosition };
})()`);

// Polls the travel window instead of sampling a point in it, and the difference is a defect this
// verifier actually had. Reduced motion was read as `x` at 0.8 s and `x` at 3.8 s, so an
// implementation that showed the monster and removed it after 2 s produced `null` for the second
// reading and `null` for `travelledPx` — and **a full crossing that cleaned up after itself
// produces exactly the same `null`.** One reading, two opposite outcomes: the same defect class as
// `#009`, where CSS-visible stood in for visible. `#052`.
//
// The loop runs *in the page* rather than as 40 CDP round-trips: the interval then means what it
// says, and one `Runtime.evaluate` costs what one costs. It resolves when the element is gone —
// which, since `FIND_MONSTER` requires visibility, is the same event as "removed or hidden" — or
// when `maxMs` is up, and it reports how many samples it actually got. `samplesTaken: 0` is the
// only reading that may become `null`: the element was never there at all.
const pollTravel = (maxMs) => evaluate(`(() => new Promise((resolve) => {
  const samples = [];
  const t0 = performance.now();
  let disappearedAfterMs = null;
  const done = () => resolve({
    samples, disappearedAfterMs, elapsedMs: Math.round(performance.now() - t0),
  });
  const tick = () => {
    const found = ${FIND_MONSTER};
    const t = Math.round(performance.now() - t0);
    if (found) {
      const r = found.node.getBoundingClientRect();
      // Same on-screen test count() applies, per sample, so "did anything appear" and "did it
      // move" come out of one measurement rather than out of two probes at different moments.
      const onScreen = r.width > 0 && r.height > 0
        && r.right > 0 && r.left < innerWidth && r.bottom > 0 && r.top < innerHeight;
      samples.push({ t, x: Math.round(r.x), onScreen: onScreen ? 1 : 0 });
    } else if (samples.length) {
      disappearedAfterMs = t;
      return done();
    }
    if (performance.now() - t0 >= ${maxMs}) return done();
    setTimeout(tick, 100);
  };
  tick();
}))()`);

// What the *implementation* uses, which is not what the sheet is. Criterion 14b asks for the
// frame count, cell size and cycle "in the implementation", and until 2026-08-02 it was answered
// with `spriteNaturalSize` — the sheet's pixels, which prove nothing about what was built. A hire
// that wrote a squashed 184x210 cell passed on the same evidence as one that scaled correctly.
//
// Read off computed style rather than by custom-property name: §5 names no variables, so every
// hire invents its own. The custom properties are collected as well, because criterion 10 asks for
// frame geometry to live in them and a stylesheet full of literals has none to collect.
const implementation = () => evaluate(`(() => {
  const found = ${FIND_MONSTER};
  if (!found) return null;
  const r = found.painted.getBoundingClientRect();
  const anims = [], props = {};
  for (let el = found.painted; el; el = el.parentElement) {
    const s = getComputedStyle(el);
    const names = s.animationName.split(',').map((v) => v.trim());
    // Split on commas that are not inside a function, so \`steps(23, end), linear\` stays two entries.
    const durs = s.animationDuration.split(',').map((v) => v.trim());
    const fns  = s.animationTimingFunction.split(/,(?![^(]*\\))/).map((v) => v.trim());
    names.forEach((n, i) => {
      if (n === 'none') return;
      anims.push({
        on: el.tagName.toLowerCase() + (el.id ? '#' + el.id : '') +
            (typeof el.className === 'string' && el.className.trim()
              ? '.' + el.className.trim().split(/\\s+/).join('.') : ''),
        name: n,
        durationS: parseFloat(durs[i % durs.length]) || 0,
        timing: fns[i % fns.length],
      });
    });
    for (const k of s) if (k.startsWith('--')) props[k] = s.getPropertyValue(k).trim();
    if (el === document.documentElement) break;
  }
  const stepped = anims.filter((a) => /steps\\(/.test(a.timing));
  const cycle = stepped.length ? stepped.reduce((a, b) => (a.durationS <= b.durationS ? a : b)) : null;
  const rest = anims.filter((a) => a !== cycle);
  const travel = rest.length ? rest.reduce((a, b) => (a.durationS >= b.durationS ? a : b)) : null;
  const w = Math.round(r.width), h = Math.round(r.height);
  return {
    viewportWidth: innerWidth,
    viewportHeight: innerHeight,
    cell: { width: w, height: h, aspect: h ? Number((w / h).toFixed(4)) : null },
    backgroundSize: getComputedStyle(found.painted).backgroundSize,
    animations: anims,
    steps: cycle ? Number((cycle.timing.match(/steps\\((\\d+)/) || [])[1]) || null : null,
    cycleSeconds: cycle ? cycle.durationS : null,
    travelSeconds: travel ? travel.durationS : null,
    travelAnimation: travel ? travel.name : null,
    customProperties: props,
  };
})()`);

const key = (type, withModifier) => send('Input.dispatchKeyEvent', {
  type, modifiers: withModifier ? MODIFIER_BIT : 0,
  windowsVirtualKeyCode: VK, nativeVirtualKeyCode: VK,
  code: KEY_CODE, key: KEY_CHAR, text: withModifier ? '' : KEY_CHAR,
});
const press = async (withModifier = true) => { await key('keyDown', withModifier); await key('keyUp', withModifier); };

try {
  let targets;
  for (let i = 0; i < 40 && !targets; i++) {
    try { targets = await (await fetch(`http://127.0.0.1:${PORT}/json`)).json(); } catch { await sleep(250); }
  }
  ws = new WebSocket(targets.find((t) => t.type === 'page').webSocketDebuggerUrl);
  await new Promise((r) => { ws.onopen = r; });
  ws.onmessage = (ev) => {
    const m = JSON.parse(ev.data);
    if (m.id && pending.has(m.id)) {
      const { resolve, reject } = pending.get(m.id);
      pending.delete(m.id);
      m.error ? reject(new Error(JSON.stringify(m.error))) : resolve(m.result);
    } else if (m.method === 'Runtime.exceptionThrown') {
      consoleErrors.push(`exception: ${m.params.exceptionDetails.exception?.description}`);
    } else if (m.method === 'Log.entryAdded' && ['error', 'warning'].includes(m.params.entry.level)) {
      consoleErrors.push(`${m.params.entry.level}: ${m.params.entry.text}`);
    }
  };

  await send('Runtime.enable'); await send('Log.enable'); await send('Page.enable');

  // --- what the fixture already logs, before any hire touched it ------------------------------
  // Chrome asks for /favicon.ico on every page and the fixture has none, so every run on record
  // reported exactly one console error that no hire caused and no hire could remove. The failure
  // mode is the quiet one: a real error introduced by a hire lands at 2, and a reader comparing
  // "1 (favicon)" against "1 (favicon)" across two arms sees no change.
  //
  // Measured against the untouched fixture on every run rather than kept as a hand-written
  // allowlist. An allowlist is how a check quietly stops checking — the same trap check-index.ps1
  // avoided by testing sprite-sheet geometry instead of exempting one filename.
  if (existsSync(FIXTURE)) {
    baseline = await serve(FIXTURE, BASELINE_PORT);
    await send('Page.navigate', { url: `http://127.0.0.1:${BASELINE_PORT}/index.html` });
    await sleep(2000);
    results.fixtureConsoleErrors = [...consoleErrors];
    consoleErrors.length = 0;
  } else {
    // Not fatal, and not silent: without a baseline the count is raw, and saying so beats a number
    // that looks like it was measured against something.
    results.fixtureConsoleErrors = null;
    results.fixtureBaseline = `NOT MEASURED — no fixture at ${FIXTURE}; consoleErrors is the raw count`;
  }

  await send('Page.navigate', { url: PAGE_URL });
  await sleep(2500);

  // Loading the page must not summon it.
  results.onLoad = await count();
  await sleep(1500);
  results.afterIdle = await count();

  // The bare key without the modifier must not summon it either.
  await press(false);
  await sleep(500);
  results.afterBareKey = await count();

  // Real browser-level key event — ladder step 1.
  await press();
  await sleep(800);
  results.afterTrigger = await count();
  results.keyPath = results.afterTrigger ? 'real browser key event (ladder step 1)' : 'FAILED';

  if (results.afterTrigger) {
    // Whatever the hire named it and wherever it put it, check the sheet the page is really
    // painting — then identify which roster entry it is by its pixel size. An unrecognised
    // size means a resized, re-encoded or hand-assembled sheet, which is a finding in itself.
    results.spriteUrl = await evaluate(`${FIND_MONSTER}.spriteUrl`);
    results.spriteHttpStatus = await evaluate(
      `fetch(${FIND_MONSTER}.spriteUrl).then((r) => r.status).catch(() => 'ERR')`);
    results.spriteNaturalSize = await evaluate(
      `new Promise((res) => { const i = new Image(); i.onload = () => res(i.naturalWidth + 'x' + i.naturalHeight); i.onerror = () => res('LOAD ERROR'); i.src = ${FIND_MONSTER}.spriteUrl; })`);
    const match = CATALOG.monsters.find((m) => `${m.sheet.width}x${m.sheet.height}` === results.spriteNaturalSize);
    results.spriteSlug = match
      ? `${match.slug} (${match.frames} frames of ${match.cell.width}x${match.cell.height}, cycle ${match.cycleSeconds}s)`
      : `UNRECOGNISED — matches no sheet in monsters/catalog.json`;

    // The implementation's own numbers, and what they say against the sheet it actually
    // downloaded — never against green-fuzz-classic by name. The answer script routes an
    // indifferent client to that sheet, so comparing against it by name would pass a hire that
    // copied index.html and a hire that derived from §5 identically.
    results.implementation = await implementation();
    const impl = results.implementation;
    if (impl && match) {
      const sheetAspect = Number((match.cell.width / match.cell.height).toFixed(4));
      const pct = (a, b) => (b ? Number((((a - b) / b) * 100).toFixed(2)) : null);
      results.sheetMatch = {
        slug: match.slug,
        frames: { sheet: match.frames, implementation: impl.steps, agree: impl.steps === match.frames },
        cycleSeconds: {
          sheet: match.cycleSeconds, implementation: impl.cycleSeconds,
          deltaPct: pct(impl.cycleSeconds, match.cycleSeconds),
        },
        // Aspect ratio, not literal size: scaling a 300px monster down for a page is ordinary and
        // correct, and a changed aspect ratio is the squashed monster 14b exists to catch.
        cellAspect: {
          sheet: sheetAspect, implementation: impl.cell.aspect,
          deltaPct: pct(impl.cell.aspect, sheetAspect),
        },
        cellPx: {
          sheet: `${match.cell.width}x${match.cell.height}`,
          implementation: `${impl.cell.width}x${impl.cell.height}`,
          scale: Number((impl.cell.width / match.cell.width).toFixed(4)),
        },
      };
    } else if (impl) {
      results.sheetMatch = 'UNRECOGNISED SHEET — nothing in the catalog to compare the implementation against';
    }

    // Criterion 10: the crossing duration is *derived* from stride and viewport, never picked.
    // §5's arithmetic is `cycles = round((distance) / stride)` and `duration = cycles × cycle`,
    // so a derived duration is a whole number of gait cycles and a chosen one is whatever it is.
    // That is the tell a single measurement can give; `durationVsViewport` below gives the other.
    if (impl && impl.cycleSeconds && impl.travelSeconds) {
      const cycles = impl.travelSeconds / impl.cycleSeconds;
      const whole = Math.round(cycles);
      results.derivation = {
        viewportWidth: impl.viewportWidth,
        frameWidth: impl.cell.width,
        distancePx: impl.viewportWidth + impl.cell.width,
        travelSeconds: impl.travelSeconds,
        cycleSeconds: impl.cycleSeconds,
        cycles: Number(cycles.toFixed(3)),
        // 2 % of one cycle, so a rounded-in-CSS `0.96s × 9 = 8.64s` written as `8.6s` still counts.
        cyclesIsWhole: Math.abs(cycles - whole) < 0.02,
        // A reconstruction, not the hire's own figure: the rounding to whole cycles throws the
        // stride away, so index.html's declared 130px comes back as 124. Read it as an order of
        // magnitude — the hire's actual number, if it named one, is in `customProperties`.
        impliedStridePx: whole ? Math.round((impl.viewportWidth + impl.cell.width) / whole) : null,
      };
    }

    results.samples = [];
    for (let i = 0; i < 5; i++) {
      results.samples.push({ t: i * 2, ...(await geometry()) });
      if (i === 1) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        writeFileSync(SHOT, Buffer.from(shot.data, 'base64'));
      }
      await sleep(2000);
    }

    // After the crossing it must be gone, and triggering again must work.
    await sleep(4000);
    results.afterCrossing = await count();
    await press();
    await sleep(800);
    results.afterSecondTrigger = await count();
    results.secondTriggerGeometry = await geometry();
  }

  // The page's own behaviour must survive.
  results.navLinks = await evaluate(`document.querySelectorAll('nav a[href^="#"]').length`);
  results.scroll = await evaluate(`(() => {
    const before = window.scrollY;
    document.querySelector('nav a[href="#contact"]')?.click();
    return new Promise((r) => setTimeout(() => r({ before, after: Math.round(window.scrollY) }), 1200));
  })()`);

  // --- does the duration move with the viewport, or is it a number somebody typed? -------------
  // A derived 8s and a chosen 8s are the same 8s at one window width. Measuring at a second width
  // is what separates them.
  //
  // It does **not** separate a hire that derived the geometry from §5 from one that copied
  // index.html, which is what this comment used to claim: the reference derives its duration in a
  // script too, so a faithful copy also lands `changesWithViewport: true`. `#053`. That question is
  // answered by the scenario instead — a run scored on a sheet the reference does not use makes a
  // copy fail `sheetMatch.frames.agree` on its own, with no new instrument here.
  if (results.afterTrigger && results.implementation) {
    await send('Emulation.setDeviceMetricsOverride',
      { width: NARROW_WIDTH, height: 800, deviceScaleFactor: 1, mobile: false });
    await send('Page.navigate', { url: PAGE_URL });
    await sleep(2000);
    await press();
    await sleep(800);
    const narrow = await implementation();
    const wide = results.implementation;
    results.durationVsViewport = {
      wide: { viewportWidth: wide.viewportWidth, travelSeconds: wide.travelSeconds },
      narrow: { viewportWidth: narrow?.viewportWidth ?? null, travelSeconds: narrow?.travelSeconds ?? null },
      changesWithViewport: narrow?.travelSeconds != null && wide.travelSeconds != null
        ? Math.abs(narrow.travelSeconds - wide.travelSeconds) > 0.05
        : null,
    };
    await send('Emulation.clearDeviceMetricsOverride');
  }

  // --- reduced motion, emulated rather than read off the stylesheet ----------------------------
  // Criterion 11 passed in every run on record and the harness has never put a browser into this
  // mode, so it was scored by finding a @media block — the proxy-for-behaviour mistake, in its
  // third disguise. Code presence is now not the evidence; this is.
  await send('Emulation.setEmulatedMedia',
    { features: [{ name: 'prefers-reduced-motion', value: 'reduce' }] });
  await send('Page.navigate', { url: PAGE_URL });
  await sleep(2000);
  results.reducedMotion = { onLoad: await count() };
  await press();
  // Polled from the trigger, not probed at two moments — see `pollTravel` and `#052`. Four seconds,
  // which is long enough to cover the 2 s window both hires on record gave this path and to let a
  // normal crossing get well under way if one starts.
  const rm = await pollTravel(4000);
  const xs = rm.samples.map((s) => s.x);
  results.reducedMotion.x = {
    first: xs.length ? xs[0] : null,
    last: xs.length ? xs[xs.length - 1] : null,
    min: xs.length ? Math.min(...xs) : null,
    max: xs.length ? Math.max(...xs) : null,
  };
  // `0` and `null` now mean different things, which is the whole point of the change: `0` is an
  // element that appeared and did not move, `null` is an element that was never there. A crossing
  // that finished and tidied up reads as a large number plus a `disappearedAfterMs`, and no longer
  // as the same `null` a correct static appearance produces.
  results.reducedMotion.travelledPx = xs.length ? Math.max(...xs) - Math.min(...xs) : null;
  results.reducedMotion.samplesTaken = xs.length;
  results.reducedMotion.disappearedAfterMs = rm.disappearedAfterMs;
  // Derived from the poll rather than from a single probe at 0.8 s, so it cannot miss an appearance
  // that is shorter than the probe delay. One sample is enough to answer *did it appear*; read it
  // beside `samplesTaken` before reading anything into `travelledPx`, because a single sample makes
  // `0` arithmetically true and evidentially thin.
  results.reducedMotion.afterTrigger = rm.samples.some((s) => s.onScreen) ? 1 : 0;
  // Long enough that a normal crossing would be over: the travel duration the implementation
  // itself declares, plus a margin, capped so a hire with a silly number cannot stall the run.
  const crossing = Math.min(20, (results.implementation?.travelSeconds ?? 12) + 3);
  await sleep(Math.max(0, crossing * 1000 - rm.elapsedMs));
  results.reducedMotion.stillOnScreenAfterCrossing = await count();
  results.reducedMotion.waitedSeconds = Math.round(crossing);
  await send('Emulation.setEmulatedMedia', { features: [] });

  // What the hire added, not what the fixture already logged. `consoleErrorsAll` is kept beside it
  // so the subtraction can be checked rather than trusted.
  const known = new Set((results.fixtureConsoleErrors ?? []).map(fingerprint));
  results.consoleErrorsAll = consoleErrors;
  results.consoleErrors = consoleErrors.filter((m) => !known.has(fingerprint(m)));
} catch (e) {
  results.harnessError = String(e);
} finally {
  writeFileSync(OUT, JSON.stringify(results, null, 2));
  try { ws?.close(); } catch {}
  try { baseline?.close(); } catch {}
  chrome.kill();
  console.log(JSON.stringify(results, null, 2));
  // Non-zero when the verifier itself broke — wrong Chrome path, CDP never up, a throw anywhere
  // above. Exiting 0 unconditionally made a crashed measurement indistinguishable from a clean
  // one to anything reading the exit code, which is the worst failure this project can have:
  // the instrument reporting success while broken. `measurements.json` is still written either
  // way, so the diagnosis survives; only the verdict changes.
  process.exit(results.harnessError ? 1 : 0);
}
