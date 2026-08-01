<#
.SYNOPSIS
Reads the two indexes a hire can actually see out of MONSTER-DEV.md.

.DESCRIPTION
raw.githubusercontent.com serves no directory listing, so the playbook's own prose *is* the
index: §2 lists the stacks that exist, §5 lists the sheets. A stack or sheet missing from
those lists is unreachable however complete the filesystem is, and one listed but absent is a
dead pointer that costs a hire a turn on a 404.

Dot-source this from anything that needs to compare the lists against the filesystem —
build-dist.ps1 checks the mirror it just built, check-index.ps1 checks the working tree. One
parser, because a second copy is a second thing to forget.

Both functions key on the shape that has to stay stable for a hire anyway: §2 on the literal
fetch path, §5 on the backtick-quoted slug in the first table cell. That survives the §2
bullets-to-table rewrite, which changes the prose around the path but not the path.
#>

function Get-PlaybookStacks {
    param([Parameter(Mandatory)][string]$PlaybookPath)

    $text = Get-Content $PlaybookPath -Raw
    [regex]::Matches($text, 'stacks/([a-z0-9][a-z0-9-]*)/README\.md') |
        ForEach-Object { $_.Groups[1].Value } |
        Sort-Object -Unique
}

function Get-PlaybookSheets {
    param([Parameter(Mandatory)][string]$PlaybookPath)

    # Scope to §5 so a future table elsewhere in the playbook cannot be mistaken for the roster.
    $text    = Get-Content $PlaybookPath -Raw
    $section = [regex]::Match($text, '(?ms)^## 5\..*?(?=^## 6\.|\z)')
    if (-not $section.Success) { throw "BROKEN: no '## 5.' section in $PlaybookPath — the roster cannot be located." }

    [regex]::Matches($section.Value, '(?m)^\|\s*`([a-z0-9][a-z0-9-]*)`') |
        ForEach-Object { $_.Groups[1].Value } |
        Sort-Object -Unique
}

function Get-PlaybookSheetRows {
    <#
    The same §5 rows as Get-PlaybookSheets, but with the numbers a hire actually builds on.
    Separate function rather than a switch, because build-dist.ps1 only ever needs the slugs
    and should not have to know or care what a cell width looks like.

    Anything that fails to parse is returned with null figures rather than skipped: a row the
    roster shows and this cannot read is exactly the row worth shouting about.
    #>
    param([Parameter(Mandatory)][string]$PlaybookPath)

    $text    = Get-Content $PlaybookPath -Raw
    $section = [regex]::Match($text, '(?ms)^## 5\..*?(?=^## 6\.|\z)')
    if (-not $section.Success) { throw "BROKEN: no '## 5.' section in $PlaybookPath — the roster cannot be located." }

    foreach ($line in ($section.Value -split "`r?`n")) {
        $slug = [regex]::Match($line, '^\|\s*`([a-z0-9][a-z0-9-]*)`')
        if (-not $slug.Success) { continue }

        # × is U+00D7 in the table, not the letter x.
        $row = [regex]::Match($line, '^\|[^|]*\|[^|]*\|\s*(\d+)\s*\|\s*(\d+)\s*[×x]\s*(\d+)\s*\|\s*([\d.]+)\s*s\s*\|\s*([a-z]+)\s*\|')

        [pscustomobject]@{
            Slug   = $slug.Groups[1].Value
            Frames = if ($row.Success) { [int]$row.Groups[1].Value }    else { $null }
            CellW  = if ($row.Success) { [int]$row.Groups[2].Value }    else { $null }
            CellH  = if ($row.Success) { [int]$row.Groups[3].Value }    else { $null }
            Cycle  = if ($row.Success) { [double]$row.Groups[4].Value } else { $null }
            Faces  = if ($row.Success) { $row.Groups[5].Value }         else { $null }
            Parsed = $row.Success
        }
    }
}
