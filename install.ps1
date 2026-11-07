# MockiFlo CLI Windows Installer
$ErrorActionPreference = 'Stop'

Write-Host "==> Installing MockiFlo CLI for Windows..." -ForegroundColor Cyan

# 1. Check machine architecture
$arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
if ($arch -ne "AMD64" -and $arch -ne "ARM64") {
    Write-Error "Error: Unsupported CPU architecture ($arch). Only 64-bit Windows is supported."
    exit 1
}

# 2. Define download URL and installation paths
$binaryName = "mockiflo-windows-amd64.exe"
$downloadUrl = "https://github.com/raflsspace/mockiflo/releases/latest/download/$binaryName"
$installDir = "$env:LOCALAPPDATA\mockiflo\bin"
$targetFile = "$installDir\mockiflo.exe"

# 3. Create destination directory if it does not exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

# 4. Download binary
Write-Host "==> Downloading binary from GitHub Releases..." -ForegroundColor Cyan
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $downloadUrl -OutFile $targetFile -UseBasicParsing
} catch {
    Write-Error "Failed to download MockiFlo CLI: $_"
    exit 1
}

# 5. Add installation path to User PATH environment variable
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -split ';' -notcontains $installDir) {
    Write-Host "==> Adding $installDir to User PATH..." -ForegroundColor Cyan
    $newPath = if ([string]::IsNullOrEmpty($userPath)) { $installDir } else { "$userPath;$installDir" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

# Update current session PATH
if ($env:PATH -split ';' -notcontains $installDir) {
    $env:PATH = "$env:PATH;$installDir"
}

Write-Host "==> MockiFlo CLI installed successfully!" -ForegroundColor Green
Write-Host "Run 'mockiflo --help' to get started." -ForegroundColor Green
Write-Host "Note: You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
