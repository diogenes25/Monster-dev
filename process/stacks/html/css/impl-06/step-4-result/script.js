// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Easter egg: Alt+A walks a monster across the bottom of the page, once per
// keypress. Size and speed are the --monster-* custom properties in style.css.
(() => {
  const STILL_MS = 2500; // how long the reduced-motion monster stays on screen
  const root = document.documentElement;
  const px = (name) => parseFloat(getComputedStyle(root).getPropertyValue(name));
  let walking = false;

  // The distance to cross depends on the window width, the gait tempo does not.
  // With a fixed duration the monster would move faster on wide monitors and its
  // feet would slide, so the duration is derived from the stride instead: a whole
  // number of gait cycles, each one --monster-cycle long and --monster-stride wide.
  const crossingSeconds = () => {
    const distance = window.innerWidth + px('--monster-frame-w');
    const cycles = Math.max(1, Math.round(distance / px('--monster-stride')));
    return cycles * px('--monster-cycle');
  };

  const sendMonster = () => {
    if (walking) return; // a second Alt+A is ignored until this walk has finished
    walking = true;

    root.style.setProperty('--monster-crossing', crossingSeconds().toFixed(2) + 's');

    const monster = document.createElement('div');
    monster.className = 'monster';
    monster.setAttribute('aria-hidden', 'true');
    monster.innerHTML = '<div class="monster-shadow"></div><div class="monster-sprite"></div>';
    document.body.appendChild(monster);

    const leave = () => {
      monster.remove();
      walking = false;
    };

    // Under prefers-reduced-motion the CSS parks the monster instead of animating
    // it, so there is no animationend to wait for.
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setTimeout(leave, STILL_MS);
    } else {
      monster.addEventListener('animationend', leave, { once: true });
    }
  };

  document.addEventListener('keydown', (e) => {
    if (e.altKey && !e.ctrlKey && !e.metaKey && e.code === 'KeyA') {
      e.preventDefault();
      sendMonster();
    }
  });
})();
