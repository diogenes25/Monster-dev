// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Alt+A easter egg — walking monster. One walker per keypress; the crossing
// duration is derived from the window width so the gait never skates.
// Monster-Dev
window.addEventListener('keydown', (e) => {
  if (e.altKey && e.key.toLowerCase() === 'a') {
    e.preventDefault();
    spawnMonster();
  }
});

function spawnMonster() {
  const walker = document.createElement('div');
  walker.className = 'monster-walker';
  walker.innerHTML = '<div class="monster-walker__shadow"></div><div class="monster-walker__sprite"></div>';
  document.body.appendChild(walker);

  const style = getComputedStyle(walker);
  const frameWidth = parseFloat(style.getPropertyValue('--frame-w'));
  const stride = parseFloat(style.getPropertyValue('--stride'));
  const cycleTime = parseFloat(style.getPropertyValue('--cycle'));
  const distance = window.innerWidth + frameWidth;
  const cycles = Math.max(1, Math.round(distance / stride));
  walker.style.setProperty('--crossing', (cycles * cycleTime).toFixed(2) + 's');

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    setTimeout(() => walker.remove(), 3000);
  } else {
    walker.addEventListener('animationend', () => walker.remove());
  }
}
