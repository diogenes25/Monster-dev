<#
.SYNOPSIS
Builds the <dist> mirror a test hire is allowed to see, and refuses to hand it over if anything leaked in.

.DESCRIPTION
<dist> is **no longer** "exactly the surface a push to GitHub would make public". It is that
surface minus everything that would tell a hire what is being measured, and the difference is
now a policy rather than an exception:

  process/    the scenarios, answer scripts and acceptance criteria, the board, and the
              implementation records — an agent that reads them passes by knowing the answers,
              and every future run is worthless
  .claude/    the monster-dev-workshop skill, which describes the harness and what is measured
  CLAUDE.md   summarises the playbook: the technique by name, the sprite geometry, the §8 rule
  README.md   the repository's face for a human on GitHub, and that is the only reader it has.
              A hire's entry point is START.md, by design and since the first run — so excluding
              it costs a hire nothing, and it costs production nothing because in production
              there are no criteria to leak. Its own "Monster-Dev gets better by being tested"
              section reached eight of the first ten hires, all four Sonnet runs among them.
  THESIS.md   why the monster exists at all: it is the fixture of an experiment about whether a
              narrow AI developer measurably improves. A hire that read one paragraph of it would
              know it is the subject rather than the contractor.

The first two used to drop out on their own because they were untracked or gitignored. They are
tracked now, so the exclusion has to be deliberate — and verified, not assumed. That is why
building and checking live in one script: a mirror built by hand is a mirror nobody checked.

Three checks follow the copy, and only the first names a path.

  1. the five exclusions above actually arrived nowhere, and START.md actually arrived
  2. the mirror is internally consistent. §2 and §5 of the playbook are the only indexes a hire
     has, since raw.githubusercontent.com serves no directory listing, so the mirror is verified
     against the playbook's own prose: nothing listed may be missing, nothing present unlisted
  3. no permitted file *describes the harness*, no permitted file is a finished implementation of
     the job, and no permitted file carries the record tree's own wiki syntax. A path list only
     ever excludes the leaks already found; these three ask what the copied files say, what they
     reference and how they are written, so a newly published file cannot slip past them by
     having a name nobody thought of.

Run it from the repository root.

.PARAMETER RunId
Identifies the run; the mirror is created at ..\monster-dev-testruns\<RunId>\dist, beside the
run folder new-run.ps1 writes and inside a parent reserved for this run alone. It used to be a
direct child of ..\monster-dev-testruns\, where one `ls ..` from the hire's working directory
listed every previous run and mirror by name.

.PARAMETER Without
Paths (repo-relative, wildcards allowed) to additionally leave out.

Note that dropping a whole stack or sheet this way now **fails** the index check below, on
purpose: §2 and §5 would still tell the hire to fetch it, so the arm would differ from its
pair by the missing notes *plus* a turn burned on a 404 — and num_turns is one of the two
numbers the tooling gate reads. Removing content at file granularity is also the wrong size
for the question actually being asked, which is usually about one entry or one fragment
inside a file. Both are -Variant's job, not this one's.

.PARAMETER Variant
Name of a variant under process\variants\<name>.psd1, applied to the mirror after the copy and
before every check. This is the mechanism for an A/B arm that differs by a paragraph or a
fragment *inside* a file — the size an arm usually is, and the one -Without cannot express.

Each edit names a File, an anchor, and what to do with it. The anchor must match **exactly
once**: zero matches and two matches are both hard failures, because an overlay that silently
lands in the wrong place or silently does nothing still produces a mirror, a run and a number,
and the number then means something nobody wrote down.

    @{
        Description = 'Arm B: bound the build to the announced change set (#002)'
        Edits = @(
            @{ File = 'MONSTER-DEV.md'; After = '<a sentence quoted from the file>'; Insert = "`n`n<the new paragraph>" }
        )
    }

`After` + `Insert` puts text straight after the anchor. `Replace` + `With` substitutes it, and
`With` omitted or empty deletes it — which is the arm a fragment needs, since CLAUDE.md's rule
is that deleting a fragment must leave its entry true.

The file is *data*: Import-PowerShellDataFile evaluates no code, so a variant cannot reach into
the build. It lives under process\, which is excluded from the mirror already.

.PARAMETER AllowHarnessProse
Skips check 3's vocabulary grep. There is exactly one legitimate caller — the validation of the
term list itself, which needs a mirror built from files that trip it. Anything else reaching for
this flag is rewording the playbook to satisfy the harness, and the term comes out of the list
instead.

.EXAMPLE
.\process\tools\build-dist.ps1 -RunId 2026-08-02-alt-a

.EXAMPLE
.\process\tools\build-dist.ps1 -RunId 2026-08-02-alt-a-armA -Without 'index.html'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RunId,
    [string[]]$Without = @(),
    [string]$Variant,
    [switch]$AllowHarnessProse
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$dist = Join-Path (Resolve-Path '..').Path "monster-dev-testruns\$RunId\dist"
if (Test-Path $dist) { Remove-Item -Recurse -Force $dist }
New-Item -ItemType Directory -Force $dist | Out-Null

# Never published to a hire. Keep this list and the verification below in step.
#
# CLAUDE.md, README.md and THESIS.md are tracked, so these three lines are the only thing keeping
# them out of the mirror — they are not the belt-and-braces entries they look like. That is exactly
# the trap test/ (now process/) and .claude/ already fell into: an exclusion that worked by accident
# stopped working the day the file was committed. CLAUDE.md summarises the playbook, the sprite
# geometry and the §8 rule; README.md explains that this repository improves itself by scoring
# test hires; THESIS.md says what the monster is a fixture *for*, which tells a reader in one
# paragraph that it is the subject of an experiment. The check below stays as the backstop for all
# five.
#
# The backstop only helps if it is kept in step. It hard-codes the same names as the line below,
# which means a rename breaks *both* at once and in the same direction — the filter stops
# matching, and the check hunts a file that is no longer there and reports clean. That happened
# on 2026-08-02 (test/ -> process/). Change one, change the other, then build a mirror and look
# inside it: this script passing is not on its own evidence that anything was excluded.
$excluded = @('process/*', '.claude/*', 'CLAUDE.md', 'README.md', 'THESIS.md') + $Without

$copied = 0
foreach ($file in (git ls-files)) {
    if ($excluded | Where-Object { $file -like $_ }) { continue }
    $target = Join-Path $dist $file
    New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
    Copy-Item $file $target
    $copied++
}

# --- the variant overlay, applied before every check below ---------------------------------------
#
# An A/B arm is normally one paragraph or one fragment inside a file. -Without works at file
# granularity, so until this existed a sub-file A/B could not be built at all — SKILL.md said so
# in as many words, and #002, the only item ever to reach `grilled`, was blocked on this sentence
# without anybody having written that down.
#
# Anchored, not a patch. A patch keys on line numbers and surrounding context and rots the moment
# either moves; an anchor is a sentence quoted out of the file, which is also how the arm is
# described in the item that asks for it.
#
# The anchor must match EXACTLY ONCE, and both other counts are hard failures:
#   0 — the anchor was edited or mistyped, and the arm would be built with no treatment in it
#   2 — the arm would be built with the treatment in an arbitrary one of two places
# Neither announces itself afterwards. The mirror still builds, the run still runs, and the two
# arms differ by an amount nobody can state — which is worse than no A/B, because it still
# produces a number that looks like an answer.
#
# Every throw below goes through the catch at the bottom, which deletes the mirror before
# rethrowing. That is not tidiness. This script's stated promise is that it deletes a mirror
# rather than hand back a broken one, and the checks further down keep it by collecting into
# $failures — but a `throw` up here would jump straight past them, which is how the first draft
# of this block behaved: all five failure modes left a mirror on disk. The multi-edit case is the
# sharp one. Edit 1 applies, edit 2 fails, and what is left is a mirror carrying *half* a
# treatment, which looks exactly like a correct arm and would silently become one.
$variantEdits = @()
if ($Variant) {
  try {
    $vPath = "process\variants\$Variant.psd1"
    if (-not (Test-Path $vPath)) { throw "BROKEN: no variant '$Variant' — expected $vPath." }

    $v = Import-PowerShellDataFile $vPath
    if (-not $v.Edits) { throw "BROKEN: variant '$Variant' declares no Edits." }

    foreach ($e in $v.Edits) {
        if (-not $e.File) { throw "BROKEN: variant '$Variant' has an edit with no File." }
        $t = Join-Path $dist $e.File
        if (-not (Test-Path $t)) {
            throw "BROKEN: variant '$Variant' edits '$($e.File)', which is not in the mirror — -Without may have dropped it."
        }

        $hasAfter   = $e.ContainsKey('After')
        $hasReplace = $e.ContainsKey('Replace')
        if ($hasAfter -eq $hasReplace) {
            throw "BROKEN: edit on '$($e.File)' must declare exactly one of After or Replace."
        }
        $anchor = if ($hasAfter) { $e.After } else { $e.Replace }
        if ([string]::IsNullOrWhiteSpace($anchor)) {
            throw "BROKEN: edit on '$($e.File)' has an empty anchor."
        }

        # Escaped and counted as a literal. An anchor is a sentence out of the playbook and will
        # contain '.', '(' and '?' sooner or later; treating it as a pattern would make the match
        # count depend on punctuation nobody was thinking about.
        $text = Get-Content $t -Raw
        $n    = [regex]::Matches($text, [regex]::Escape($anchor)).Count
        if ($n -ne 1) {
            throw ("BROKEN: the anchor for '$($e.File)' matches $n time(s) in the mirror, and must match exactly 1." +
                   "`n  anchor: $anchor")
        }

        if ($hasAfter) {
            if (-not $e.ContainsKey('Insert')) { throw "BROKEN: edit on '$($e.File)' has After but no Insert." }
            $new = $text.Replace($anchor, $anchor + $e.Insert)
            $what = 'insert after'
        } else {
            # `With` absent or empty is a deletion, which is the arm a fragment needs.
            $new  = $text.Replace($anchor, [string]$e.With)
            $what = if ([string]::IsNullOrEmpty([string]$e.With)) { 'delete' } else { 'replace' }
        }
        if ($new -eq $text) { throw "BROKEN: edit on '$($e.File)' changed nothing." }

        # Rewritten as UTF-8 without BOM, which is what the tracked files already are. Stated
        # rather than assumed: this is the one place a mirrored file is written instead of copied.
        Set-Content $t $new -Encoding utf8 -NoNewline

        $short = if ($anchor.Length -gt 48) { $anchor.Substring(0, 45) + '...' } else { $anchor }
        $variantEdits += "$($e.File): $what '$short'"
    }
  } catch {
    Remove-Item -Recurse -Force $dist -ErrorAction SilentlyContinue
    throw "$_`nMirror deleted so a half-applied variant cannot be used as an arm."
  }
}

# --- check 1: the named exclusions, verified rather than assumed ---
$failures = @()
foreach ($forbidden in 'process', '.claude') {
    if (Test-Path (Join-Path $dist $forbidden)) { $failures += "LEAK: $forbidden reached the mirror" }
}
foreach ($stray in (Get-ChildItem -Recurse -File -Filter 'CLAUDE.md' $dist)) {
    $failures += "LEAK: $($stray.FullName)"
}
# Only the root one. monsters/README.md and stacks/<name>/README.md are published on purpose and
# a hire needs them; it is the repository's own front page that describes the experiment.
if (Test-Path (Join-Path $dist 'README.md')) {
    $failures += "LEAK: README.md reached the mirror — it tells the hire it is in a scored test run"
}
if (Test-Path (Join-Path $dist 'THESIS.md')) {
    $failures += "LEAK: THESIS.md reached the mirror — it says the monster is a fixture and the hire is the subject"
}
if (-not (Test-Path (Join-Path $dist 'START.md'))) {
    $failures += "BROKEN: START.md missing — a hire has no entry point"
}

# --- check 2: the mirror against the playbook's own indexes ---
#
# The playbook's prose is the only index a hire has, so the mirror has to be checked against it
# rather than against the working tree. A listed-but-absent stack costs a hire a turn on a 404 —
# and num_turns is one of the two numbers the tooling gate reads, so the confound lands directly
# in the measurement. An absent-but-unlisted one is simply unreachable.
$playbook = Join-Path $dist 'MONSTER-DEV.md'
if (-not (Test-Path $playbook)) {
    $failures += "BROKEN: MONSTER-DEV.md missing — a hire has no method and no index"
} else {
    . (Join-Path $PSScriptRoot 'lib\playbook-index.ps1')

    $listedStacks = @(Get-PlaybookStacks -PlaybookPath $playbook)
    $mirrorStacks = @(Get-ChildItem (Join-Path $dist 'stacks') -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName 'README.md') } | ForEach-Object { $_.Name })

    foreach ($s in $listedStacks | Where-Object { $_ -notin $mirrorStacks }) {
        $failures += "DEAD POINTER: §2 lists stack '$s' but stacks/$s/README.md is not in the mirror"
    }
    foreach ($s in $mirrorStacks | Where-Object { $_ -notin $listedStacks }) {
        $failures += "UNREACHABLE: stacks/$s/README.md is in the mirror but §2 does not list it"
    }

    $listedSheets = @(Get-PlaybookSheets -PlaybookPath $playbook)
    $mirrorSheets = @(Get-ChildItem (Join-Path $dist 'monsters') -Filter '*.png' -ErrorAction SilentlyContinue |
        ForEach-Object { $_.BaseName })

    foreach ($m in $listedSheets | Where-Object { $_ -notin $mirrorSheets }) {
        $failures += "DEAD POINTER: §5 lists sheet '$m' but monsters/$m.png is not in the mirror"
    }
    foreach ($m in $mirrorSheets | Where-Object { $_ -notin $listedSheets }) {
        $failures += "UNREACHABLE: monsters/$m.png is in the mirror but §5 does not list it"
    }
}

# --- check 3a: no permitted file describes the harness ---
#
# A path list only ever excludes the leaks somebody already found. Three of them were found on
# 2026-08-02, in files nobody had thought to look at: the root README's "gets better by being
# tested" section, tools/project.md's paragraph about the verifier encoding the criteria, and
# monsters/README.md's warning about comparability with earlier runs. Two of those were written
# *in service of* keeping the criteria out of the mirror, inside the mirror.
#
# So this asks what the copied files say instead of what they are called. A newly published file
# cannot slip past it by having a name nobody added to a list.
#
# Which reader this protects: the **hire**, against learning that it is being measured. It is not
# new-run.ps1's product-name scan, which protects the hire's own working copy against learning the
# expected answer, and it is not score-bundle.ps1's criteria terms, which protect the blind
# scorer. Three readers, three leaks, three lists on purpose — a shared list would be the union
# of all three and would make every one of them noisier.
#
# A term that fires on legitimate playbook prose comes out of this list. It does not get
# accommodated by rewording MONSTER-DEV.md, because a check that edits the product to stay quiet
# has stopped being a check.
#
# `harness` on its own is *not* in the list, and that is the rule working rather than an
# oversight: MONSTER-DEV.md §7 tells a hire to build "a scratch harness" outside the client's
# project. A term that fires on the product's own prose is a term that would get the product
# reworded, so it comes out. `test harness` is two words and fires on neither.
$HARNESS_VOCABULARY = @(
    'acceptance criteri',   # criteria / criterion
    'test run',
    'test hire',
    'test harness',
    'criterion by criterion',
    'what is being measured',
    'comparability',
    'A/B'
)

if (-not $AllowHarnessProse) {
    foreach ($md in (Get-ChildItem -Recurse -File -Filter '*.md' $dist)) {
        $n = 0
        foreach ($line in (Get-Content $md.FullName)) {
            $n++
            foreach ($term in $HARNESS_VOCABULARY) {
                if ($line -match [regex]::Escape($term)) {
                    $rel = $md.FullName.Substring($dist.Length).TrimStart('\')
                    $failures += "HARNESS PROSE: ${rel}:${n} says '$term' — the mirror is telling the hire it is being measured"
                }
            }
        }
    }
}

# --- check 3b: no permitted file is a finished implementation of the job ---
#
# The vocabulary grep reads .md. A finished implementation of the brief is .html, .css, .js and a
# sprite, and contains none of those words — so the *worst* thing that could reach a mirror is
# precisely what 3a would miss. This one keys on the artifact instead: anything that points at a
# sprite sheet is either the roster, the sheet itself, or a solution.
#
# index.html is the one legitimate implementation and it is published on purpose — it is the
# dom-css stack's reference, reachable from §2. It is named here rather than pattern-matched,
# because it is a single known exception and an exception with a name is auditable.
$IMPLEMENTATION_EXEMPT = @('MONSTER-DEV.md', 'index.html', 'monsters\README.md', 'monsters\catalog.json')

foreach ($f in (Get-ChildItem -Recurse -File $dist)) {
    $rel = $f.FullName.Substring($dist.Length).TrimStart('\')
    if ($rel -in $IMPLEMENTATION_EXEMPT) { continue }
    if ($rel -like 'monsters\*' -or $rel -like 'sources\*') { continue }
    if ($f.Extension -in '.png', '.jpg', '.mp4', '.svg', '.woff', '.woff2') { continue }

    $hit = Select-String -LiteralPath $f.FullName -Pattern 'monsters/[a-z0-9-]+\.png' -List -ErrorAction SilentlyContinue
    if ($hit) {
        $failures += "IMPLEMENTATION: ${rel}:$($hit.LineNumber) references a sprite sheet — a mirror must not contain a finished solution to the brief"
    }
}

# --- check 3c: no record-tree convention followed a paragraph into the mirror ---
#
# The record tree under process/ is a wiki: OKF frontmatter on run records, `[[wikilinks]]` in the
# body of both trees. Paragraphs are promoted *out* of that tree into stacks/<name>/README.md when
# they pass the A/B gate, and a promoted paragraph carries its syntax with it.
#
# Both halves fail a hire in the same way. A `[[stride]]` is a pointer into a tree the mirror does
# not contain — the same failure as "citation is an identifier, never a locator", arriving by a new
# road. Frontmatter bills every hire for metadata only we read, on the one file it always fetches.
#
# Only the **first** line may not be `---`. A horizontal rule is legal and load-bearing further
# down: it is what separates a stack note's gate-free orientation from its measured pitfalls, and
# check-index.ps1 counts the 40-line cap against it.
foreach ($md in (Get-ChildItem -Recurse -File -Filter '*.md' $dist)) {
    $rel   = $md.FullName.Substring($dist.Length).TrimStart('\')
    $lines = @(Get-Content $md.FullName)

    if ($lines.Count -and $lines[0].Trim() -eq '---') {
        $failures += "FRONTMATTER: $rel opens with '---' — no YAML frontmatter on anything a hire fetches"
    }
    $n = 0
    foreach ($line in $lines) {
        $n++
        if ($line -match '\[\[') {
            $failures += "WIKILINK: ${rel}:${n} carries a [[wikilink]] into the mirror, pointing at a tree the hire cannot fetch"
        }
    }
}

if ($failures) {
    Remove-Item -Recurse -Force $dist
    throw ($failures -join "`n") + "`nMirror deleted so it cannot be used by accident."
}

[pscustomobject]@{
    Dist     = $dist
    Files    = $copied
    Excluded = $excluded -join ', '
    Stacks   = $listedStacks -join ', '
    Sheets   = $listedSheets -join ', '
    IndexOk  = $true
    # Named in the returned object so the difference between two arms is on the record without
    # anybody retyping it. `(none)` rather than blank: an arm built with no variant and an arm
    # whose variant silently did nothing must not print the same thing.
    Variant  = if ($Variant) { $Variant } else { '(none)' }
    Edits    = if ($variantEdits) { $variantEdits -join '; ' } else { '(none)' }
}
