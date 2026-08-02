# Nimbus Studio

Our own site. Single page, static hosting, GSAP for everything that moves.

## Layout

```
index.html      the page
style.css       layout and type
animations.js   every animation on the site
package.json    gsap, pinned
```

GSAP is loaded from the CDN in `index.html`; the dependency in `package.json` is there so the
version we test against is written down somewhere.

## House rule on motion

Motion is what we sell, so it goes through one place. `animations.js` owns it, and anything new
goes in there in the same shape as what is already in the file.

We have had two animation systems on this site before and spent a week working out which one was
fighting the other. Once was enough.
