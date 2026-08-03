// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Monster easter egg — Alt+A. One walk across the screen; ignored while one
// is already in progress. Crossing time is derived from the window width and
// the sprite's stride, not fixed, so the gait cadence stays correct at any
// screen size — walking monster easter egg, Monster-Dev.
const monsterWalker = document.querySelector('.monster-walker');
let monsterWalking = false;

const cssPx = (name) =>
  parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

document.addEventListener('keydown', (e) => {
  if (!e.altKey || e.code !== 'KeyA' || monsterWalking) return;
  monsterWalking = true;

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    monsterWalker.classList.add('is-walking');
    setTimeout(() => {
      monsterWalker.classList.remove('is-walking');
      monsterWalking = false;
    }, 2000);
    return;
  }

  const distance = window.innerWidth + cssPx('--monster-frame-w');
  const cycles = Math.max(1, Math.round(distance / cssPx('--monster-stride')));
  const crossing = (cycles * cssPx('--monster-cycle')).toFixed(2) + 's';
  monsterWalker.style.setProperty('--monster-crossing', crossing);
  monsterWalker.classList.add('is-walking');
});

monsterWalker.addEventListener('animationend', (e) => {
  if (e.animationName === 'monster-move-across') {
    monsterWalker.classList.remove('is-walking');
    monsterWalking = false;
  }
});
