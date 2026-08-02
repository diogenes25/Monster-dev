<#
.SYNOPSIS
Rewrites a Claude CLI transcript so it can be committed to a public repository.

.DESCRIPTION
`process/` is tracked and this repository is pushed, so anything captured into `process/runs/`
is world-readable. Raw, the ten transcripts on record are 11.8 MB and contain the machine
owner's name 2,864 times — in `cwd`, in briefs, in tool output. One line inside a *hire*
transcript reads "Shell cwd was reset to c:\Users\<name>\source\repos\priv\MonsterLib".

Two things happen here and nothing else:

  1. Absolute paths are rewritten to <dist>, <run>, <repo> and <home>, longest prefix first.
     Windows (escaped and unescaped), forward-slash and Git-Bash forms are all covered, plus
     the CLI's own project-folder slug, which encodes the same path with dashes.
  2. The CLI's bookkeeping records are dropped: queue-operation, ai-title, last-prompt, mode.
     The brief appears in both a queue-operation and a user record, so nothing is lost.
     user, assistant, attachment and file-history-* are kept.

Distilling to the assistant records alone was considered and rejected: they are 14.5 % of the
bytes and hold the prose, but *what the hire read, and in what order* sits in the tool results.

The result is not byte-faithful. That is the right trade for an archive people read, and it is
also why this fails loudly: a scrubber that passes one surviving absolute path through is worse
than none, because nothing downstream will look again.

.PARAMETER In
The raw transcript, ~/.claude/projects/<slug>/<session-id>.jsonl.

.PARAMETER Out
Where the scrubbed copy goes. Overwritten.

.PARAMETER Run
The run folder the hire worked in. Rewritten to <run>.

.PARAMETER Dist
The mirror handed over with --add-dir. Rewritten to <dist>. Replaced before -Run, because
<run-id> is a prefix of <run-id>.dist and the other order would swallow it.

.PARAMETER RepoRoot
This repository. Defaults to the current directory. Rewritten to <repo>.

.PARAMETER UserHome
Defaults to $HOME. Rewritten to <home>, and its leaf is the name the final check looks for.

.EXAMPLE
.\process\tools\scrub-transcript.ps1 -In $t -Out process\runs\2026-08-02-x\transcript.jsonl `
  -Run ..\monster-dev-testruns\2026-08-02-x\target -Dist ..\monster-dev-testruns\2026-08-02-x\dist
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$In,
    [Parameter(Mandatory)][string]$Out,
    [string]$Run,
    [string]$Dist,
    [string]$RepoRoot = (Get-Location).Path,
    [string]$UserHome = $HOME
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $In)) { throw "BROKEN: no transcript at $In" }

$DROP = @('queue-operation', 'ai-title', 'last-prompt', 'mode')

# Every way one path can be written into a JSONL line. The CLI stores `cwd` as JSON-escaped
# Windows; Bash tool calls carry the forward-slash and /c/... forms; and the project folder the
# transcript lives in is the same path again with every separator turned into a dash.
function Get-PathForms([string]$p) {
    $p = $p.TrimEnd('\', '/')
    $bs = $p -replace '/', '\'
    $fs = $p -replace '\\', '/'
    @(
        # Doubly escaped: a JSON string holding a JS source line holding a Windows path. Real —
        # `plan-sonnet`'s hire wrote a verifier with `const TARGET = 'C:\\\\Users\\\\…'` in it.
        ($bs -replace '\\', '\\\\')
        # JSON-escaped, the common case. The replacement is two literal backslashes: .NET does
        # not treat backslash as an escape on the replacement side, so four here would emit four.
        ($bs -replace '\\', '\\')
        $bs
        $fs
        ('/' + ($fs -replace '^([A-Za-z]):', '$1'))       # /c/Users/... as Git-Bash writes it
        ($bs -replace '[\\:]', '-')                       # C--Users-...-run-id, the CLI's slug
    ) | Sort-Object { $_.Length } -Descending | Select-Object -Unique
}

# Longest prefix first, and -Dist before -Run: <run-id> is a prefix of <run-id>.dist, so the
# other order rewrites the mirror as "<run>.dist" and hides which of the two a line was about.
$rules = [ordered]@{}

# The 8.3 short form of the home directory, C:\Users\TJARKO~1. It is not cosmetic: the CLI's own
# scratchpad, temp files and bundled-skill paths are all written that way, and it appears in
# eight of the eleven transcripts on record. Nothing derives it from the long form, so it is
# asked for.
$shortHome = $null
try {
    $fso = New-Object -ComObject Scripting.FileSystemObject
    $shortHome = $fso.GetFolder($UserHome).ShortPath
    if ($shortHome -eq $UserHome) { $shortHome = $null }
} catch { $shortHome = $null }

foreach ($pair in @(
        @{ Path = $Dist;      Token = '<dist>' },
        @{ Path = $Run;       Token = '<run>'  },
        @{ Path = $RepoRoot;  Token = '<repo>' },
        @{ Path = $UserHome;  Token = '<home>' },
        @{ Path = $shortHome; Token = '<home>' })) {
    if (-not $pair.Path) { continue }
    $full = if (Test-Path $pair.Path) { (Resolve-Path $pair.Path).Path } else { $pair.Path }
    foreach ($form in Get-PathForms $full) { if (-not $rules.Contains($form)) { $rules[$form] = $pair.Token } }
}

# The account name is not only in paths. `ls -la` inside a run folder prints it as the file
# *owner* — "drwxr-xr-x 1 AzureAD+<name> 4096 …" — and it is in the output of nine of the eleven
# transcripts on record. No path rule reaches that, so the name is a rule of its own, domain
# form first because it is the longer match.
$account = Split-Path $UserHome -Leaf
if ($env:USERDOMAIN) { $rules["$($env:USERDOMAIN)+$account"] = '<user>' }
$rules[$account] = '<user>'

$kept = 0
$dropped = @{}
$lines = [System.Collections.Generic.List[string]]::new()

foreach ($line in [System.IO.File]::ReadLines((Resolve-Path $In).Path)) {
    if (-not $line.Trim()) { continue }

    # Parsed to read the type, emitted as the original text. Re-serialising a record would
    # reorder and reformat it, which is a change this script has no reason to make.
    try { $type = ($line | ConvertFrom-Json).type } catch { $type = 'UNPARSEABLE' }
    if ($DROP -contains $type) { $dropped[$type] = 1 + [int]$dropped[$type]; continue }

    $scrubbed = $line
    foreach ($form in $rules.Keys) { $scrubbed = $scrubbed -replace [regex]::Escape($form), $rules[$form] }
    $lines.Add($scrubbed)
    $kept++
}

# The check that can still fail, and it is deliberately not "did the account name survive" —
# the rule above replaces that unconditionally, so asking afterwards would always answer no.
# What it asks instead is whether **any** home directory is still named: the 8.3 short form
# (C:\Users\TJARKO~1, which this machine's own temp paths use and which no rule above matches),
# a second account, or a path form the rules do not know. The fix for a hit is a new rule with
# a reason, never a wider catch-all — a catch-all is how this check stops being able to fail.
$LEFTOVER = '(?i)users[\\/]{1,4}[a-z0-9._~-]'
$survivors = @()
for ($i = 0; $i -lt $lines.Count -and $survivors.Count -lt 5; $i++) {
    $m = [regex]::Match($lines[$i], $LEFTOVER)
    if ($m.Success) {
        $from = [math]::Max(0, $m.Index - 60)
        $survivors += "  line $($i + 1): …$($lines[$i].Substring($from, [math]::Min(160, $lines[$i].Length - $from)))…"
    }
}
if ($survivors) {
    throw ("BROKEN: a home directory survived the rewrite in $($survivors.Count)+ line(s), so " +
           "this transcript is not publishable. Nothing was written.`n" + ($survivors -join "`n"))
}

New-Item -ItemType Directory -Force (Split-Path $Out) | Out-Null
Set-Content -LiteralPath $Out -Value $lines -Encoding utf8

[pscustomobject]@{
    In           = (Resolve-Path $In).Path
    Out          = (Resolve-Path $Out).Path
    RecordsKept  = $kept
    Dropped      = ($DROP | ForEach-Object { "$_=$([int]$dropped[$_])" }) -join ' '
    Rules        = $rules.Count
    Bytes        = (Get-Item $Out).Length
}
