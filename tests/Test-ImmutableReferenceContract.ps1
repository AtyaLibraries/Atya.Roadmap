[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'scripts/Test-ImmutableReference.ps1'
$contractRoot = Join-Path $repositoryRoot 'github/contracts/atya-019'
$policyPath = Join-Path $contractRoot 'immutable-reference-policy.json'
$fixtureRoot = Join-Path $contractRoot 'fixtures'

function Assert-Equal {
    param([object] $Actual, [object] $Expected, [string] $Message)
    if ($Actual -ne $Expected) {
        throw "$Message Expected '$Expected', got '$Actual'."
    }
}

function Assert-True {
    param([bool] $Condition, [string] $Message)
    if (-not $Condition) {
        throw $Message
    }
}

# ---------------------------------------------------------------------------
# 1. Contract invariants
# ---------------------------------------------------------------------------

$policy = Get-Content -Raw -LiteralPath $policyPath | ConvertFrom-Json -Depth 100

Assert-Equal $policy.schemaVersion 1 'Policy schema version is unsupported.'
Assert-Equal $policy.task 'ATYA-019' 'Policy belongs to the wrong task.'
Assert-Equal $policy.evidenceCaveat 'CAVEAT-001' 'The standing evidence caveat reference changed.'
Assert-Equal $policy.evaluationUnit 'reference' 'Conformance must be decided per reference, never per file.'
Assert-Equal $policy.scope.firstPartyHeldToSameRule $true 'First-party references must be held to the same rule as third-party ones.'
Assert-Equal $policy.referenceKinds.'remote-reusable-workflow'.differsFromAction $false 'Reusable-workflow references must not diverge from action references.'
Assert-Equal $policy.referenceKinds.'remote-action'.immutableRefForm 'commit-sha-40-hex-lowercase' 'The immutable ref form changed.'
Assert-Equal $policy.referenceKinds.'remote-reusable-workflow'.versionCommentRequired $true 'The version comment must remain mandatory for reusable workflows.'
Assert-Equal $policy.referenceKinds.docker.immutableRefForm 'image-digest-sha256' 'The docker immutable form changed.'
Assert-Equal $policy.referenceKinds.local.verdict 'exempt' 'Local references must remain exempt by form.'

$ruleIds = @($policy.rules | ForEach-Object { $_.id })
foreach ($expectedRule in @('IR001', 'IR002', 'IR003', 'IR004', 'IR005')) {
    Assert-True ($ruleIds -contains $expectedRule) "Policy rule $expectedRule is missing."
}
Assert-Equal (($policy.rules | Where-Object id -eq 'IR001').severity) 'error' 'IR001 must remain an error.'
Assert-Equal (($policy.rules | Where-Object id -eq 'IR002').severity) 'error' 'IR002 must remain an error.'

# ATYA-019 defines the policy and grants no exceptions. Rollout tasks own any that follow.
Assert-Equal @($policy.exceptions.register).Count 0 'ATYA-019 must ship an empty exception register.'
Assert-Equal $policy.exceptions.approver 'aasulyan' 'The exception approver changed.'
Assert-True ($policy.exceptions.maximumDurationDays -le 90) 'Exceptions must remain time-boxed to at most 90 days.'
Assert-Equal $policy.exceptions.expiredExceptionBehaviour 'violation' 'An expired exception must revert to a violation.'

# The requirements that ATYA-124 and ATYA-028 are executed from must stay present.
$driftIds = @($policy.driftValidatorRequirements.requirements | ForEach-Object { $_.id })
foreach ($expectedRequirement in @('DV001', 'DV002', 'DV003', 'DV004', 'DV005', 'DV006', 'DV007', 'DV008')) {
    Assert-True ($driftIds -contains $expectedRequirement) "Drift validator requirement $expectedRequirement is missing."
}
$renovateIds = @($policy.renovate.requirements | ForEach-Object { $_.id })
foreach ($expectedRequirement in @('RN001', 'RN002', 'RN003', 'RN004')) {
    Assert-True ($renovateIds -contains $expectedRequirement) "Renovate requirement $expectedRequirement is missing."
}
Assert-Equal $policy.renovate.ownedBy 'ATYA-028' 'Renovate preset ownership changed.'
Assert-Equal $policy.driftValidatorRequirements.ownedBy 'ATYA-124' 'Drift validator ownership changed.'

# ---------------------------------------------------------------------------
# 2. Single-reference fixtures
# ---------------------------------------------------------------------------

function Get-SingleReferenceFixture {
    $items = @()
    foreach ($file in Get-ChildItem -File -Filter '*.json' -LiteralPath $fixtureRoot | Sort-Object Name) {
        $fixture = Get-Content -Raw -LiteralPath $file.FullName | ConvertFrom-Json -Depth 100
        if ($fixture.PSObject.Properties.Name -notcontains 'expected') {
            continue
        }
        $items += [pscustomobject]@{ Name = $file.Name; Fixture = $fixture }
    }
    return $items
}

function Invoke-Fixture {
    param(
        [Parameter(Mandatory)] $Fixture,
        [Parameter(Mandatory)] [string] $Policy
    )

    $arguments = @{
        Reference  = $Fixture.line
        PolicyPath = $Policy
    }
    if ($Fixture.PSObject.Properties.Name -contains 'exceptionRegister') {
        $arguments['ExceptionRegister'] = @($Fixture.exceptionRegister)
    }
    if ($Fixture.PSObject.Properties.Name -contains 'evaluationDate') {
        $arguments['EvaluationDate'] = [datetime]::Parse(
            $Fixture.evaluationDate, [Globalization.CultureInfo]::InvariantCulture)
    }

    return & $validator @arguments
}

$fixtures = @(Get-SingleReferenceFixture)
Assert-True ($fixtures.Count -ge 20) "Expected at least 20 single-reference fixtures, found $($fixtures.Count)."

$observedCount = 0
foreach ($item in $fixtures) {
    $fixture = $item.Fixture
    $actual = Invoke-Fixture -Fixture $fixture -Policy $policyPath

    Assert-Equal $actual.Verdict $fixture.expected.verdict "Fixture $($item.Name) produced the wrong verdict."
    Assert-Equal $actual.Kind $fixture.expected.kind "Fixture $($item.Name) produced the wrong reference kind."

    $expectedRule = if ($null -eq $fixture.expected.rule) { '' } else { [string] $fixture.expected.rule }
    $actualRule = if ($null -eq $actual.Rule) { '' } else { [string] $actual.Rule }
    Assert-Equal $actualRule $expectedRule "Fixture $($item.Name) cited the wrong rule."

    if ($fixture.provenance -like 'observed:*') {
        $observedCount++
    }
}

# The policy must be anchored in references that actually exist, not only invented ones.
Assert-True ($observedCount -ge 9) "Expected at least 9 fixtures drawn from observed references, found $observedCount."

# The two references named in the ATYA-019 work order must each receive a determinate verdict.
$nuGetLogin = & $validator -Reference '        uses: NuGet/login@v1' -PolicyPath $policyPath
Assert-Equal $nuGetLogin.Verdict 'violation' 'NuGet/login@v1 must be a violation.'
Assert-Equal $nuGetLogin.Rule 'IR001' 'NuGet/login@v1 must cite IR001.'

$githubScript = & $validator -Reference '        uses: actions/github-script@v7' -PolicyPath $policyPath
Assert-Equal $githubScript.Verdict 'violation' 'actions/github-script@v7 must be a violation.'
Assert-Equal $githubScript.Rule 'IR001' 'actions/github-script@v7 must cite IR001.'

# ---------------------------------------------------------------------------
# 3. Per-reference evaluation of a mixed file
# ---------------------------------------------------------------------------

$mixedExpectation = Get-Content -Raw -LiteralPath (Join-Path $fixtureRoot 'mixed-references.file-expectations.json') |
    ConvertFrom-Json -Depth 100
$mixedWorkflow = Join-Path $fixtureRoot $mixedExpectation.workflow
$mixedResults = @(& $validator -Path $mixedWorkflow -PolicyPath $policyPath -NoFail)

Assert-Equal $mixedResults.Count $mixedExpectation.fileExpectations.total 'The mixed fixture yielded the wrong reference count.'
Assert-Equal @($mixedResults | Where-Object Verdict -eq 'conformant').Count $mixedExpectation.fileExpectations.conformant 'Wrong conformant count in the mixed fixture.'
Assert-Equal @($mixedResults | Where-Object Verdict -eq 'violation').Count $mixedExpectation.fileExpectations.violations 'Wrong violation count in the mixed fixture.'
Assert-Equal @($mixedResults | Where-Object Verdict -eq 'exempt-by-form').Count $mixedExpectation.fileExpectations.exemptByForm 'Wrong exempt-by-form count in the mixed fixture.'

$expectedReferences = @($mixedExpectation.fileExpectations.references)
for ($index = 0; $index -lt $expectedReferences.Count; $index++) {
    $expected = $expectedReferences[$index]
    $actual = $mixedResults[$index]
    Assert-Equal $actual.Line $expected.line "Mixed fixture reference $index reported the wrong line."
    Assert-Equal $actual.Verdict $expected.verdict "Mixed fixture line $($expected.line) produced the wrong verdict."
    Assert-Equal $actual.Kind $expected.kind "Mixed fixture line $($expected.line) produced the wrong kind."

    $expectedRule = if ($null -eq $expected.rule) { '' } else { [string] $expected.rule }
    $actualRule = if ($null -eq $actual.Rule) { '' } else { [string] $actual.Rule }
    Assert-Equal $actualRule $expectedRule "Mixed fixture line $($expected.line) cited the wrong rule."
}

# A file-level verdict is insufficient: this one file is simultaneously conformant and not.
Assert-True (
    @($mixedResults | Where-Object Verdict -eq 'conformant').Count -gt 0 -and
    @($mixedResults | Where-Object Verdict -eq 'violation').Count -gt 0
) 'The mixed fixture must contain both conformant and non-conformant references.'

# ---------------------------------------------------------------------------
# 4. Exit-code behaviour of the scanning entry point
# ---------------------------------------------------------------------------

$pwshPath = Join-Path $PSHOME 'pwsh.exe'
if (-not (Test-Path -LiteralPath $pwshPath)) {
    $pwshPath = Join-Path $PSHOME 'pwsh'
}

& $pwshPath -NoProfile -File $validator -Path $mixedWorkflow -PolicyPath $policyPath | Out-Null
Assert-Equal $LASTEXITCODE 1 'Scanning a file containing violations must exit non-zero.'

$cleanRoot = Join-Path ([IO.Path]::GetTempPath()) "atya-019-clean-$([guid]::NewGuid().ToString('N'))"
try {
    New-Item -ItemType Directory -Path $cleanRoot | Out-Null
    $cleanLines = @(
        'jobs:',
        '  build:',
        '    steps:',
        '      - uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10 # v6.0.3'
    )
    Set-Content -LiteralPath (Join-Path $cleanRoot 'clean.yml') -Value $cleanLines -Encoding utf8NoBOM
    & $pwshPath -NoProfile -File $validator -Path $cleanRoot -PolicyPath $policyPath | Out-Null
    Assert-Equal $LASTEXITCODE 0 'Scanning a conformant file must exit zero.'
}
finally {
    Remove-Item -LiteralPath $cleanRoot -Recurse -Force -ErrorAction SilentlyContinue
}

# ---------------------------------------------------------------------------
# 5. Negative mutation tests
#
# Each mutation weakens the policy. The suite must notice. Without these, a future
# change could relax the contract and every fixture would still pass.
# ---------------------------------------------------------------------------

function Assert-RejectedPolicyMutation {
    param(
        [Parameter(Mandatory)] [scriptblock] $Mutate,
        [Parameter(Mandatory)] [string] $Name
    )

    $temporaryPath = Join-Path ([IO.Path]::GetTempPath()) "atya-019-$([guid]::NewGuid().ToString('N')).json"
    try {
        $mutated = Get-Content -Raw -LiteralPath $policyPath | ConvertFrom-Json -Depth 100
        & $Mutate $mutated
        $mutated | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $temporaryPath -Encoding utf8NoBOM

        $divergences = 0
        foreach ($item in $fixtures) {
            $fixture = $item.Fixture
            try {
                $actual = Invoke-Fixture -Fixture $fixture -Policy $temporaryPath
            }
            catch {
                $divergences++
                continue
            }
            $expectedRule = if ($null -eq $fixture.expected.rule) { '' } else { [string] $fixture.expected.rule }
            $actualRule = if ($null -eq $actual.Rule) { '' } else { [string] $actual.Rule }
            if ($actual.Verdict -ne $fixture.expected.verdict -or $actualRule -ne $expectedRule) {
                $divergences++
            }
        }

        if ($divergences -eq 0) {
            throw "Policy mutation '$Name' changed nothing observable. The fixtures do not actually constrain this part of the policy."
        }
    }
    finally {
        Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
    }
}

Assert-RejectedPolicyMutation -Name 'accept abbreviated SHAs' -Mutate {
    param($mutated)
    $mutated.patterns.commitSha = '^[0-9a-f]{7,40}$'
}

Assert-RejectedPolicyMutation -Name 'accept uppercase SHAs' -Mutate {
    param($mutated)
    $mutated.patterns.commitSha = '^[0-9a-fA-F]{40}$'
}

Assert-RejectedPolicyMutation -Name 'accept any trailing comment as a version' -Mutate {
    param($mutated)
    $mutated.patterns.versionComment = '^.*$'
}

Assert-RejectedPolicyMutation -Name 'accept mutable docker tags' -Mutate {
    param($mutated)
    $mutated.patterns.imageDigest = '^.*$'
}

Assert-RejectedPolicyMutation -Name 'treat unclassifiable references as remote actions' -Mutate {
    param($mutated)
    $mutated.patterns.remoteReference = '^(?<owner>[^/]+)/(?<repo>[^/@]+)(?<path>/[^@]*)?@?(?<ref>.*)$'
}

# An exception must not be honoured unless it is complete.
$incompleteRegister = @([pscustomobject]@{
        reference = 'NuGet/login@v1'
        reason    = 'incomplete entry'
        approver  = 'aasulyan'
    })
$incompleteRejected = $false
try {
    & $validator -Reference '        uses: NuGet/login@v1' -PolicyPath $policyPath -ExceptionRegister $incompleteRegister | Out-Null
}
catch {
    $incompleteRejected = $true
}
Assert-True $incompleteRejected 'An exception register entry missing required fields must be rejected.'

[pscustomobject]@{
    Task                 = 'ATYA-019'
    PolicyContract       = 'Passed'
    SingleReferenceCases = "Passed ($($fixtures.Count))"
    ObservedProvenance   = "Passed ($observedCount drawn from live references)"
    MixedFileEvaluation  = 'Passed'
    ExitCodeBehaviour    = 'Passed'
    PolicyMutations      = 'Passed (5)'
    ExceptionIntegrity   = 'Passed'
} | Format-List

Write-Output 'ATYA-019 immutable reference policy contract and all negative mutation tests passed.'
