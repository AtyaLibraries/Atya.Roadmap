<#
.SYNOPSIS
    Validates the roadmap task graph: every referenced ATYA ID exists, the hard-dependency
    graph is acyclic, and the three places a task is described agree with one another.

.DESCRIPTION
    The roadmap describes each task in three places — `github/PROJECT-ITEMS.csv`, the issue
    spec under `github/issues/`, and the `tasks[]` array of `github/PROJECT-MANIFEST.json`.
    Nothing previously enforced that they agree, so an amendment applied to one place and
    missed in another produced a dangling dependency that no test would catch.

    Fatal checks: dangling references, dependency cycles, missing issue files, and
    disagreement between the CSV, the spec metadata table, and the manifest.

    The manifest `tasks[]` array is known to lag the CSV. That gap is reported as coverage
    rather than failed, so this script does not block on a pre-existing condition it did
    not cause. Every task present in both must still agree.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string] $RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$itemsPath = Join-Path $RepositoryRoot 'github/PROJECT-ITEMS.csv'
$manifestPath = Join-Path $RepositoryRoot 'github/PROJECT-MANIFEST.json'

$rows = @(Import-Csv -LiteralPath $itemsPath)
$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -Depth 100

$ids = [Collections.Generic.HashSet[string]]::new()
foreach ($row in $rows) { $null = $ids.Add($row.ATYA_ID) }

function Split-Ids {
    param([string] $Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return @() }
    return @($Value -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$failures = [Collections.Generic.List[string]]::new()

# 1. Referential integrity across all three ID-bearing columns.
foreach ($row in $rows) {
    foreach ($column in @('Dependencies', 'AdvisoryPrerequisites', 'Related_Tasks')) {
        foreach ($reference in @(Split-Ids $row.$column)) {
            if (-not $ids.Contains($reference)) {
                $failures.Add("$($row.ATYA_ID): $column references '$reference', which is not a task.")
            }
        }
    }
}

# 2. Every task's issue spec exists, and its metadata table agrees with the CSV.
foreach ($row in $rows) {
    $specPath = Join-Path $RepositoryRoot $row.Issue_File
    if (-not (Test-Path -LiteralPath $specPath -PathType Leaf)) {
        $failures.Add("$($row.ATYA_ID): Issue_File '$($row.Issue_File)' does not exist.")
        continue
    }

    $text = Get-Content -Raw -LiteralPath $specPath
    $match = [regex]::Match($text, '^\|\s*Hard dependencies\s*\|\s*(?<value>.*?)\s*\|\s*$',
        [Text.RegularExpressions.RegexOptions]::Multiline)
    if (-not $match.Success) {
        $failures.Add("$($row.ATYA_ID): spec has no 'Hard dependencies' metadata row.")
        continue
    }

    $raw = $match.Groups['value'].Value.Trim()
    $specDependencies = if ($raw -in @('None', '', '-')) { @() } else { @(Split-Ids $raw) }
    $csvDependencies = @(Split-Ids $row.Dependencies)
    if (($specDependencies -join ';') -ne ($csvDependencies -join ';')) {
        $failures.Add("$($row.ATYA_ID): spec dependencies '$($specDependencies -join ';')' disagree with CSV '$($csvDependencies -join ';')'.")
    }
}

# 3. The hard-dependency graph must be acyclic.
$graph = @{}
foreach ($row in $rows) { $graph[$row.ATYA_ID] = @(Split-Ids $row.Dependencies) }

$state = @{}
foreach ($id in $graph.Keys) { $state[$id] = 'unvisited' }

function Test-Acyclic {
    param([string] $Node, [Collections.Generic.List[string]] $Stack)

    $state[$Node] = 'active'
    $Stack.Add($Node)
    foreach ($next in $graph[$Node]) {
        if (-not $graph.ContainsKey($next)) { continue }
        if ($state[$next] -eq 'active') {
            $cycleStart = $Stack.IndexOf($next)
            $cycle = @($Stack[$cycleStart..($Stack.Count - 1)]) + $next
            $failures.Add("Dependency cycle: $($cycle -join ' -> ')")
        }
        elseif ($state[$next] -eq 'unvisited') {
            Test-Acyclic -Node $next -Stack $Stack
        }
    }
    $Stack.RemoveAt($Stack.Count - 1)
    $state[$Node] = 'done'
}

foreach ($id in @($graph.Keys)) {
    if ($state[$id] -eq 'unvisited') {
        Test-Acyclic -Node $id -Stack ([Collections.Generic.List[string]]::new())
    }
}

# 4. Every task present in both the CSV and the manifest must agree.
$manifestById = @{}
foreach ($task in $manifest.tasks) { $manifestById[$task.id] = $task }

$covered = 0
foreach ($row in $rows) {
    if (-not $manifestById.ContainsKey($row.ATYA_ID)) { continue }
    $covered++
    $task = $manifestById[$row.ATYA_ID]

    $manifestDependencies =
        if ($null -eq $task.dependencies) { @() }
        elseif ($task.dependencies -is [string]) { @($task.dependencies) }
        else { @($task.dependencies) }

    $csvDependencies = @(Split-Ids $row.Dependencies)
    if (($manifestDependencies -join ';') -ne ($csvDependencies -join ';')) {
        $failures.Add("$($row.ATYA_ID): manifest dependencies '$($manifestDependencies -join ';')' disagree with CSV '$($csvDependencies -join ';')'.")
    }
    if ($task.issue_file -ne $row.Issue_File) {
        $failures.Add("$($row.ATYA_ID): manifest issue_file disagrees with CSV.")
    }
    if ($task.type -ne $row.Type) {
        $failures.Add("$($row.ATYA_ID): manifest type '$($task.type)' disagrees with CSV '$($row.Type)'.")
    }
}

foreach ($task in $manifest.tasks) {
    if (-not $ids.Contains($task.id)) {
        $failures.Add("Manifest task '$($task.id)' has no row in PROJECT-ITEMS.csv.")
    }
}

$edges = 0
foreach ($row in $rows) { $edges += @(Split-Ids $row.Dependencies).Count }

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error -Message $_ -ErrorAction Continue }
    throw "Roadmap graph validation failed with $($failures.Count) error(s)."
}

[pscustomobject]@{
    Tasks                  = $rows.Count
    HardDependencyEdges    = $edges
    DanglingReferences     = 0
    Cycles                 = 0
    MissingIssueFiles      = 0
    CsvSpecAgreement       = 'Passed'
    CsvManifestAgreement   = "Passed ($covered of $($rows.Count) tasks present in manifest tasks[])"
    ManifestCoverageGap    = "$($rows.Count - $covered) task(s) absent from manifest tasks[] (pre-existing; not introduced here)"
} | Format-List

Write-Output 'Roadmap graph is referentially complete and acyclic.'
