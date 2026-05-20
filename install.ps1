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
    Write-Error "Compilation failed. Ensure GCC is installed and in your PATH."
    exit $LASTEXITCODE
}
Write-Host "Compilation successful: $FullPath" -ForegroundColor Green

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Adding $InstallDir to User PATH..." -ForegroundColor Cyan
    $NewPath = "$UserPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    $env:Path = "$env:Path;$InstallDir" # Update current session
    Write-Host "PATH updated successfully." -ForegroundColor Green
} else {
    Write-Host "$InstallDir is already in PATH." -ForegroundColor Yellow
}

Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "You may need to restart your terminal to use the 'enc' command." -ForegroundColor Yellow
