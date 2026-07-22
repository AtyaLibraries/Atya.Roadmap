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

Write-Output 'ATYA-024 contract and all negative mutation tests passed.'
