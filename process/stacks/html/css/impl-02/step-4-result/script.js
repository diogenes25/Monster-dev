// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg — Monster-Dev. Alt+A walks it across the screen once.
// Size, speed and direction live in .monster-walk in style.css (--frame-w, --stride).
document.addEventListener('keydown', (e) => {
  if (!e.altKey || e.code !== 'KeyA') return;
  if (document.querySelector('.monster-walk')) return; // one monster at a time
  e.preventDefault();
  releaseMonster();
});

function releaseMonster() {
  const walker = document.createElement('div');
  walker.className = 'monster-walk';
  walker.innerHTML = '<div class="shadow"></div><div class="sprite"></div>';
  document.body.append(walker);

  // The distance to walk depends on the window width, the gait tempo does not. With a
  // fixed duration the monster would move faster on wide monitors and its feet would
  // slide, so the crossing time is derived from the stride instead: a whole number of
  // gait cycles, each one --cycle long and --stride wide.
  const px = (name) => parseFloat(getComputedStyle(walker).getPropertyValue(name));
  const distance = window.innerWidth + px('--frame-w');
  const cycles = Math.max(1, Math.round(distance / px('--stride')));
  walker.style.setProperty('--crossing', (cycles * px('--cycle')).toFixed(2) + 's');

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    // Nothing animates, so there is no animationend to wait for — it just stands
    // there for a moment and leaves again.
    setTimeout(() => walker.remove(), 3000);
    return;
  }

  walker.addEventListener('animationend', (event) => {
    if (event.animationName === 'monster-across') walker.remove();
  });
}
