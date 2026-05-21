$InstallDir = "$HOME\.enc"

Write-Host "Removing $InstallDir from PATH..." -ForegroundColor Cyan
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -like "*$InstallDir*") {
    $NewPath = $UserPath -replace [regex]::Escape(";$InstallDir"), ""
    $NewPath = $NewPath -replace [regex]::Escape($InstallDir), ""
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    Write-Host "PATH updated." -ForegroundColor Green
} else {
    Write-Host "$InstallDir not found in PATH." -ForegroundColor Yellow
}

if (Test-Path $InstallDir) {
    Remove-Item -Recurse -Force $InstallDir
    Write-Host "Directory removed." -ForegroundColor Green
} else {
    Write-Host "Directory not found." -ForegroundColor Yellow
}

Write-Host "Uninstallation complete." -ForegroundColor Green
