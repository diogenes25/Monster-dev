// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Alt+A walking-monster easter egg — Monster-Dev.
// Speed/size live as CSS custom properties on :root in style.css;
// --monster-stride is the one to change for a faster or slower walk.
(() => {
  let walking = false;

  const px = (name) =>
    parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

  function crossingDuration() {
    const distance = window.innerWidth + px('--monster-frame-w');
    const cycles = Math.max(1, Math.round(distance / px('--monster-stride')));
    return cycles * px('--monster-cycle');
  }

  function walkMonster() {
    if (walking) return;
    walking = true;

    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    const walker = document.createElement('div');
    walker.className = 'monster-walker';
    const face = document.createElement('div');
    face.className = 'monster-face';
    face.innerHTML = '<div class="monster-shadow"></div><div class="monster-sprite"></div>';
    walker.append(face);

    if (reducedMotion) {
      walker.style.animation = 'none';
      walker.style.transform = 'translateX(50vw)';
      face.querySelector('.monster-sprite').style.animation = 'none';
      document.body.append(walker);
      setTimeout(() => {
        walker.remove();
        walking = false;
      }, 2000);
      return;
    }

    walker.style.setProperty('--monster-crossing', `${crossingDuration()}s`);
    walker.addEventListener('animationend', () => {
      walker.remove();
      walking = false;
    });
    document.body.append(walker);
  }

  document.addEventListener('keydown', (e) => {
    if (e.altKey && e.code === 'KeyA') {
      e.preventDefault();
      walkMonster();
    }
  });
})();
