# get.ps1 - a cli tool for text encode and decoding
# Run via: iwr -useb https://raw.githubusercontent.com/dummy3ye/enc/master/scripts/get.ps1 | iex

$RepoUrl = "https://raw.githubusercontent.com/dummy3ye/enc/master"
$InstallDir = "$HOME\.enc"
$ExePath = Join-Path $InstallDir "enc.exe"

Write-Host "--- enc Installer ---" -ForegroundColor Cyan

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

Write-Host "Downloading binary..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri "$RepoUrl/bin/enc.exe" -OutFile $ExePath -UseBasicParsing
} catch {
    Write-Error "Download failed."
    exit 1
}

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    $NewPath = "$UserPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    $env:Path = "$env:Path;$InstallDir"
    Write-Host "PATH updated." -ForegroundColor Green
} else {
    Write-Host "$InstallDir already in PATH." -ForegroundColor Yellow
}

Write-Host "Installation complete." -ForegroundColor Green
