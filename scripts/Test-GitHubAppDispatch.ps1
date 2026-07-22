[CmdletBinding()]
param(
    [Parameter()]
    [string] $RepositoryRoot = (Split-Path -Parent $PSScriptRoot),

    [Parameter()]
    [string] $RegistrationPath,

    [Parameter()]
    [switch] $SkipSanitization
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

function Read-JsonFile {
    param([string] $Path)
    try {
        return Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json -Depth 100
    }
    catch {
        throw "Invalid JSON: $Path. $($_.Exception.Message)"
    }
}

$contractRoot = Join-Path $RepositoryRoot 'github/contracts/atya-024'
if (-not $RegistrationPath) {
    $RegistrationPath = Join-Path $contractRoot 'github-app-registration.json'
}

$registration = Read-JsonFile $RegistrationPath
$dispatch = Read-JsonFile (Join-Path $contractRoot 'dispatch-contract.json')

Assert-Equal $registration.schemaVersion 1 'Registration schema version is unsupported.'
Assert-Equal $registration.task 'ATYA-024' 'Registration belongs to the wrong task.'
Assert-Equal $registration.decisionStatus 'organization-owner-decision-required' 'The architecture decision must remain explicit.'
Assert-Equal $registration.application.visibility 'private' 'The App must be private.'
Assert-Equal $registration.application.installationScope 'only-this-account' 'The App must be installable only on its owning account.'
Assert-Equal $registration.application.webhook.active $false 'Webhooks are not part of the selected broker contract.'
Assert-Equal @($registration.application.webhook.events).Count 0 'No webhook subscriptions are allowed.'
Assert-Equal @($registration.application.oauth.callbackUrls).Count 0 'OAuth callbacks are not allowed.'
Assert-Equal $registration.application.oauth.clientSecretRequired $false 'A client secret is not required.'

$repositoryPermissionNames = @($registration.permissions.repository.PSObject.Properties | ForEach-Object Name)
$organizationPermissionNames = @($registration.permissions.organization.PSObject.Properties | ForEach-Object Name)
Assert-Equal $repositoryPermissionNames.Count 2 'Unexpected repository permissions were requested.'
Assert-True ($repositoryPermissionNames -contains 'contents') 'Contents permission is required for repository_dispatch.'
Assert-True ($repositoryPermissionNames -contains 'metadata') 'Metadata read must be documented.'
Assert-Equal $registration.permissions.repository.contents 'write' 'repository_dispatch requires Contents write.'
Assert-Equal $registration.permissions.repository.metadata 'read' 'Metadata must remain read-only.'
Assert-Equal $organizationPermissionNames.Count 0 'Organization permissions are prohibited.'
Assert-Equal $registration.installation.repositorySelection 'selected' 'All-repository installation is prohibited.'
Assert-Equal $registration.installation.repositoryCount 1 'The App installation must contain only the publisher target.'
Assert-Equal @($registration.installation.repositoryRoles).Count 1 'Exactly one repository role is allowed.'
Assert-Equal $registration.installation.repositoryRoles[0] 'publisher' 'The only installation role must be publisher.'

Assert-Equal $registration.credentials.privateKey.recommendedPlacement 'external-managed-key-vault-sign-only' 'The private-key placement changed.'
Assert-Equal $registration.credentials.privateKey.githubActionsSecret $false 'The private key must not be an Actions secret.'
Assert-Equal $registration.credentials.privateKey.runnerReadable $false 'The private key must not be runner-readable.'
Assert-Equal $registration.credentials.privateKey.exportableAfterImport $false 'The imported key must be non-exportable.'
Assert-Equal $registration.credentials.privateKey.decisionApproved $false 'Owner approval must not be implied before the checkpoint.'
Assert-Equal $registration.credentials.clientId.sensitive $false 'Client ID classification changed unexpectedly.'

Assert-Equal $dispatch.schemaVersion 1 'Dispatch schema version is unsupported.'
Assert-Equal $dispatch.topology.sourceWorkflowCount 29 'The source-workflow count changed.'
Assert-Equal $dispatch.topology.publisherTargetCount 1 'The publisher-target count changed.'
Assert-Equal @($dispatch.topology.dispatchEventTypes).Count 1 'Exactly one event type is allowed.'
Assert-Equal $dispatch.topology.dispatchEventTypes[0] 'publish-package' 'The canonical event type changed.'
Assert-Equal $dispatch.topology.independentFailedDispatchMigrations 4 'The failed-dispatch child count changed.'
Assert-Equal $dispatch.sourceAuthentication.mechanism 'github-actions-oidc' 'Source authentication must be secretless.'
Assert-Equal $dispatch.sourceAuthentication.secretsRequired $false 'Source workflows must not require shared secrets.'
Assert-Equal $dispatch.authorization.requiredRefType 'tag' 'Only tags may request a dispatch.'
Assert-Equal $dispatch.authorization.denyPullRequestEvents $true 'Pull request events must be denied.'
Assert-Equal $dispatch.authorization.denyUnlistedBranches $true 'Branch events must be denied.'
Assert-Equal $dispatch.authorization.denyForks $true 'Fork identities must be denied.'
Assert-Equal $dispatch.broker.privateKeyOperation 'vault-sign-only' 'The broker must not read the private key.'
Assert-Equal $dispatch.broker.installationTokenVisibleToSource $false 'The installation token must remain broker-side.'
Assert-Equal $dispatch.broker.installationRepositoryCount 1 'Installation tokens must be scoped to one repository.'
Assert-True ($dispatch.payload.maximumBytes -le 4096) 'The dispatch payload bound is too large.'

$ledger = @(Import-Csv -LiteralPath (Join-Path $contractRoot 'migration-ledger.csv'))
Assert-Equal $ledger.Count 4 'The sanitized migration ledger must contain four aggregate scopes.'
Assert-Equal (($ledger | Where-Object Scope -eq 'source-workflows').Expected) '29' 'The ledger source count is inconsistent.'
Assert-Equal (($ledger | Where-Object Scope -eq 'publisher-targets').Expected) '1' 'The ledger publisher count is inconsistent.'
Assert-Equal (($ledger | Where-Object Scope -eq 'failed-dispatch-migrations').Expected) '4' 'The ledger failed-dispatch count is inconsistent.'

$allowedOwnerId = '1000'
$allowedRepositoryIds = @('2001')
$allowedWorkflowRef = 'example/source/.github/workflows/publish.yml@refs/heads/main'
$tagRegex = [regex]::new($dispatch.authorization.requiredRefPattern, [Text.RegularExpressions.RegexOptions]::CultureInvariant)

foreach ($fixturePath in Get-ChildItem -File -Filter '*.json' -LiteralPath (Join-Path $contractRoot 'fixtures')) {
    $fixture = Read-JsonFile $fixturePath.FullName
    if ($fixture.PSObject.Properties.Name -notcontains 'expected') {
        continue
    }
    $claims = $fixture.claims
    $allow =
        $claims.iss -eq 'https://token.actions.githubusercontent.com' -and
        $claims.aud -eq $dispatch.sourceAuthentication.audience -and
        $claims.repository_owner_id -eq $allowedOwnerId -and
        $allowedRepositoryIds -contains $claims.repository_id -and
        $claims.event_name -eq 'push' -and
        $claims.ref_type -eq 'tag' -and
        $tagRegex.IsMatch([string] $claims.ref) -and
        $claims.workflow_ref -eq $allowedWorkflowRef -and
        [regex]::IsMatch([string] $claims.workflow_sha, '^[0-9a-f]{40}$')
    $actual = if ($allow) { 'allow' } else { 'deny' }
    Assert-Equal $actual $fixture.expected "Fixture $($fixturePath.Name) produced the wrong authorization decision."
}

if (-not $SkipSanitization) {
    $publishableExtensions = @('.md', '.json', '.csv', '.yml', '.yaml', '.ps1')
    $files = Get-ChildItem -Recurse -File -LiteralPath $RepositoryRoot |
        Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $publishableExtensions -contains $_.Extension }
    # Build signatures from fragments so this validator does not flag its own source.
    $privateRootSignature = 'Atya ' + 'Analyze'
    $privateAuditSignature = [regex]::Escape('repository' + '-audit')
    $privateKeySignature = '-----BEGIN ' + '(?:RSA )?' + 'PRIVATE KEY-----'
    $githubTokenSignature = '(?:gh' + '[opurs]_|github' + '_pat_)[A-Za-z0-9_]+'
    $auditRunSignature = '(?:r' + 'un|j' + 'ob)\s+[0-9]{8,}'
    $prohibitedPatterns = [ordered]@{
        private_path = "$privateRootSignature|$privateAuditSignature"
        private_key = $privateKeySignature
        github_token = $githubTokenSignature
        audit_run_identifier = $auditRunSignature
    }
    foreach ($file in $files) {
        $text = Get-Content -Raw -LiteralPath $file.FullName
        foreach ($entry in $prohibitedPatterns.GetEnumerator()) {
            if ($text -match $entry.Value) {
                throw "Sanitization failure '$($entry.Key)' in $($file.FullName)."
            }
        }
    }
}

[pscustomobject]@{
    Task = 'ATYA-024'
    RegistrationContract = 'Passed'
    PermissionScope = 'Passed'
    CredentialPlacement = 'Passed'
    DispatchContract = 'Passed'
    NegativeFixtures = 'Passed'
    MigrationLedger = 'Passed'
    Sanitization = if ($SkipSanitization) { 'Skipped' } else { 'Passed' }
} | Format-List
