# install.ps1 - a cli tool for text encode and decoding

$InstallDir = "$HOME\.enc"
$ExeName = "enc.exe"
$FullPath = Join-Path $InstallDir $ExeName

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
    Write-Host "Created installation directory: $InstallDir" -ForegroundColor Cyan
}

$SourcePath = Join-Path $PSScriptRoot ".\enc.c"
Write-Host "Compiling $SourcePath..." -ForegroundColor Cyan
gcc -O3 $SourcePath -o $FullPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilation failed."
    exit $LASTEXITCODE
}
Write-Host "Compilation successful." -ForegroundColor Green

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
