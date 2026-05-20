# get.ps1 - Remote bootstrapper for enc utility
# Run via: iwr -useb https://raw.githubusercontent.com/dummy3ye/enc/main/scripts/get.ps1 | iex

$RepoUrl = "https://raw.githubusercontent.com/dummy3ye/enc/main"
$InstallDir = "$HOME\.enc"
$ExeName = "enc.exe"
$FullPath = Join-Path $InstallDir $ExeName

Write-Host "--- enc Installer ---" -ForegroundColor Cyan

# 1. Create install directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

# 2. Download Source
$TempSrc = Join-Path $env:TEMP "enc_tmp.c"
Write-Host "Downloading source from GitHub..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri "$RepoUrl/src/enc.c" -OutFile $TempSrc -UseBasicParsing
} catch {
    Write-Error "Failed to download source code. Check your internet connection or the repository URL."
    exit 1
}

# 3. Compile
Write-Host "Compiling..." -ForegroundColor Cyan
gcc -O3 $TempSrc -o $FullPath
$CompileResult = $LASTEXITCODE
Remove-Item $TempSrc # Cleanup

if ($CompileResult -ne 0) {
    Write-Error "Compilation failed. Ensure GCC (MinGW-w64) is installed."
    exit 1
}

# 4. PATH Update
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Updating PATH..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    $env:Path = "$env:Path;$InstallDir"
}

Write-Host "`nSuccessfully installed to $InstallDir" -ForegroundColor Green
Write-Host "Restart your terminal and type 'enc' to begin." -ForegroundColor Yellow
