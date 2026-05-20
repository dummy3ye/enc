$InstallDir = "$HOME\.enc"

Write-Host "Removing $InstallDir from User PATH..." -ForegroundColor Cyan
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -like "*$InstallDir*") {
    $NewPath = $UserPath -replace [regex]::Escape(";$InstallDir"), ""
    $NewPath = $NewPath -replace [regex]::Escape($InstallDir), ""
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "User PATH updated." -ForegroundColor Green
} else {
    Write-Host "$InstallDir not found in PATH." -ForegroundColor Yellow
}

if (Test-Path $InstallDir) {
    Write-Host "Removing installation directory: $InstallDir" -ForegroundColor Cyan
    Remove-Item -Recurse -Force $InstallDir
    Write-Host "Cleanup complete." -ForegroundColor Green
} else {
    Write-Host "Installation directory not found." -ForegroundColor Yellow
}

Write-Host "`nUninstallation complete!" -ForegroundColor Green
