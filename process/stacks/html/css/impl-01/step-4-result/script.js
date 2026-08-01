// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// walking monster easter egg — Monster-Dev (press Alt+A)
// Crossing duration is derived from the real viewport width so the monster
// covers a whole number of gait cycles — otherwise it moves faster on wide
// screens and its feet slide. Re-pressing Alt+A while it's already walking
// is ignored until the current crossing finishes.
const monsterWalker = document.querySelector('.monster-walker');

if (monsterWalker) {
  const monsterVar = (name) => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

  document.addEventListener('keydown', (e) => {
    if (!e.altKey || e.code !== 'KeyA') return;
    if (monsterWalker.classList.contains('is-walking')) return;
    e.preventDefault();

    const frameWidth = monsterVar('--monster-frame-w');
    const stride = monsterVar('--monster-stride');
    const cycleSeconds = monsterVar('--monster-cycle');

    const distance = window.innerWidth + frameWidth;
    const cycles = Math.max(1, Math.round(distance / stride));

    monsterWalker.style.setProperty('--monster-cycles', cycles);
    monsterWalker.style.setProperty('--monster-crossing', `${(cycles * cycleSeconds).toFixed(2)}s`);
    monsterWalker.classList.add('is-walking');
  });

  monsterWalker.addEventListener('animationend', (e) => {
    if (e.animationName === 'monster-cross') monsterWalker.classList.remove('is-walking');
  });
}
