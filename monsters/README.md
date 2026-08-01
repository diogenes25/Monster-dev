# `monsters/` — the roster

One PNG per monster, plus `catalog.json` recording what each one is.

## The roster exists twice, on purpose

`catalog.json` is the machine-readable record: geometry, tempo, and the provenance of every
sheet. It is written by `tools/provenance/New-SpriteSheetFromVideo.ps1` from the same variables
that composed the PNG, so the numbers cannot drift from the artwork by being retyped.

**A hire never reads it.** The roster a hire is offered is the table in `MONSTER-DEV.md` §5,
inline in the playbook it has already fetched — no second request, and no `raw.githubusercontent`
directory listing to depend on (there isn't one). That duplication is the cost of one fetch per
hire instead of two, and it means adding a monster is not finished until the table is updated
too. The generator says so when it writes an entry.

## Adding a monster

Put the footage in `sources/` first and run from the repository root, so the `sourceVideo` the
generator records is a path that still resolves for whoever regenerates the sheet next:

```powershell
.\tools\provenance\New-SpriteSheetFromVideo.ps1 `
  -VideoPath .\sources\<clip>.mp4 `
  -OutputPath .\monsters\<slug>.png `
  -CatalogPath .\monsters\catalog.json -Slug <slug> `
  -Faces left -Character '<creature>' -Look '<one line>'
```

Then, in order:

1. **Check the loop on the finished sheet.** This is the gate, not the generator's own figure:

   ```powershell
   .\tools\provenance\Test-SheetLoop.ps1
   ```

   It measures the seam a viewer actually sees — last cell handing over to the first — against
   the sheet's own mean adjacent-cell step, and exits non-zero if any sheet hitches. A wrong gait
   period is the usual cause; establish the period independently and pin `-Period` /
   `-StartFrame`. Do not trust a filename that says "loop": `green-fuzz-strolling` came from a
   clip advertised as a seamless infinity loop whose last frame does not hand over to its first
   at all.
2. **Look at the sheet.** The cut-out is heuristic. Check the tail, the feet, and that no scene
   element got welded to the head.
3. **Add the row to `MONSTER-DEV.md` §5** — frames, cell, cycle, faces. Until then the sheet is
   unreachable: the playbook table is the only index a hire has.
4. **Leave `default` alone** unless you mean to change what every client gets who has no
   preference. Changing it also breaks comparability with every earlier test run in `test/runs/`.

## Why the sheet, and not the footage, decides

`Test-SheetLoop.ps1` reports `green-fuzz-classic` at `1.03x` and `green-fuzz-strolling` at
`0.85x` — both seamless. Run it rather than trusting these numbers; that is the point of it
existing.

Two ways of measuring a candidate cycle disagree, and the disagreement is worth knowing about
because both wrong turns are easy to take:

- **On raw video frames** the character's travel across the shot counts as mismatch — and travel
  is exactly what aligning cells on a shared body axis and ground line removes. Measured this
  way the *wrong* period wins by a wide margin. The generator avoids this by comparing in the
  anchored frame, which is why its ranking can be trusted.
- **On the generator's closure figure** the ranking is right but the absolute value is not a
  verdict. It is measured on sampled footage, not on cells: a 16-frame cycle it rated an
  acceptable `1.06x` produced a sheet that hitches at `1.39x`.

Hence the split. The generator picks the period; `Test-SheetLoop.ps1` decides whether the result
ships, because it measures the seam the viewer will actually see on the artifact that ships.

## Current entries

| slug | frames | cell | cycle | source |
| --- | --- | --- | --- | --- |
| `green-fuzz-classic` | 23 | 276 × 300 | 0.96 s | video not retained — predates `sources/`, hence the null provenance |
| `green-fuzz-strolling` | 17 | 299 × 300 | 0.71 s | `sources/Monster_walking_infinity_loop_202608011658.mp4`, frames 7..23 of 28 |

`sources/` also holds `Monster_walking_infinity_loop_202608011643_V1.mp4`, which is raw material
no sheet was cut from.

Both entries are the same character. A genuinely different creature needs different source
footage — the machinery here is ready for one, the artwork is not.
