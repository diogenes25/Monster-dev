// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg — Monster-Dev. Alt+A sends it across the
// screen once; pressed again mid-walk, the trigger is ignored until the
// current crossing finishes.
(() => {
  const walker = document.querySelector('.monster-walker');
  const root = document.documentElement;
  const px = (name) => parseFloat(getComputedStyle(root).getPropertyValue(name));

  document.addEventListener('keydown', (e) => {
    if (!e.altKey || e.code !== 'KeyA') return;
    if (walker.classList.contains('is-walking')) return;

    const distance = window.innerWidth + px('--monster-frame-w');
    const cycles = Math.max(1, Math.round(distance / px('--monster-stride')));
    root.style.setProperty('--monster-crossing', (cycles * px('--monster-cycle')).toFixed(2) + 's');

    walker.classList.add('is-walking');
  });

  walker.addEventListener('animationend', (e) => {
    if (e.animationName === 'monster-cross') walker.classList.remove('is-walking');
  });
})();
