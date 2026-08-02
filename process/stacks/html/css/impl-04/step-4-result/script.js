// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg — Monster-Dev. Alt+A sends it once across the
// bottom of the screen; ignored while one is already walking. Speed is
// controlled by --monster-stride in style.css, size by --monster-frame-w/-h.
(() => {
  let isWalking = false;

  document.addEventListener('keydown', (e) => {
    if (!e.altKey || e.key.toLowerCase() !== 'a' || isWalking) return;
    isWalking = true;

    const walker = document.createElement('div');
    walker.className = 'monster-walker';
    walker.innerHTML = `
      <div class="monster-face">
        <div class="monster-shadow"></div>
        <div class="monster-sprite"></div>
      </div>
    `;
    document.body.appendChild(walker);

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setTimeout(() => {
        walker.remove();
        isWalking = false;
      }, 1600);
      return;
    }

    // Duration follows the stride, not the other way round — a fixed duration
    // would make the walk faster on wide screens and the feet would slide.
    const root = getComputedStyle(document.documentElement);
    const frameWidth = parseFloat(root.getPropertyValue('--monster-frame-w'));
    const cycleTime = parseFloat(root.getPropertyValue('--monster-cycle'));
    const stride = parseFloat(root.getPropertyValue('--monster-stride'));
    const distance = window.innerWidth + frameWidth;
    const cycles = Math.max(1, Math.round(distance / stride));
    walker.style.setProperty('--monster-duration', `${(cycles * cycleTime).toFixed(2)}s`);

    walker.addEventListener('animationend', () => {
      walker.remove();
      isWalking = false;
    });
  });
})();
