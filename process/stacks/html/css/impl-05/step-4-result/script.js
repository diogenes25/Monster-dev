// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg: Alt+A walks a monster across the bottom of the window.
// Size, speed and gait tempo are the --monster-* custom properties in style.css.
const MONSTER_STANDING = 4000; // ms it stands around instead of walking, under reduced motion

const monsterProp = (name) =>
  parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

let monsterIsWalking = false; // Alt+A is ignored until the current crossing finishes

const sendMonsterWalking = () => {
  const walker = document.createElement('div');
  walker.className = 'monster';
  walker.setAttribute('aria-hidden', 'true'); // decorative — nothing for a screen reader here

  const sprite = document.createElement('div');
  sprite.className = 'monster-sprite';
  walker.append(sprite);

  // The gait tempo is fixed, the distance to cross is not, so the duration is derived
  // rather than picked: a whole number of gait cycles, each one --monster-cycle long and
  // --monster-stride wide. That keeps the ground speed locked to the walk and ends the
  // monster on the foot it started on — a fixed duration would make it skate on a wide window.
  const distance = window.innerWidth + monsterProp('--monster-frame-w');
  const cycles = Math.max(1, Math.round(distance / monsterProp('--monster-stride')));
  walker.style.setProperty('--monster-crossing', `${(cycles * monsterProp('--monster-cycle')).toFixed(2)}s`);

  const seeMonsterOut = () => {
    walker.remove();
    monsterIsWalking = false;
  };

  monsterIsWalking = true;
  document.body.append(walker);

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    window.setTimeout(seeMonsterOut, MONSTER_STANDING); // no animation to end, so time it out
  } else {
    walker.addEventListener('animationend', (e) => {
      if (e.target === walker) seeMonsterOut(); // the wrapper's crossing, not the sprite's gait
    });
  }
};

document.addEventListener('keydown', (e) => {
  // e.code rather than e.key: with Alt held down, some layouts report a different character.
  if (e.code !== 'KeyA' || !e.altKey || e.ctrlKey || e.metaKey || monsterIsWalking) return;
  e.preventDefault();
  sendMonsterWalking();
});
