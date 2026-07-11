<#
.SYNOPSIS
    Builds the ASL3-Manual site with zensical and pushes the compiled output
    to the allstarlink.github.io repository (replacement for 'mkdocs gh-deploy').

.DESCRIPTION
    Run from the root of the ASL3-Manual working copy. The script:
      1. Builds the site with 'zensical build'
      2. Shallow-clones the Pages repo to a temp directory
      3. Replaces its contents with the fresh build (preserving CNAME and .git)
      4. Commits with a reference back to the source commit and pushes

.EXAMPLE
    .\Deploy-Site.ps1

.EXAMPLE
    .\Deploy-Site.ps1 -DryRun
    Builds and stages everything but skips the final 'git push'.
#>

[CmdletBinding()]
param(
    # Pages repo to publish into
    [string]$SiteRepo   = 'git@github.com:AllStarLink/allstarlink.github.io.git',

    # Branch the Pages site is served from
    [string]$SiteBranch = 'main',

    # Output directory; if omitted, read site_dir from zensical.toml (default 'site')
    [string]$BuildDir,

    # Build and commit locally, but do not push
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

function Invoke-Checked {
    param([string]$Cmd, [string[]]$CmdArgs)
    & $Cmd @CmdArgs
    if ($LASTEXITCODE -ne 0) {
        throw "'$Cmd $($CmdArgs -join ' ')' failed with exit code $LASTEXITCODE"
    }
}

# --- Sanity checks -----------------------------------------------------------

foreach ($tool in 'git', 'zensical') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "'$tool' not found in PATH."
    }
}

if (-not (Test-Path '.git')) {
    throw 'Run this script from the root of the ASL3-Manual repository.'
}

# Identify the source commit for the deploy commit message
$sourceSha    = (& git rev-parse --short HEAD).Trim()
$sourceBranch = (& git rev-parse --abbrev-ref HEAD).Trim()

$dirty = (& git status --porcelain)
if ($dirty) {
    Write-Warning 'Working tree has uncommitted changes; the deployed site may not match any pushed commit.'
}

# --- Determine output directory ------------------------------------------------
# zensical has no CLI flag for the output path; it is controlled by 'site_dir'
# in zensical.toml (default: 'site', relative to the config file).

if (-not $BuildDir) {
    $BuildDir = 'site'
    if (Test-Path 'zensical.toml') {
        $match = Select-String -Path 'zensical.toml' -Pattern '^\s*site_dir\s*=\s*"([^"]+)"' |
                 Select-Object -First 1
        if ($match) {
            $BuildDir = $match.Matches[0].Groups[1].Value
        }
    }
}
Write-Host "Output directory: $BuildDir" -ForegroundColor Cyan

# --- Build -------------------------------------------------------------------

Write-Host "Building site from $sourceBranch@$sourceSha ..." -ForegroundColor Cyan

# zensical removes the site_dir itself before each build, so no pre-clean needed
Invoke-Checked 'zensical' @('build')

if (-not (Test-Path (Join-Path $BuildDir 'index.html'))) {
    throw "Build completed but '$BuildDir\index.html' is missing - refusing to deploy."
}

# Ensure GitHub Pages does not run the output through Jekyll
New-Item -ItemType File -Path (Join-Path $BuildDir '.nojekyll') -Force | Out-Null

# --- Clone target repo -------------------------------------------------------

$tempDir = Join-Path ([IO.Path]::GetTempPath()) ("site-deploy-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))

try {
    Write-Host "Cloning $SiteRepo ($SiteBranch) ..." -ForegroundColor Cyan
    Invoke-Checked 'git' @('clone', '--depth', '1', '--branch', $SiteBranch, $SiteRepo, $tempDir)

    # Preserve CNAME if the Pages repo has one and the build didn't produce one
    $cnamePath = Join-Path $tempDir 'CNAME'
    $cname = $null
    if ((Test-Path $cnamePath) -and -not (Test-Path (Join-Path $BuildDir 'CNAME'))) {
        $cname = Get-Content $cnamePath -Raw
    }

    # Wipe everything except .git
    Get-ChildItem -Path $tempDir -Force |
        Where-Object { $_.Name -ne '.git' } |
        Remove-Item -Recurse -Force

    # Copy the fresh build in (including dotfiles like .nojekyll)
    Get-ChildItem -Path $BuildDir -Force | Copy-Item -Destination $tempDir -Recurse -Force

    if ($cname) {
        Set-Content -Path $cnamePath -Value $cname -NoNewline
        Write-Host 'Preserved existing CNAME file.' -ForegroundColor Yellow
    }

    # --- Commit and push -------------------------------------------------------

    Push-Location $tempDir
    try {
        Invoke-Checked 'git' @('add', '-A')

        $staged = (& git status --porcelain)
        if (-not $staged) {
            Write-Host 'Site is already up to date - nothing to deploy.' -ForegroundColor Green
            return
        }

        $msg = "Deploy ASL3-Manual@$sourceSha ($sourceBranch)"
        Invoke-Checked 'git' @('commit', '-m', $msg)

        if ($DryRun) {
            Write-Host "Dry run: commit created locally in $tempDir but NOT pushed." -ForegroundColor Yellow
            Write-Host 'Inspect it, then delete the temp directory when done.'
            $script:KeepTemp = $true
            return
        }

        Write-Host "Pushing to $SiteRepo ($SiteBranch) ..." -ForegroundColor Cyan
        Invoke-Checked 'git' @('push', 'origin', $SiteBranch)

        Write-Host "Deployed $sourceSha successfully." -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}
finally {
    if ((Test-Path $tempDir) -and -not $script:KeepTemp) {
        Remove-Item -Recurse -Force $tempDir
    }
}