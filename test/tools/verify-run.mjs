// Independent acceptance test for a Monster-Dev run.
// Drives headless Chrome over CDP with no dependencies (Node 22 has global WebSocket + fetch).
// The trigger is sent as a real browser-level key event, not a synthetic DOM event.
//
// The monster is found by its sprite, never by a class name: every hire names things
// differently — `.monster-walk` in one run, `.monster-walker` in the next — and a verifier
// that keys on a name ends up measuring the naming instead of the behaviour.
//
//   node test/tools/verify-run.mjs <out.json> [--url ...] [--key KeyA] [--modifier alt]

import { spawn } from 'node:child_process';
import { readFileSync, writeFileSync } from 'node:fs';

// The roster, so the verifier knows every sheet a hire could have been given and what each
// one's pixel dimensions are. Read from the catalog rather than restated here: a second copy
// of these numbers is a second thing to forget when a sheet is regenerated.
const CATALOG = JSON.parse(readFileSync(new URL('../../monsters/catalog.json', import.meta.url), 'utf8'));

const args = process.argv.slice(2);
const OUT = args[0];
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

const MODIFIER_BIT = { alt: 1, ctrl: 2, meta: 4, shift: 8, none: 0 }[MODIFIER] ?? 1;
const KEY_CHAR = KEY_CODE.replace(/^Key/, '').toLowerCase();
const VK = KEY_CHAR.toUpperCase().charCodeAt(0);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const results = { url: PAGE_URL, trigger: `${MODIFIER}+${KEY_CODE}` };
const consoleErrors = [];

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

let ws, msgId = 0;
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

    results.samples = [];
    for (let i = 0; i < 5; i++) {
      results.samples.push({ t: i * 2, ...(await geometry()) });
      if (i === 1) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        writeFileSync(OUT.replace(/\.json$/, '-midwalk.png'), Buffer.from(shot.data, 'base64'));
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

  results.consoleErrors = consoleErrors;
} catch (e) {
  results.harnessError = String(e);
} finally {
  writeFileSync(OUT, JSON.stringify(results, null, 2));
  try { ws?.close(); } catch {}
  chrome.kill();
  console.log(JSON.stringify(results, null, 2));
  process.exit(0);
}
