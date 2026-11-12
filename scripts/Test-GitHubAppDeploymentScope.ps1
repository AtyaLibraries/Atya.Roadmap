[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $EvidencePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Scope {
    param([bool] $Condition, [string] $Message)
    if (-not $Condition) {
        throw $Message
    }
}

try {
    $evidence = Get-Content -Raw -LiteralPath $EvidencePath | ConvertFrom-Json -Depth 100
}
catch {
    throw "Deployment-scope evidence is not valid JSON."
}

$permissionNames = @($evidence.registration.repositoryPermissions.PSObject.Properties | ForEach-Object Name)
Assert-Scope ($permissionNames.Count -eq 2) 'Deployment requests unexpected repository permissions.'
Assert-Scope ($evidence.registration.repositoryPermissions.contents -eq 'write') 'Deployment lacks the exact Contents write permission.'
Assert-Scope ($evidence.registration.repositoryPermissions.metadata -eq 'read') 'Deployment lacks Metadata read.'
Assert-Scope (@($evidence.registration.organizationPermissions.PSObject.Properties).Count -eq 0) 'Deployment requests organization permissions.'

$installed = @($evidence.installation.repositories)
$sourceIds = @($evidence.broker.sourceRepositoryIds | ForEach-Object { [string] $_ })
$uniqueSourceIds = @($sourceIds | Sort-Object -Unique)
$publisherId = [string] $evidence.broker.publisherRepositoryId

Assert-Scope ($evidence.installation.repositorySelection -eq 'selected') 'Installation is not selected-repository scoped.'
Assert-Scope ($installed.Count -eq 1) 'Installation must contain exactly one repository.'
Assert-Scope ($installed[0].role -eq 'publisher') 'Installed repository does not have the publisher role.'
Assert-Scope ([string]$installed[0].id -eq $publisherId) 'Broker and installation publisher identities differ.'
Assert-Scope ($sourceIds.Count -eq 29) 'Broker source allowlist must contain 29 entries.'
Assert-Scope ($uniqueSourceIds.Count -eq 29) 'Broker source allowlist contains duplicates.'
Assert-Scope ($sourceIds -notcontains $publisherId) 'Publisher identity must not appear in the source allowlist.'
Assert-Scope (@($sourceIds | Where-Object { $_ -notmatch '^[1-9][0-9]*$' }).Count -eq 0) 'Source identities must be numeric repository IDs.'
Assert-Scope ($publisherId -match '^[1-9][0-9]*$') 'Publisher identity must be a numeric repository ID.'

[pscustomobject]@{
    PermissionContract = 'Passed'
    InstalledRepositories = $installed.Count
    SourceAllowlistEntries = $sourceIds.Count
    NamesEmitted = 0
    IdentitiesEmitted = 0
} | Format-List
