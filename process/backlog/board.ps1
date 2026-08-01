<#
.SYNOPSIS
Renders the backlog board from the item files themselves.

.DESCRIPTION
There is no index file. The board *is* the folder, and this script reads every `<nnn>-<slug>.md`
in it — so the two things that can normally drift apart, the items and the overview of them,
cannot. An item that exists is on the board; there is no second place to forget it.

Beyond rendering, it enforces the three rules that make the states mean something. Each of them
exists because the alternative is an item that looks tracked and is not:

  * `grilled` with `Gate: run` needs a proof design. The whole point of that state is that the
    thinking happened *before* a run was spent finding out there was nothing to measure.
  * `Gate: none` may not sit in `grilled` or `in-proof`. Those states are about proving something
    with a run, and a harness bug or a stale sentence has no run to spend.
  * `in-proof` needs a run id in `Proof design`. Otherwise it is `grilled` with a nicer label.

Also warns past 25 open items. Past that the board stops being readable in one pass, and an
unreadable board loses items exactly the way `15c` was lost — the failure it was built for.

Exits non-zero when a rule is broken, so it can gate a commit. Run it from the repository root
or from anywhere — paths are resolved relative to the script.

.PARAMETER State
Show only items in this state. Accepts a comma-separated list.

.PARAMETER Open
Everything that is not `proven` or `rejected`. The default reading for scoring a run.

.PARAMETER Full
Print each item's title line under the table, which is where the actual problem is stated. The
table's own title column is truncated to keep the columns aligned.

.EXAMPLE
.\process\backlog\board.ps1

.EXAMPLE
.\process\backlog\board.ps1 -Open -Full

.EXAMPLE
.\process\backlog\board.ps1 -State grilled
#>
[CmdletBinding()]
param(
    [string[]]$State,
    [switch]$Open,
    [switch]$Full
)

$ErrorActionPreference = 'Stop'

$STATES     = @('intake', 'formulated', 'grilled', 'in-proof', 'proven', 'rejected')
$CLOSED     = @('proven', 'rejected')
$OPEN_LIMIT = 25

$items    = @()
$failures = @()

foreach ($file in (Get-ChildItem $PSScriptRoot -Filter '*.md' | Where-Object { $_.Name -match '^\d{3}-' } | Sort-Object Name)) {
    $lines = @(Get-Content $file.FullName)

    # Title: `# \`#012\` — the problem`. The id is taken from the heading rather than the file
    # name so a renamed file with a stale heading is caught instead of silently disagreeing.
    $title = ($lines | Where-Object { $_ -match '^#\s' } | Select-Object -First 1)
    $id    = if ($title -match '#(\d{3})') { $Matches[1] } else { $null }
    $text  = ($title -replace '^#\s*', '' -replace '`#\d{3}`', '' -replace '^\s*[—-]\s*', '').Trim()

    if (-not $id) {
        $failures += "$($file.Name): heading does not carry an id — expected '# ``#<nnn>`` — ...'"
        continue
    }
    if ($id -ne $file.Name.Substring(0, 3)) {
        $failures += "$($file.Name): heading says #$id — the file name and the heading must agree"
    }

    $fields = @{}
    foreach ($line in $lines) {
        if ($line -match '^\|\s*([A-Za-z][^|]*?)\s*\|\s*(.*?)\s*\|\s*$') {
            $fields[$Matches[1]] = ($Matches[2] -replace '`', '').Trim()
        }
    }

    $item = [pscustomobject]@{
        Id          = $id
        File        = $file.Name
        Title       = $text
        Status      = $fields['Status']
        Gate        = $fields['Gate']
        Attribution = $fields['Attribution']
        Criterion   = $fields['Criterion']
        Target      = $fields['Target file']
        Evidence    = $fields['Evidence']
        Proof       = $fields['Proof design']
    }

    if ($item.Status -notin $STATES) {
        $failures += "#${id}: status '$($item.Status)' is not one of $($STATES -join ', ')"
    }
    if ($item.Gate -notin @('run', 'none')) {
        $failures += "#${id}: gate '$($item.Gate)' is neither 'run' nor 'none'"
    }
    if ($item.Status -ne 'intake' -and -not $item.Attribution) {
        $failures += "#${id}: '$($item.Status)' without an attribution — nothing advances past intake without one"
    }
    if ($item.Gate -eq 'run' -and $item.Status -in @('grilled', 'in-proof') -and $item.Proof -in @('', '—', $null)) {
        $failures += "#${id}: '$($item.Status)' with no proof design — that state exists to stop a run being spent finding out there was nothing to measure"
    }
    if ($item.Gate -eq 'none' -and $item.Status -in @('grilled', 'in-proof')) {
        $failures += "#${id}: 'Gate: none' cannot be '$($item.Status)' — there is no run to spend, so it goes straight to proven when applied"
    }
    if ($item.Status -eq 'in-proof' -and $item.Proof -notmatch '\d{4}-\d{2}-\d{2}') {
        $failures += "#${id}: 'in-proof' without a run id in 'Proof design'"
    }
    if (-not $item.Evidence) {
        $failures += "#${id}: no evidence — an item with no run behind it is a hunch"
    }

    $items += $item
}

# --- filter ---------------------------------------------------------------------------------

$shown = $items
if ($Open)  { $shown = $shown | Where-Object { $_.Status -notin $CLOSED } }
if ($State) { $shown = $shown | Where-Object { $_.Status -in $State } }

$order = @{}
for ($i = 0; $i -lt $STATES.Count; $i++) { $order[$STATES[$i]] = $i }
$shown = $shown | Sort-Object @{ Expression = { $order[$_.Status] } }, Id

# --- render ---------------------------------------------------------------------------------

if (-not $shown) {
    if ($items) { "no items match — $($items.Count) on the board" } else { "the board is empty" }
} else {
    $shown | Format-Table -AutoSize @(
        @{ Label = '#';         Expression = { $_.Id } }
        @{ Label = 'Status';    Expression = { $_.Status } }
        @{ Label = 'Gate';      Expression = { $_.Gate } }
        @{ Label = 'Attribution'; Expression = { $_.Attribution } }
        @{ Label = 'Crit';      Expression = { $_.Criterion } }
        @{ Label = 'Evidence';  Expression = { $_.Evidence } }
        @{ Label = 'Problem';   Expression = { if ($_.Title.Length -gt 52) { $_.Title.Substring(0, 51) + '…' } else { $_.Title } } }
    ) | Out-String -Width 200

    if ($Full) {
        foreach ($i in $shown) {
            "  #$($i.Id)  $($i.Title)"
            "        $($i.File) → $($i.Target)"
        }
        ''
    }
}

$openCount = @($items | Where-Object { $_.Status -notin $CLOSED }).Count
$byState = ($STATES | ForEach-Object {
    $s = $_
    $n = @($items | Where-Object { $_.Status -eq $s }).Count
    if ($n) { "$s $n" }
}) -join ' · '

"$($items.Count) item(s) — $byState"

if ($openCount -gt $OPEN_LIMIT) {
    Write-Warning "$openCount open items (limit $OPEN_LIMIT). Past this the board stops being readable in one pass, which is how a finding gets lost — close or reject before filing more."
}

if ($failures) {
    ''
    $failures | ForEach-Object { "FAIL  $_" }
    ''
    throw "$($failures.Count) board problem(s)."
}
