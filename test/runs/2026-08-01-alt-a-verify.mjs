// Independent acceptance test for the Monster-Dev run.
// Drives headless Chrome over CDP with no dependencies (Node 22 has global WebSocket + fetch).
// Alt+A is sent as a real browser-level key event, not a synthetic DOM event.

import { spawn } from 'node:child_process';
import { writeFileSync } from 'node:fs';

const CHROME = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const URL = 'http://127.0.0.1:8080/index.html';
const PORT = 9333;
const OUT = process.argv[2];

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const results = {};
const consoleErrors = [];

const chrome = spawn(CHROME, [
  '--headless=new', `--remote-debugging-port=${PORT}`, '--window-size=1200,800',
  '--no-first-run', '--no-default-browser-check', '--user-data-dir=' + process.env.TEMP + '\\md-verify-profile',
  'about:blank',
], { stdio: 'ignore' });

let ws, msgId = 0;
const pending = new Map();

const send = (method, params = {}) => new Promise((resolve, reject) => {
  const id = ++msgId;
  pending.set(id, { resolve, reject });
  ws.send(JSON.stringify({ id, method, params }));
});

const evaluate = async (expr) => {
  const r = await send('Runtime.evaluate', { expression: expr, returnByValue: true, awaitPromise: true });
  if (r.exceptionDetails) throw new Error(expr + ' -> ' + JSON.stringify(r.exceptionDetails.exception?.description));
  return r.result.value;
};

const key = async (type, altKey) => send('Input.dispatchKeyEvent', {
  type, modifiers: altKey ? 1 : 0,
  windowsVirtualKeyCode: 65, nativeVirtualKeyCode: 65,
  code: 'KeyA', key: 'a', text: altKey ? '' : 'a',
});
const pressAltA = async () => { await key('keyDown', true); await key('keyUp', true); };
const pressPlainA = async () => { await key('keyDown', false); await key('keyUp', false); };

try {
  // --- attach ---
  let targets;
  for (let i = 0; i < 40; i++) {
    try { targets = await (await fetch(`http://127.0.0.1:${PORT}/json`)).json(); break; }
    catch { await sleep(250); }
  }
  const page = targets.find((t) => t.type === 'page');
  ws = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise((r) => { ws.onopen = r; });
  ws.onmessage = (ev) => {
    const m = JSON.parse(ev.data);
    if (m.id && pending.has(m.id)) {
      const { resolve, reject } = pending.get(m.id);
      pending.delete(m.id);
      m.error ? reject(new Error(JSON.stringify(m.error))) : resolve(m.result);
    } else if (m.method === 'Runtime.exceptionThrown') {
      consoleErrors.push('exception: ' + m.params.exceptionDetails.exception?.description);
    } else if (m.method === 'Log.entryAdded' && ['error', 'warning'].includes(m.params.entry.level)) {
      consoleErrors.push(m.params.entry.level + ': ' + m.params.entry.text);
    }
  };

  await send('Runtime.enable'); await send('Log.enable'); await send('Page.enable');
  await send('Page.navigate', { url: URL });
  await sleep(2500);

  // --- K1a: nothing on load ---
  results.onLoad_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);
  await sleep(1500);
  results.afterWait_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);

  // --- K5a: a plain 'a' must not trigger it ---
  await pressPlainA();
  await sleep(400);
  results.plainA_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);

  // --- K1b: real Alt+A ---
  await pressAltA();
  await sleep(300);
  results.afterAltA_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);
  results.keyPath = results.afterAltA_monsterCount > 0 ? 'real browser key event (ladder step 1)' : 'FAILED';

  if (results.afterAltA_monsterCount > 0) {
    // --- K3: facing direction + K10: derived crossing duration ---
    results.spriteTransform = await evaluate(
      `getComputedStyle(document.querySelector('.monster-walk .sprite')).transform`);
    results.crossingVar = await evaluate(
      `document.querySelector('.monster-walk').style.getPropertyValue('--crossing')`);

    // --- K15: does the sprite actually load? ---
    results.spriteHttpStatus = await evaluate(
      `fetch('assets/monster-walk.png').then(r => r.status)`);
    results.spriteNaturalSize = await evaluate(
      `new Promise(res => { const i = new Image(); i.onload = () => res(i.naturalWidth + 'x' + i.naturalHeight); i.onerror = () => res('LOAD ERROR'); i.src = 'assets/monster-walk.png'; })`);

    // --- K2: travel direction, sampled ---
    const sample = () => evaluate(
      `(() => { const e = document.querySelector('.monster-walk');
         if (!e) return null;
         const r = e.getBoundingClientRect();
         return { x: Math.round(r.x), bp: getComputedStyle(e.querySelector('.sprite')).backgroundPosition };
       })()`);
    results.samples = [];
    for (let i = 0; i < 5; i++) {
      results.samples.push({ t: i * 2, ...(await sample()) });
      if (i === 1) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        writeFileSync(OUT.replace(/\.json$/, '-midwalk.png'), Buffer.from(shot.data, 'base64'));
      }
      await sleep(2000);
    }

    // --- K4b: does a second press work after the first crossing finished? ---
    await sleep(3000);
    results.afterCrossing_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);
    await pressAltA();
    await sleep(400);
    results.secondPress_monsterCount = await evaluate(`document.querySelectorAll('.monster-walk').length`);
    results.secondPress_x = await evaluate(
      `(() => { const e = document.querySelector('.monster-walk'); return e ? Math.round(e.getBoundingClientRect().x) : null; })()`);
  }

  // --- K5b: existing smooth-scroll still wired up ---
  results.navLinks = await evaluate(`document.querySelectorAll('nav a[href^="#"]').length`);
  results.scrollWorks = await evaluate(
    `(() => { const before = window.scrollY;
       document.querySelector('nav a[href="#contact"]').click();
       return new Promise(r => setTimeout(() => r({ before, after: Math.round(window.scrollY) }), 1200));
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
