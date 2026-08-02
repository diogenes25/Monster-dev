// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Easter egg: Alt+A walks a monster along the bottom of the page, left to right.
const monsterWalk = document.querySelector('.monster-walk');
const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

// How far it has to walk depends on the window width, the pace of its gait does not.
// So the duration follows from the stride — a whole number of gait cycles, each one
// --cycle long and --stride wide. A fixed duration would make the feet slide on a
// wide screen, and rounding to whole cycles ends the walk on the foot it started on.
function crossingDuration() {
  const style = getComputedStyle(monsterWalk);
  const px = (name) => parseFloat(style.getPropertyValue(name));
  const cycles = Math.max(1, Math.round((window.innerWidth + px('--frame-w')) / px('--stride')));
  return cycles * px('--cycle');
}

function releaseMonster() {
  monsterWalk.style.setProperty('--crossing', `${crossingDuration().toFixed(2)}s`);
  monsterWalk.hidden = false;

  if (reducedMotion.matches) {
    // Nothing animates, so there is no animationend to wait for — it just visits.
    setTimeout(() => { monsterWalk.hidden = true; }, 4000);
    return;
  }

  monsterWalk.addEventListener('animationend', (e) => {
    if (e.animationName === 'monster-cross') monsterWalk.hidden = true;
  }, { once: true });
}

document.addEventListener('keydown', (e) => {
  // Keyed off e.code, because Alt+A produces a different character on some layouts.
  // Ignored while a monster is already out, so Alt+A never interrupts a walk.
  if (e.altKey && e.code === 'KeyA' && monsterWalk.hidden) {
    e.preventDefault();
    releaseMonster();
  }
});
