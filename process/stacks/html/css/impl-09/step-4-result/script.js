// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Easter egg: Alt+A walks a monster across the bottom of the window, once per
// press. Sprite geometry, size and stride live in style.css.
const monster = document.querySelector('.monster');
const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

// How far it has to walk depends on the window width, the gait tempo does not.
// A fixed duration would make the monster faster on a wide monitor and its feet
// would slide, so the duration follows from the stride instead: a whole number
// of gait cycles, each one --monster-cycle long and --monster-stride wide.
const crossingDuration = () => {
  const style = getComputedStyle(document.documentElement);
  const px = (name) => parseFloat(style.getPropertyValue(name));

  const distance = window.innerWidth + px('--monster-frame-w');
  const cycles = Math.max(1, Math.round(distance / px('--monster-stride')));
  return `${(cycles * px('--monster-cycle')).toFixed(2)}s`;
};

// Unhiding restarts both animations from the first frame.
const sendMonster = () => {
  monster.style.setProperty('--monster-crossing', crossingDuration());
  monster.hidden = false;

  // With reduced motion it just stands there, so nothing ends the walk for us.
  if (reducedMotion.matches) {
    setTimeout(() => { monster.hidden = true; }, 4000);
  }
};

document.addEventListener('keydown', (e) => {
  // e.code, so the shortcut survives a non-US layout. AltGr reports altKey too,
  // hence the ctrlKey guard. A second press while one is walking is ignored.
  if (e.altKey && !e.ctrlKey && !e.metaKey && e.code === 'KeyA' && monster.hidden) {
    e.preventDefault();
    sendMonster();
  }
});

monster.addEventListener('animationend', (e) => {
  if (e.animationName === 'monster-cross') {
    monster.hidden = true;
  }
});
