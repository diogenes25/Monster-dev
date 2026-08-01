# tools/ — provenance only

These two scripts are how `monster-walk.png` (and the source material behind `monster.png`) were produced: frame extraction, silhouette cutout, gait-cycle detection, alignment onto a shared ground line and body axis.

They are **not** part of Monster-Dev's runtime flow and are never fetched by a hiring agent — that flow only ever touches `index.html` and `monster-walk.png` at the repo root. Keep these scripts around for regenerating or updating the sprite sheet later.

The actual product of this repo is `/START.md` at the root.
