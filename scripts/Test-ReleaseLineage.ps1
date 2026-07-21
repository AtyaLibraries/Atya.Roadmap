[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('ReleaseTime', 'Retrospective')]
    [string] $Mode,

    [Parameter(Mandatory)]
    [string] $RepositoryPath,

    [string] $DevelopmentRef = 'origin/development',
    [string] $ReleaseRef = 'origin/master',

    [Parameter(Mandatory)]
    [string] $StableTag,
    [string] $ExpectedSdk,
    [string] $ExpectedBuildSdk
)

$ErrorActionPreference = 'Stop'

function Assert-SafeGitRef([string] $Value, [string] $Name) {
    if ($Value.Length -gt 200 -or $Value -notmatch '^[A-Za-z0-9][A-Za-z0-9._/@+-]*$' -or $Value.Contains('..')) {
        throw "$Name is not a bounded Git ref."
    }
}

if (-not (Test-Path -LiteralPath $RepositoryPath -PathType Container)) {
    throw 'RepositoryPath must be an existing directory.'
}

$resolvedRepository = (Resolve-Path -LiteralPath $RepositoryPath).Path
Assert-SafeGitRef $DevelopmentRef 'DevelopmentRef'
Assert-SafeGitRef $ReleaseRef 'ReleaseRef'
Assert-SafeGitRef $StableTag 'StableTag'

function Invoke-Git([string[]] $Arguments, [switch] $AllowFailure) {
    $output = & git -C $resolvedRepository @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if (-not $AllowFailure -and $exitCode -ne 0) {
        throw "git $($Arguments -join ' ') failed: $output"
    }
    [pscustomobject]@{ ExitCode = $exitCode; Output = ($output -join "`n").Trim() }
}

$null = Invoke-Git @('rev-parse', '--git-dir')
$developmentTree = (Invoke-Git @('rev-parse', "$DevelopmentRef`^{tree}")).Output
$releaseTree = (Invoke-Git @('rev-parse', "$ReleaseRef`^{tree}")).Output
$treeParity = $developmentTree -eq $releaseTree

$tagCommit = (Invoke-Git @('rev-list', '-n', '1', $StableTag)).Output
$tagAncestor = (Invoke-Git @('merge-base', '--is-ancestor', $tagCommit, $DevelopmentRef) -AllowFailure).ExitCode -eq 0

$releasedPinsConform = $true
$pinDiagnostics = @()
$globalJson = (Invoke-Git @('show', "$ReleaseRef`:global.json") -AllowFailure)
if ($globalJson.ExitCode -eq 0) {
    $pins = $globalJson.Output | ConvertFrom-Json
    if ($ExpectedSdk -and $pins.sdk.version -ne $ExpectedSdk) {
        $releasedPinsConform = $false
        $pinDiagnostics += 'released SDK pin differs from the approved value'
    }
    $actualBuildSdk = $pins.'msbuild-sdks'.'Atya.Build.Sdk'
    if ($ExpectedBuildSdk -and $actualBuildSdk -ne $ExpectedBuildSdk) {
        $releasedPinsConform = $false
        $pinDiagnostics += 'released Build SDK pin differs from the approved value'
    }
} elseif ($ExpectedSdk -or $ExpectedBuildSdk) {
    $releasedPinsConform = $false
    $pinDiagnostics += 'released global.json is missing or unreadable'
}

$treeRequired = $Mode -eq 'ReleaseTime'
$passed = (-not $treeRequired -or $treeParity) -and $tagAncestor -and $releasedPinsConform
$result = [ordered]@{
    mode = $Mode
    passed = $passed
    treeParity = $treeParity
    treeParityRequired = $treeRequired
    stableTagPresent = $true
    stableTagAncestorOfDevelopment = $tagAncestor
    releasedPinsConform = $releasedPinsConform
    diagnostics = $pinDiagnostics
}

[pscustomobject]$result | ConvertTo-Json -Depth 3
if (-not $passed) { exit 1 }
