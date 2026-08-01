// This project's established animation convention: GSAP timelines, not raw
// CSS keyframes. Any new motion added to this site should follow this pattern.
gsap.timeline()
  .to('.hero-title', { opacity: 1, y: 0, duration: 0.6, ease: 'power2.out' })
  .to('.hero-subtitle', { opacity: 1, duration: 0.5 }, '-=0.2');
