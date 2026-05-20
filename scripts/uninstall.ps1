# uninstall.ps1 - Uninstallation script for enc utility

$InstallDir = "$HOME\.enc"

# 1. Remove from User PATH
Write-Host "Removing $InstallDir from User PATH..." -ForegroundColor Cyan
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -like "*$InstallDir*") {
    # Remove the directory and any potentially double semicolons
    $NewPath = $UserPath -replace [regex]::Escape(";$InstallDir"), ""
    $NewPath = $NewPath -replace [regex]::Escape($InstallDir), ""
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "User PATH updated." -ForegroundColor Green
} else {
    Write-Host "$InstallDir not found in PATH." -ForegroundColor Yellow
}

# 2. Remove installation directory
if (Test-Path $InstallDir) {
    Write-Host "Removing installation directory: $InstallDir" -ForegroundColor Cyan
    Remove-Item -Recurse -Force $InstallDir
    Write-Host "Cleanup complete." -ForegroundColor Green
} else {
    Write-Host "Installation directory not found." -ForegroundColor Yellow
}

Write-Host "`nUninstallation complete!" -ForegroundColor Green
