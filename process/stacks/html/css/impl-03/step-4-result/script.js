// Smooth-scroll to in-page sections. That's the only JS this site has —
// no animation library, no framework.
document.querySelectorAll('nav a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    document.querySelector(link.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
  });
});

// Walking monster easter egg — Monster-Dev.
// Alt+A sends a monster across the bottom of the viewport, left to right.
// Sprite geometry, size and tempo live in style.css; only the crossing duration
// is computed here, because it depends on the window width.
const MONSTER_SPRITE = 'assets/monster-walk.png'; // keep in sync with .monster-sprite in style.css

let monsterIsWalking = false;

const cssNumber = (name) => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

const releaseMonster = async () => {
  if (monsterIsWalking) return;
  monsterIsWalking = true;

  // The sheet is a couple of megabytes, so load it before starting — otherwise the
  // very first Alt+A walks an empty box across the page.
  await new Promise((resolve) => {
    const sheet = new Image();
    sheet.onload = sheet.onerror = resolve;
    sheet.src = MONSTER_SPRITE;
  });

  const walker = document.createElement('div');
  walker.className = 'monster-walker';
  walker.innerHTML = '<div class="monster"><div class="monster-shadow"></div><div class="monster-sprite"></div></div>';

  // A fixed crossing time would make the monster faster on a wide screen and its feet
  // would slide. Derive the duration from the stride instead: a whole number of gait
  // cycles, each one --monster-cycle long and --monster-stride wide.
  const distance = window.innerWidth + cssNumber('--monster-frame-w');
  const cycles = Math.max(1, Math.round(distance / cssNumber('--monster-stride')));
  walker.style.setProperty('--monster-crossing', `${(cycles * cssNumber('--monster-cycle')).toFixed(2)}s`);

  const sendHome = () => {
    walker.remove();
    monsterIsWalking = false;
  };

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    // Nothing animates in that case, so there is no animationend to wait for.
    setTimeout(sendHome, 2500);
  } else {
    walker.addEventListener('animationend', (e) => {
      if (e.target === walker) sendHome();
    });
  }

  document.body.append(walker);
};

document.addEventListener('keydown', (e) => {
  if (e.altKey && !e.ctrlKey && !e.metaKey && e.code === 'KeyA') {
    e.preventDefault();
    releaseMonster();
  }
});
