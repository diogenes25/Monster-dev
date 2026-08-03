// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg — Alt+A — Monster-Dev
// Speed/size knobs live in style.css (.monster-walker: --stride, --frame-w/--frame-h).
(() => {
  const walker = document.querySelector('.monster-walker');
  if (!walker) return;

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const px = (name) => parseFloat(getComputedStyle(walker).getPropertyValue(name));
  let isWalking = false;

  const endWalk = () => {
    walker.classList.remove('is-walking');
    isWalking = false;
  };

  const startWalk = () => {
    if (isWalking) return; // one walk at a time; Alt+A is ignored until it finishes
    isWalking = true;

    // Duration follows the stride, not the other way round — a fixed duration
    // would move the monster faster on wide screens and its feet would slide.
    const distance = window.innerWidth + px('--frame-w');
    const cycles = Math.max(1, Math.round(distance / px('--stride')));
    walker.style.setProperty('--crossing', (cycles * px('--cycle')).toFixed(2) + 's');

    walker.classList.add('is-walking');

    if (reducedMotion) {
      setTimeout(endWalk, 2000);
    } else {
      walker.addEventListener('animationend', endWalk, { once: true });
    }
  };

  document.addEventListener('keydown', (e) => {
    if (e.altKey && e.code === 'KeyA') {
      e.preventDefault();
      startWalk();
    }
  });
})();
