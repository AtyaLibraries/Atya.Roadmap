$ErrorActionPreference = 'Stop'
$sut = Join-Path (Split-Path $PSScriptRoot -Parent) 'scripts/Test-ReleaseLineage.ps1'
$fixture = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N'))

function Invoke-Check([string] $Mode, [int] $ExpectedExit) {
    $pwsh = Join-Path $PSHOME 'pwsh.exe'
    & $pwsh -NoProfile -File $sut -Mode $Mode -RepositoryPath $fixture -DevelopmentRef development -ReleaseRef master -StableTag v1.0.0 | Out-Null
    if ($LASTEXITCODE -ne $ExpectedExit) { throw "$Mode returned $LASTEXITCODE; expected $ExpectedExit." }
}

try {
    git init --quiet --initial-branch fixture-root $fixture
    git -C $fixture config user.name 'ATYA contract fixture'
    git -C $fixture config user.email 'fixture@example.invalid'
    Set-Content -LiteralPath (Join-Path $fixture 'value.txt') -Value 'release'
    git -C $fixture add value.txt
    git -C $fixture commit --quiet -m release
    git -C $fixture branch master
    git -C $fixture branch development
    git -C $fixture tag v1.0.0

    Invoke-Check ReleaseTime 0

    git -C $fixture switch --quiet development
    Set-Content -LiteralPath (Join-Path $fixture 'value.txt') -Value 'next development'
    git -C $fixture commit --quiet -am development
    Invoke-Check ReleaseTime 1
    Invoke-Check Retrospective 0

    git -C $fixture switch --quiet --orphan detached-release
    git -C $fixture rm --quiet -rf --ignore-unmatch .
    Set-Content -LiteralPath (Join-Path $fixture 'detached.txt') -Value 'detached'
    git -C $fixture add detached.txt
    git -C $fixture commit --quiet -m detached
    git -C $fixture tag -f v1.0.0 | Out-Null
    Invoke-Check Retrospective 1

    Write-Host 'Release-lineage temporal contract tests passed.'
} finally {
    if (Test-Path -LiteralPath $fixture) { Remove-Item -LiteralPath $fixture -Recurse -Force }
}
