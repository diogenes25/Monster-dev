<#
.SYNOPSIS
Renders every implementation on record as a runnable demo onto a local gh-pages branch, and
prints the "See it running" section for the root README.

.DESCRIPTION
Ten hires implemented the same easter egg into the same page, and until now not one of those
results could be looked at by anyone who had not run it. What survives inside the repository is
a verdict per run and, since the #012 backfill, the project as it was handed back. This stack is
the one where showing that costs nothing: plain HTML/CSS/JS, no build step, no dependency. A
`step-4-result/` **is** a runnable site, and GitHub Pages is a static file server.

Two things make this script rather than a copy command.

**The demos must not be on `main`.** Ten finished implementations of the precise job a hire is
given are the answer sheet. Excluding them from the <dist> mirror does not contain that: a run
over real raw.githubusercontent.com URLs never reads a mirror at all, and the base URL a hire
derives in §0 points at `main`. Keeping them on an orphan `gh-pages` branch closes the exposure
structurally, for both run classes at once, and costs `main`'s checkout nothing.

**The index is rendered, never typed.** What each run was for lives in the tags and description
of `process/runs/<id>/knowledge.md` and nowhere else. This script reads that file. A hand-written
list would be a second place for the same fact to live, and it would drift.

The banner is answer (a) to #014's second half, chosen 2026-08-02: the description of the job
lives in the *published demo* and never in the fixture. A fixture that states the requirement
would put it in the hire's own working directory, changing the pressure on criteria 4a, 7 and
14a and ending comparability with every run on record. That variant is a separate fixture and a
separate scenario, filed as its own item.

The price of the banner, stated because `step-4-result/` makes the opposite promise: a published
demo is **not** byte-identical to what the hire handed back. `process/stacks/**/step-4-result/`
is the copy that is, and nothing writes into it.

.PARAMETER Branch
The orphan branch the demos are committed to. Default `gh-pages`.

.PARAMETER NoBanner
Publish the results without the requirement banner, byte-identical to `step-4-result/`. Not the
default: an unlabelled demo is a page about kites with an undocumented keyboard shortcut.

.PARAMETER WhatIf
Render and report, touch no branch. Use this first.

.EXAMPLE
.\process\tools\publish-demos.ps1 -WhatIf

.EXAMPLE
.\process\tools\publish-demos.ps1
#>
[CmdletBinding()]
param(
    [string]$Branch = 'gh-pages',
    [switch]$NoBanner,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'START.md')) {
    throw "Run this from the repository root — START.md is not here."
}

$repoRoot = (Resolve-Path '.').Path
$implRoot = 'process\stacks\html\css'

# The requirement, in the customer's voice. It says what the customer *wants* and never what
# Monster-Dev should do — a paragraph of the second kind was reaching hires from inside the
# fixture for the first ten runs, which is #015.
$WISH = 'Dies ist eine Beispiel-HTML-Seite, in der ein Easter-Egg einprogrammiert werden soll: ' +
        'ein Monster, das von links nach rechts läuft, wenn Alt+A gedrückt wird.'

# --- what there is to publish ------------------------------------------------------------------

function Get-RunRecord($runId) {
    $p = Join-Path $repoRoot "process\runs\$runId\knowledge.md"
    if (-not (Test-Path $p)) { return $null }
    $lines = @(Get-Content $p)
    if ($lines[0] -ne '---') { return $null }
    $end = 1; while ($end -lt $lines.Count -and $lines[$end] -ne '---') { $end++ }
    $fm = $lines[1..($end - 1)]
    $get = { param($k) ($fm | Where-Object { $_ -match "^${k}:\s*(.*)$" } |
             Select-Object -First 1) -replace "^${k}:\s*", '' }
    $tags = (& $get 'tags') -replace '^\[', '' -replace '\]$', '' -split ',' |
            ForEach-Object { $_.Trim() } | Where-Object { $_ }
    [pscustomobject]@{
        RunId       = $runId
        Description = (& $get 'description')
        Tags        = @($tags)
        Model       = @($tags | Where-Object { $_ -in 'opus', 'sonnet', 'haiku' })[0]
        Role        = @($tags | Where-Object { $_ -in 'baseline','control','proof-arm','no-change-arm','coverage','first-measurement' })[0]
    }
}

$demos = @()
foreach ($d in (Get-ChildItem $implRoot -Directory | Sort-Object Name)) {
    $result = Join-Path $d.FullName 'step-4-result'
    if (-not (Test-Path (Join-Path $result 'index.html'))) {
        Write-Verbose "$($d.Name): no index.html in step-4-result, skipped"
        continue
    }
    # The run id is in the impl's own knowledge.md, in the Source line. Not derived from the
    # folder name: impl numbering is capture order and says nothing about which run it was.
    $src = Get-Content (Join-Path $d.FullName 'knowledge.md') |
           Select-String -Pattern 'Source: run \[\[([^\]]+)\]\]' | Select-Object -First 1
    if (-not $src) { throw "BROKEN: $($d.Name)/knowledge.md has no 'Source: run [[<id>]]' line — nothing says which run built it." }
    $runId  = $src.Matches[0].Groups[1].Value
    $record = Get-RunRecord $runId
    if (-not $record) { throw "BROKEN: $runId has no OKF record at process/runs/$runId/knowledge.md — the index is rendered from it." }

    $demos += [pscustomobject]@{
        Impl = $d.Name; Result = $result; Run = $record
    }
}

if (-not $demos) { throw "BROKEN: nothing to publish — no step-4-result/index.html anywhere under $implRoot." }

# --- the README section, rendered ----------------------------------------------------------------
#
# Printed rather than written into README.md. The root README is excluded from the <dist> mirror
# (#018) but it is still on main, and this list is ten scored run ids: whoever pastes it is
# deciding to put that on the public front page, and that decision should be visible.

$owner = (git remote get-url origin 2>$null) -replace '.*github\.com[:/]', '' -replace '\.git$', ''
$base  = if ($owner) { "https://$(($owner -split '/')[0]).github.io/$(($owner -split '/')[1])" } else { '<pages-url>' }

$readme = @(
    '## See it running'
    ''
    'Every one of these is a real result: the same brief, the same starting page, implemented by a'
    'different hire. Open one and press **Alt+A**.'
    ''
    '| Demo | Model | What this one was |'
    '|---|---|---|'
) + @($demos | ForEach-Object {
    "| [``$($_.Run.RunId)``]($base/$($_.Run.RunId)/) | $($_.Run.Model) | $($_.Run.Description) |"
})

# --- render the branch ----------------------------------------------------------------------------

$staging = Join-Path ([System.IO.Path]::GetTempPath()) "monster-dev-pages-$PID"
if (Test-Path $staging) { Remove-Item -Recurse -Force $staging }
New-Item -ItemType Directory -Force $staging | Out-Null

foreach ($demo in $demos) {
    $out = Join-Path $staging $demo.Run.RunId
    Copy-Item -Recurse $demo.Result $out

    # A demo is a page, not a project checkout, and the project's own README is not part of what
    # the hire built. Dropping it matters more than tidiness here: every `step-4-result/` captured
    # by the #012 backfill froze the *old* fixture README, the one headed "Expected Monster-Dev
    # behavior" that #015 removed. Publishing these without this line puts the answer sheet on a
    # public URL — the one place the mirror exclusions provably do not reach.
    Remove-Item (Join-Path $out 'README.md') -ErrorAction SilentlyContinue

    if (-not $NoBanner) {
        $html = Get-Content (Join-Path $out 'index.html') -Raw
        $banner = @"
<div style="font:15px/1.5 system-ui,sans-serif;background:#111;color:#eee;padding:14px 18px">
  <strong>$($demo.Run.RunId)</strong> — $WISH
</div>
"@
        # After <body ...>, so the banner is the first thing painted and nothing below it moves.
        $patched = [regex]::Replace($html, '(<body[^>]*>)', "`$1`n$banner", 1)
        if ($patched -eq $html) { throw "BROKEN: no <body> in $($demo.Impl)'s index.html — cannot place the banner." }
        Set-Content (Join-Path $out 'index.html') $patched -Encoding utf8 -NoNewline
    }
}

@(
    '<!doctype html><meta charset="utf-8"><title>Monster-Dev — results</title>'
    '<div style="font:16px/1.6 system-ui,sans-serif;max-width:44rem;margin:3rem auto;padding:0 1rem">'
    '<h1>Monster-Dev — what it actually builds</h1>'
    "<p>$WISH</p>"
    '<p>Each link below is one hire&rsquo;s finished result, unedited apart from this note. Press <kbd>Alt</kbd>+<kbd>A</kbd>.</p>'
    '<ul>'
) + @($demos | ForEach-Object {
    "<li><a href=""$($_.Run.RunId)/"">$($_.Run.RunId)</a> — $($_.Run.Model) — $([System.Net.WebUtility]::HtmlEncode($_.Run.Description))</li>"
}) + @('</ul></div>') | Set-Content (Join-Path $staging 'index.html') -Encoding utf8

if ($WhatIf) {
    Remove-Item -Recurse -Force $staging
    ''
    "Would publish $($demos.Count) demo(s) to branch '$Branch':"
    $demos | ForEach-Object { "  $($_.Impl) -> $($_.Run.RunId)/  ($($_.Run.Model))" }
    ''
    'README section, rendered from process/runs/<id>/knowledge.md:'
    ''
    $readme
    ''
    'Nothing was written. Re-run without -WhatIf to commit the branch locally; pushing it, and'
    'switching Pages on, are separate and deliberate steps.'
    return
}

# An orphan branch, rebuilt from nothing each time. It shares no history with main on purpose:
# nothing on it should ever be merged back, and a demo is a snapshot rather than a line of work.
$current = (git rev-parse --abbrev-ref HEAD)
$tree    = Join-Path ([System.IO.Path]::GetTempPath()) "monster-dev-pages-wt-$PID"
if (Test-Path $tree) { Remove-Item -Recurse -Force $tree }

git worktree add --detach -q $tree
try {
    Push-Location $tree
    git checkout -q --orphan $Branch
    git rm -rq --cached . 2>$null | Out-Null
    Get-ChildItem . -Force | Where-Object { $_.Name -ne '.git' } | Remove-Item -Recurse -Force
    Copy-Item -Recurse (Join-Path $staging '*') .
    # Pages runs Jekyll otherwise, which silently drops anything starting with an underscore.
    New-Item -ItemType File -Force '.nojekyll' | Out-Null
    git add -A
    git commit -qm "Publish $($demos.Count) results as runnable demos"
    Pop-Location
} finally {
    if ((Get-Location).Path -eq $tree) { Pop-Location }
    git worktree remove --force $tree 2>$null | Out-Null
    Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
}

[pscustomobject]@{
    Branch    = $Branch
    Demos     = $demos.Count
    Banner    = -not $NoBanner
    OnMain    = $false
    Pushed    = $false
    Committed = (git log -1 --format='%h %s' $Branch)
}

''
'The branch exists locally and has NOT been pushed. Two deliberate steps remain, and neither is'
'this script''s to take:'
"  git push -u origin $Branch"
"  switch GitHub Pages on and point it at '$Branch'"
''
'Then paste this into README.md — it is rendered here rather than written so that putting ten'
'scored run ids on the public front page stays a decision somebody makes:'
''
$readme
