"""Summarize a CSV of sales rows and print a report to stdout.

Usage: python report.py sales.csv
       python report.py sales.csv --html report.html
"""
import argparse
import csv
import html
import shutil
import sys
from collections import defaultdict
from pathlib import Path
from string import Template

SPRITE_NAME = "monster.png"

HTML_TEMPLATE = Template("""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Sales report</title>
<style>
  html { overflow-x: hidden; }

  body {
    margin: 0 auto;
    padding: 2.5rem 1.5rem 9rem;
    max-width: 40rem;
    font: 1rem/1.5 ui-monospace, SFMono-Regular, Consolas, monospace;
    color: #222;
    background: #fff;
  }

  h1 { font-size: 1.25rem; font-weight: 600; margin: 0 0 1.5rem; }

  table { border-collapse: collapse; width: 100%; }
  th, td { padding: 0.35rem 0.75rem; border-bottom: 1px solid #e5e5e5; text-align: left; }
  th { font-weight: 600; border-bottom: 2px solid #222; }
  .num { text-align: right; font-variant-numeric: tabular-nums; }

  /* walking monster easter egg -- Monster-Dev.
     Sprite sheet $sprite is a single row of 23 frames of 276 x 300 px: one full
     gait cycle cut from 24 fps footage, so the cycle time is 23/24 = 0.96 s. The
     vertical bob is drawn into the frames -- adding one in CSS produces a limp.
     Every figure below belongs to this one sheet, not to the technique. */
  .monster-walk {
    --frame-w: 120px;
    --frame-h: calc(var(--frame-w) * 300 / 276);   /* keeps the cell aspect ratio */
    --sheet-w: calc(var(--frame-w) * 23);          /* must match steps(23) below */
    --cycle: 0.96s;
    /* Ground distance covered by one full gait cycle. This is the speed control:
       larger is faster, until the feet visibly skate across the ground. */
    --stride: 85px;
    --crossing: 18s;                               /* fallback; the script derives the real value */

    position: fixed;
    left: 0;
    bottom: 1.25rem;                               /* keeps feet and shadow clear of the window edge */
    width: var(--frame-w);
    height: var(--frame-h);
    pointer-events: none;
    animation: monster-across var(--crossing) linear 1 forwards;
  }

  /* The artwork faces left and the monster travels right to left, so it is not
     mirrored. The shadow offset comes from the sheet's own ground contact: every
     frame shares a ground line on the cell's bottom row, and the feet sit between
     30% and 60% of the cell width across the cycle, centred on 45% -- the rest of
     the silhouette to the right of that is tail. Mirroring the sprite would mean
     mirroring this offset with it, or the shadow ends up under the wrong end. */
  .monster-walk::before {
    content: "";
    position: absolute;
    left: 26%;
    bottom: -3px;                                  /* centred on the ground line, not floating above it */
    width: 38%;
    height: 8px;
    background: rgba(60, 80, 60, 0.22);
    border-radius: 50%;
    filter: blur(3px);
  }

  /* Travel lives on the wrapper, the gait on the sprite. Keeping them on separate
     elements is what lets the walk cycle loop while the crossing runs once. */
  .monster-walk::after {
    content: "";
    position: absolute;
    inset: 0;
    background: url("$sprite") no-repeat;
    background-size: var(--sheet-w) var(--frame-h);
    animation: monster-gait var(--cycle) steps(23) infinite;
  }

  @keyframes monster-gait {
    from { background-position: 0 0; }
    to   { background-position: calc(-1 * var(--sheet-w)) 0; }
  }

  @keyframes monster-across {
    from { transform: translateX(100vw); }
    to   { transform: translateX(calc(-1 * var(--frame-w))); }
  }

  @media (prefers-reduced-motion: reduce) {
    /* Something visible and still beats something moving for a reader who asked
       for less motion. */
    .monster-walk { animation: none; transform: translateX(65vw); }
    .monster-walk::after { animation: none; }
  }
</style>
</head>
<body>
  <h1>Sales report</h1>
  <table>
    <thead>
      <tr><th>Region</th><th class="num">Orders</th><th class="num">Total</th></tr>
    </thead>
    <tbody>
$rows
    </tbody>
  </table>
  <div class="monster-walk" aria-hidden="true"></div>
  <script>
    /* The distance to cross depends on the window width, the gait tempo does not.
       A fixed duration would make the monster travel faster on a wide monitor and
       its feet would slide, so the duration is derived instead: a whole number of
       gait cycles, each one --cycle long and --stride wide. Rounding to whole
       cycles is the point -- the walk then ends on the foot it started on. */
    (() => {
      const walker = document.querySelector('.monster-walk');
      const px = (name) => parseFloat(getComputedStyle(walker).getPropertyValue(name));
      const distance = window.innerWidth + px('--frame-w');
      const cycles = Math.max(1, Math.round(distance / px('--stride')));
      walker.style.setProperty('--crossing', (cycles * px('--cycle')).toFixed(2) + 's');
    })();
  </script>
</body>
</html>
""")


def summarize(path):
    totals = defaultdict(float)
    counts = defaultdict(int)
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            region = row["region"]
            totals[region] += float(row["amount"])
            counts[region] += 1
    return totals, counts


def render_html(totals, counts):
    """Render the per-region summary as a standalone HTML page."""
    rows = "\n".join(
        f'      <tr><td>{html.escape(region)}</td>'
        f'<td class="num">{counts[region]}</td>'
        f'<td class="num">{totals[region]:.2f}</td></tr>'
        for region in sorted(totals)
    )
    return HTML_TEMPLATE.substitute(rows=rows, sprite=SPRITE_NAME)


def write_html(path, totals, counts):
    """Write the HTML report to path, with the sprite sheet beside it."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(render_html(totals, counts), encoding="utf-8")
    sprite = Path(__file__).resolve().with_name(SPRITE_NAME)
    beside_report = path.resolve().with_name(SPRITE_NAME)
    if sprite != beside_report:
        shutil.copyfile(sprite, beside_report)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", help="Path to a sales CSV with region,amount columns")
    parser.add_argument(
        "--html",
        metavar="PATH",
        help="Additionally write the summary as an HTML page to PATH",
    )
    args = parser.parse_args()

    totals, counts = summarize(args.csv_path)
    print(f"{'Region':<15}{'Orders':>10}{'Total':>15}")
    for region in sorted(totals):
        print(f"{region:<15}{counts[region]:>10}{totals[region]:>15.2f}")

    if args.html:
        write_html(args.html, totals, counts)


if __name__ == "__main__":
    sys.exit(main())
