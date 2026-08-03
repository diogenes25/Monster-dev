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

.PARAMETER Rebuild
Discard an existing local $Branch and build it again from nothing. Required to republish: the
branch is orphan and rebuilt from scratch every time, so a second run necessarily throws the
first one away, and doing that silently is not this script's decision to make. Without it, an
existing branch is a refusal that names the choice.

.PARAMETER WhatIf
Render and report, touch no branch. Use this first.

.EXAMPLE
.\process\tools\publish-demos.ps1 -WhatIf

.EXAMPLE
.\process\tools\publish-demos.ps1

.EXAMPLE
.\process\tools\publish-demos.ps1 -Rebuild
#>
[CmdletBinding()]
param(
    [string]$Branch = 'gh-pages',
    [switch]$NoBanner,
    [switch]$Rebuild,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

# Every git call that must succeed goes through here, which before #033 not one of them did.
# `git checkout --orphan` exits 128 once the branch exists; unguarded, that failure was invisible.
# The script carried on, committed to the worktree's detached HEAD, discarded that commit with
# `git worktree remove --force`, and then printed `Demos = 10` and the tip of the *stale* branch.
# Reproduced 2026-08-03 against the branch built on 2026-08-02: same tip before and after, exit 0,
# full success report. A publish step that silently does nothing and says it worked is the same
# failure class as an instrument that reports success while broken, which is why this is a helper
# and not four inline `if ($LASTEXITCODE)` blocks somebody can forget to add a fifth of.
#
# $ErrorActionPreference = 'Stop' does not cover this: a native command's non-zero exit is not a
# PowerShell error, and 2>&1 here is what keeps git's own diagnosis in the thrown message.
#
# Called with one array argument — Invoke-Git @('branch','-D',$Branch) — and never with loose
# words. ValueFromRemainingArguments looks like the natural signature and is a trap of exactly the
# kind #032 collected: PowerShell binds a leading-dash token to a *parameter name* before it ever
# reaches the remaining-arguments collector, so `Invoke-Git branch -D $Branch` silently ran
# `git branch gh-pages` with the -D dropped, and created the branch instead of deleting it.
# Caught on 2026-08-03 by this function's own exit-code check, on the first run of the fix.
function Invoke-Git {
    param([Parameter(Position = 0, Mandatory)][string[]]$Arguments)
    $global:LASTEXITCODE = 0
    $out = & git @Arguments 2>&1
    if ($LASTEXITCODE) {
        throw "BROKEN: git $($Arguments -join ' ') exited $LASTEXITCODE`n$($out -join "`n")"
    }
    $out
}

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
        # The *instance* Replace is the one with a count overload. The static
        # [regex]::Replace(input, pattern, replacement, 1) has none — the 1 binds to
        # RegexOptions.IgnoreCase and every <body> gets a banner.
        $patched = [regex]::new('(<body[^>]*>)').Replace($html, "`$1`n$banner", 1)
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
#
# Rebuilt from nothing is exactly why an existing branch has to be a decision. Asked with
# rev-parse rather than discovered by letting the checkout fail, so the answer is in hand before
# anything is destroyed and the refusal can name the two ways out. Bare `git` and not Invoke-Git:
# exit 1 here means "no such ref", which is the ordinary answer and not a failure.
$tipBefore = (git rev-parse --verify --quiet "refs/heads/$Branch")
if ($tipBefore -and -not $Rebuild) {
    throw ("Branch '$Branch' already exists, at $(git log -1 --format='%h %s' $Branch).`n" +
           "Republishing rebuilds it from nothing, which discards that commit. Re-run with " +
           "-Rebuild to do it, or 'git branch -D $Branch' yourself first. Refusing rather than " +
           "rebuilding silently — and refusing out loud rather than doing nothing quietly, " +
           "which is what this script did until #033.")
}

$tree = Join-Path ([System.IO.Path]::GetTempPath()) "monster-dev-pages-wt-$PID"
if (Test-Path $tree) { Remove-Item -Recurse -Force $tree }

# Deleted before the worktree is created, so a branch that is checked out somewhere else fails
# here — cheaply and with nothing half-built — rather than partway through the rebuild.
if ($tipBefore) { Invoke-Git @('branch', '-D', $Branch) | Out-Null }

Invoke-Git @('worktree', 'add', '--detach', '-q', $tree) | Out-Null
try {
    Push-Location $tree
    Invoke-Git @('checkout', '-q', '--orphan', $Branch) | Out-Null
    # The one git call here left unchecked, deliberately: an orphan checkout with nothing staged
    # has nothing to unstage, and `git rm` calls that empty pathspec a fatal error. Its failure
    # is harmless because the line below removes the files anyway.
    git rm -rq --cached . 2>$null | Out-Null
    Get-ChildItem . -Force | Where-Object { $_.Name -ne '.git' } | Remove-Item -Recurse -Force
    Copy-Item -Recurse (Join-Path $staging '*') .
    # Pages runs Jekyll otherwise, which silently drops anything starting with an underscore.
    New-Item -ItemType File -Force '.nojekyll' | Out-Null
    Invoke-Git @('add', '-A') | Out-Null
    Invoke-Git @('commit', '-qm', "Publish $($demos.Count) results as runnable demos") | Out-Null
    Pop-Location
} finally {
    if ((Get-Location).Path -eq $tree) { Pop-Location }
    git worktree remove --force $tree 2>$null | Out-Null
    Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
}

# The post-condition, because reporting a tip it had not written is precisely what this script
# did. Checking the calls is not the same as checking the outcome: #032's fifth defect was found
# by running the repaired code and reading what it printed, and this is that lesson wired in so
# it does not depend on somebody reading.
$tipAfter = (git rev-parse --verify --quiet "refs/heads/$Branch")
if (-not $tipAfter) {
    throw "BROKEN: '$Branch' does not exist after publishing — nothing was written."
}
if ($tipBefore -and $tipAfter -eq $tipBefore) {
    throw "BROKEN: '$Branch' still points at $tipBefore — the rebuild committed nothing."
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
