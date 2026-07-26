<#
.SYNOPSIS
    Decides whether a GitHub Actions `uses:` reference conforms to the ATYA-019 immutable
    workflow and action reference policy.

.DESCRIPTION
    ATYA-019 defines the policy; this script is its executable form. Every verdict is
    produced per individual reference, never per file, because observed workflow files mix
    conformant and non-conformant references in the same job.

    The rule identifiers (IR001..IR005) and every pattern are read from
    github/contracts/atya-019/immutable-reference-policy.json. This script contains no
    independent copy of the policy.

.PARAMETER Reference
    A single `uses:` line to judge. Returns one verdict object.

.PARAMETER Path
    A workflow or action file, or a directory to search recursively. Returns one verdict
    object per reference found and exits non-zero if any of them is a violation.

.EXAMPLE
    ./scripts/Test-ImmutableReference.ps1 -Reference '  uses: actions/checkout@v4'

.EXAMPLE
    ./scripts/Test-ImmutableReference.ps1 -Path ./.github/workflows
#>
[CmdletBinding(DefaultParameterSetName = 'Reference')]
param(
    [Parameter(ParameterSetName = 'Reference', Mandatory, Position = 0)]
    [AllowEmptyString()]
    [string] $Reference,

    [Parameter(ParameterSetName = 'Path', Mandatory, Position = 0)]
    [string] $Path,

    [Parameter()]
    [string] $RepositoryRoot = (Split-Path -Parent $PSScriptRoot),

    [Parameter()]
    [string] $PolicyPath,

    # Overrides the exception register embedded in the policy contract. Used by fixtures so
    # that exercising the exception process does not require mutating the real register.
    [Parameter()]
    [object[]] $ExceptionRegister,

    [Parameter()]
    [datetime] $EvaluationDate = [datetime]::UtcNow.Date,

    [Parameter()]
    [switch] $Json,

    # Suppresses the non-zero exit code in -Path mode. Verdicts are still reported.
    [Parameter()]
    [switch] $NoFail
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $PolicyPath) {
    $PolicyPath = Join-Path $RepositoryRoot 'github/contracts/atya-019/immutable-reference-policy.json'
}

if (-not (Test-Path -LiteralPath $PolicyPath -PathType Leaf)) {
    throw "The ATYA-019 policy contract was not found at '$PolicyPath'."
}

try {
    $policy = Get-Content -Raw -LiteralPath $PolicyPath | ConvertFrom-Json -Depth 100
}
catch {
    throw "The ATYA-019 policy contract is not valid JSON: $($_.Exception.Message)"
}

if ($policy.schemaVersion -ne 1) {
    throw "Unsupported policy schema version '$($policy.schemaVersion)'."
}

$options = [Text.RegularExpressions.RegexOptions]::CultureInvariant
$usesLineRegex = [regex]::new($policy.patterns.usesLine, $options)
$commitShaRegex = [regex]::new($policy.patterns.commitSha, $options)
$imageDigestRegex = [regex]::new($policy.patterns.imageDigest, $options)
$versionCommentRegex = [regex]::new($policy.patterns.versionComment, $options)
$remoteReferenceRegex = [regex]::new($policy.patterns.remoteReference, $options)
$reusableWorkflowPathRegex = [regex]::new($policy.patterns.reusableWorkflowPath, $options)

if ($PSBoundParameters.ContainsKey('ExceptionRegister')) {
    $register = @($ExceptionRegister)
}
else {
    $register = @($policy.exceptions.register)
}

$exceptionRequiredFields = @($policy.exceptions.requiredFields)

function New-Verdict {
    param(
        [string] $File,
        [int] $Line,
        [string] $Text,
        [string] $ReferenceValue,
        [string] $Kind,
        [string] $Verdict,
        [string] $Rule,
        [string] $Message
    )

    [pscustomobject]@{
        File      = $File
        Line      = $Line
        Reference = $ReferenceValue
        Kind      = $Kind
        Verdict   = $Verdict
        Rule      = $Rule
        Message   = $Message
        Text      = $Text
    }
}

function Get-ReferenceKind {
    param([string] $ReferenceValue)

    if ($ReferenceValue.StartsWith('./')) {
        return 'local'
    }

    if ($ReferenceValue.StartsWith('docker://')) {
        return 'docker'
    }

    $match = $remoteReferenceRegex.Match($ReferenceValue)
    if (-not $match.Success) {
        return 'unknown'
    }

    $path = if ($match.Groups['path'].Success) { $match.Groups['path'].Value } else { '' }
    if ($path -and $reusableWorkflowPathRegex.IsMatch($path)) {
        return 'remote-reusable-workflow'
    }

    return 'remote-action'
}

function Test-ExceptionCovers {
    param([string] $ReferenceValue)

    foreach ($entry in $register) {
        if (-not $entry) {
            continue
        }

        $present = @($entry.PSObject.Properties.Name)
        foreach ($field in $exceptionRequiredFields) {
            if ($present -notcontains $field) {
                throw "Exception register entry for '$($entry.reference)' is missing the required field '$field'."
            }
        }

        if ($entry.reference -cne $ReferenceValue) {
            continue
        }

        $expires = [datetime]::MinValue
        if (-not [datetime]::TryParse(
                [string] $entry.expiresOn,
                [Globalization.CultureInfo]::InvariantCulture,
                [Globalization.DateTimeStyles]::AssumeUniversal -bor [Globalization.DateTimeStyles]::AdjustToUniversal,
                [ref] $expires)) {
            throw "Exception register entry for '$($entry.reference)' has an unparseable expiresOn value."
        }

        # An expired exception reverts to the underlying violation rather than lingering.
        if ($expires -ge $EvaluationDate) {
            return $true
        }
    }

    return $false
}

function Get-Verdict {
    param(
        [string] $Text,
        [string] $File = '',
        [int] $LineNumber = 0
    )

    $normalized = $Text.TrimEnd("`r")
    $match = $usesLineRegex.Match($normalized)
    if (-not $match.Success) {
        return $null
    }

    $referenceValue = $match.Groups['reference'].Value
    if ($referenceValue.Length -ge 2) {
        $first = $referenceValue[0]
        if (($first -eq '"' -or $first -eq "'") -and $referenceValue[-1] -eq $first) {
            $referenceValue = $referenceValue.Substring(1, $referenceValue.Length - 2)
        }
    }

    $comment = if ($match.Groups['comment'].Success) { $match.Groups['comment'].Value.Trim() } else { '' }
    $kind = Get-ReferenceKind -ReferenceValue $referenceValue

    $verdict = $null
    $rule = $null
    $message = $null

    switch ($kind) {
        'local' {
            $verdict = 'exempt-by-form'
            $rule = 'IR004'
            $message = 'Local reference resolves against the calling commit; there is no independently movable ref to pin.'
        }

        'docker' {
            $image = $referenceValue.Substring('docker://'.Length)
            $separator = $image.LastIndexOf('@')
            $digest = if ($separator -ge 0) { $image.Substring($separator + 1) } else { '' }
            if ($digest -and $imageDigestRegex.IsMatch($digest)) {
                $verdict = 'conformant'
                $message = 'Pinned by immutable image digest.'
            }
            else {
                $verdict = 'violation'
                $rule = 'IR003'
                $message = 'A docker:// reference must be pinned by immutable image digest (@sha256:<64 hex>); a container tag is republishable in place.'
            }
        }

        'unknown' {
            $verdict = 'violation'
            $rule = 'IR005'
            $message = 'Reference matches no recognised kind. The policy fails closed rather than skipping what it cannot classify.'
        }

        default {
            # remote-action and remote-reusable-workflow are held to identical rules.
            $ref = $remoteReferenceRegex.Match($referenceValue).Groups['ref'].Value
            if (-not $commitShaRegex.IsMatch($ref)) {
                $verdict = 'violation'
                $rule = 'IR001'
                $message = "Ref '$ref' is not a 40-character lowercase commit SHA. Tags, branches, short SHAs, and uppercase SHAs are movable or non-canonical."
            }
            elseif (-not $comment) {
                $verdict = 'violation'
                $rule = 'IR002'
                $message = 'SHA-pinned reference carries no version comment. Renovate marks such a dependency enabled=false with skipReason unversioned-reference, so the pin is immutable but permanently frozen.'
            }
            elseif (-not $versionCommentRegex.IsMatch($comment)) {
                $verdict = 'violation'
                $rule = 'IR002'
                $message = "Trailing comment '$comment' does not name a resolvable version, so Renovate cannot recover currentValue and cannot advance the pin."
            }
            else {
                $verdict = 'conformant'
                $message = "Pinned to an immutable commit SHA and annotated with version '$comment'."
            }
        }
    }

    if ($verdict -eq 'violation' -and (Test-ExceptionCovers -ReferenceValue $referenceValue)) {
        $verdict = 'exempt-by-exception'
        $rule = $null
        $message = 'Covered by an unexpired entry in the ATYA-019 exception register.'
    }

    return New-Verdict -File $File -Line $LineNumber -Text $normalized `
        -ReferenceValue $referenceValue -Kind $kind -Verdict $verdict -Rule $rule -Message $message
}

$results = [Collections.Generic.List[object]]::new()

if ($PSCmdlet.ParameterSetName -eq 'Reference') {
    $verdict = Get-Verdict -Text $Reference
    if (-not $verdict) {
        throw "The supplied text is not a 'uses:' reference line."
    }
    $results.Add($verdict)
}
else {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Path '$Path' does not exist."
    }

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $files =
        if (Test-Path -LiteralPath $resolved -PathType Container) {
            @(Get-ChildItem -Recurse -File -LiteralPath $resolved |
                Where-Object { $_.Extension -in @('.yml', '.yaml') })
        }
        else {
            @(Get-Item -LiteralPath $resolved)
        }

    foreach ($file in $files) {
        try {
            $lines = @(Get-Content -LiteralPath $file.FullName)
        }
        catch {
            # IR005: fail closed on anything unreadable rather than reporting it clean.
            $results.Add((New-Verdict -File $file.FullName -Line 0 -Text '' -ReferenceValue '' `
                        -Kind 'unknown' -Verdict 'violation' -Rule 'IR005' `
                        -Message "File could not be read: $($_.Exception.Message)"))
            continue
        }

        $relative = [IO.Path]::GetRelativePath($RepositoryRoot, $file.FullName).Replace('\', '/')
        for ($index = 0; $index -lt $lines.Count; $index++) {
            $verdict = Get-Verdict -Text $lines[$index] -File $relative -LineNumber ($index + 1)
            if ($verdict) {
                $results.Add($verdict)
            }
        }
    }
}

if ($Json) {
    $results | ConvertTo-Json -Depth 5
}
else {
    $results
}

if ($PSCmdlet.ParameterSetName -eq 'Path' -and -not $NoFail) {
    if (@($results | Where-Object Verdict -eq 'violation').Count -gt 0) {
        exit 1
    }
}
