[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'scripts/Test-GitHubAppDispatch.ps1'
$scopeValidator = Join-Path $repositoryRoot 'scripts/Test-GitHubAppDeploymentScope.ps1'
$registrationPath = Join-Path $repositoryRoot 'github/contracts/atya-024/github-app-registration.json'
$scopeFixturePath = Join-Path $repositoryRoot 'github/contracts/atya-024/fixtures/deployment-scope.valid.json'

& $validator -RepositoryRoot $repositoryRoot | Out-Null
& $scopeValidator -EvidencePath $scopeFixturePath | Out-Null

function Assert-RejectedMutation {
    param(
        [Parameter(Mandatory)]
        [scriptblock] $Mutate,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $temporaryPath = Join-Path ([IO.Path]::GetTempPath()) "atya-024-$([guid]::NewGuid().ToString('N')).json"
    try {
        $registration = Get-Content -Raw -LiteralPath $registrationPath | ConvertFrom-Json -Depth 100
        & $Mutate $registration
        $registration | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $temporaryPath -Encoding utf8NoBOM
        $rejected = $false
        try {
            & $validator -RepositoryRoot $repositoryRoot -RegistrationPath $temporaryPath -SkipSanitization | Out-Null
        }
        catch {
            $rejected = $true
        }
        if (-not $rejected) {
            throw "Negative case '$Name' was accepted."
        }
    }
    finally {
        Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
    }
}

Assert-RejectedMutation -Name 'organization-wide installation' -Mutate {
    param($registration)
    $registration.installation.repositorySelection = 'all'
}

Assert-RejectedMutation -Name 'source repository installation' -Mutate {
    param($registration)
    $registration.installation.repositoryCount = 29
}

Assert-RejectedMutation -Name 'Actions secret key placement' -Mutate {
    param($registration)
    $registration.credentials.privateKey.githubActionsSecret = $true
}

Assert-RejectedMutation -Name 'additional permission' -Mutate {
    param($registration)
    $registration.permissions.repository | Add-Member -NotePropertyName actions -NotePropertyValue write
}

Assert-RejectedMutation -Name 'weakened contents permission' -Mutate {
    param($registration)
    $registration.permissions.repository.contents = 'read'
}

$temporaryScopePath = Join-Path ([IO.Path]::GetTempPath()) "atya-024-scope-$([guid]::NewGuid().ToString('N')).json"
try {
    $scope = Get-Content -Raw -LiteralPath $scopeFixturePath | ConvertFrom-Json -Depth 100
    $scope.installation.repositories += [pscustomobject]@{ id = '3002'; role = 'source' }
    $scope | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $temporaryScopePath -Encoding utf8NoBOM
    $scopeRejected = $false
    try {
        & $scopeValidator -EvidencePath $temporaryScopePath | Out-Null
    }
    catch {
        $scopeRejected = $true
    }
    if (-not $scopeRejected) {
        throw 'Negative deployment-scope case was accepted.'
    }
}
finally {
    Remove-Item -LiteralPath $temporaryScopePath -Force -ErrorAction SilentlyContinue
}

function Assert-SanitizationCase {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Content,

        [Parameter(Mandatory)]
        [bool] $ExpectedAccepted,

        [Parameter()]
        [string] $ExpectedRule = 'audit_run_identifier'
    )

    $temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) "atya-024-sanitization-$([guid]::NewGuid().ToString('N'))"
    try {
        New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
        Set-Content -LiteralPath (Join-Path $temporaryRoot 'case.md') -Value $Content -Encoding utf8NoBOM
        $accepted = $true
        $rejectionMessage = $null
        try {
            & $validator -RepositoryRoot $repositoryRoot -SanitizationRoot $temporaryRoot | Out-Null
        }
        catch {
            $accepted = $false
            $rejectionMessage = $_.Exception.Message
        }
        if ($accepted -ne $ExpectedAccepted) {
            throw "Sanitization case '$Name' produced accepted=$accepted; expected accepted=$ExpectedAccepted."
        }
        if (-not $ExpectedAccepted) {
            $expectedMessage = "Sanitization failure '$ExpectedRule' in 'case.md'."
            if ($rejectionMessage -cne $expectedMessage) {
                throw "Sanitization case '$Name' produced an unexpected rejection message."
            }
        }
    }
    finally {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$runWord = 'r' + 'un'
$jobWord = 'j' + 'ob'
$runId = '12345678'
$jobId = '87654321'

Assert-SanitizationCase -Name 'canonical run link' -ExpectedAccepted $true -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions/runs/$runId)"
Assert-SanitizationCase -Name 'canonical job link' -ExpectedAccepted $true -Content "[CI $jobWord $jobId](https://github.com/AtyaLibraries/Example/actions/runs/$runId/job/$jobId)"
Assert-SanitizationCase -Name 'bare run identifier' -ExpectedAccepted $false -Content "CI $runWord $runId failed."
Assert-SanitizationCase -Name 'bare job identifier' -ExpectedAccepted $false -Content "CI $jobWord $jobId failed."
Assert-SanitizationCase -Name 'mismatched visible identifier' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions/runs/99999999)"
Assert-SanitizationCase -Name 'other owner' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/OtherOwner/Example/actions/runs/$runId)"
Assert-SanitizationCase -Name 'lookalike domain' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com.evil.example/AtyaLibraries/Example/actions/runs/$runId)"
Assert-SanitizationCase -Name 'insecure scheme' -ExpectedAccepted $false -Content "[CI $runWord $runId](http://github.com/AtyaLibraries/Example/actions/runs/$runId)"
Assert-SanitizationCase -Name 'userinfo authority' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://attacker@github.com/AtyaLibraries/Example/actions/runs/$runId)"
Assert-SanitizationCase -Name 'encoded path' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions%2Fruns%2F$runId)"
Assert-SanitizationCase -Name 'traversal path' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions/runs/../runs/$runId)"
Assert-SanitizationCase -Name 'traversal repository segment' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/../actions/runs/$runId)"
Assert-SanitizationCase -Name 'query substitution' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions/runs/99999999?run=$runId)"
Assert-SanitizationCase -Name 'fragment substitution' -ExpectedAccepted $false -Content "[CI $runWord $runId](https://github.com/AtyaLibraries/Example/actions/runs/99999999#$runId)"
Assert-SanitizationCase -Name 'reference indirection' -ExpectedAccepted $false -Content "[CI $runWord $runId][proof]`n`n[proof]: https://github.com/AtyaLibraries/Example/actions/runs/$runId"
Assert-SanitizationCase -Name 'unrelated valid link' -ExpectedAccepted $false -Content "CI $runWord $runId failed. [Proof](https://github.com/AtyaLibraries/Example/actions/runs/$runId)"

$privatePathText = 'Atya ' + 'Analyze'
$privateKeyText = '-----BEGIN ' + 'PRIVATE KEY-----'
$tokenText = 'gh' + 'p_' + ('a' * 24)
Assert-SanitizationCase -Name 'private path protection' -ExpectedAccepted $false -ExpectedRule 'private_path' -Content $privatePathText
Assert-SanitizationCase -Name 'private key protection' -ExpectedAccepted $false -ExpectedRule 'private_key' -Content $privateKeyText
Assert-SanitizationCase -Name 'token protection' -ExpectedAccepted $false -ExpectedRule 'github_token' -Content $tokenText

Write-Output 'ATYA-024 contract and all negative mutation tests passed.'
