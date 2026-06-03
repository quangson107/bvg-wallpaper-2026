[CmdletBinding()]
param(
    [ValidateRange(1, 12)]
    [int] $Month = (Get-Date).Month,

    [switch] $DownloadAll,
    [switch] $InstallMonthlyTask,
    [switch] $RemoveMonthlyTask,
    [switch] $OpenFolder
)

$ErrorActionPreference = "Stop"

$TaskName = "BVG Wallpaper 2026 Monthly"
$ScriptDir = Split-Path -Parent $PSCommandPath
$WallpaperDir = Join-Path $ScriptDir "wallpapers"

$Wallpapers = @(
    [pscustomobject]@{ Month = 1;  File = "BVG-2026-01-Jan.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0002_1767177192" },
    [pscustomobject]@{ Month = 2;  File = "BVG-2026-02-Feb.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0003_1767177198" },
    [pscustomobject]@{ Month = 3;  File = "BVG-2026-03-Mar.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0004_1767177207" },
    [pscustomobject]@{ Month = 4;  File = "BVG-2026-04-Apr.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0005_1767177214" },
    [pscustomobject]@{ Month = 5;  File = "BVG-2026-05-May.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0006_1767177219" },
    [pscustomobject]@{ Month = 6;  File = "BVG-2026-06-Jun.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0007_1767177232" },
    [pscustomobject]@{ Month = 7;  File = "BVG-2026-07-Jul.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0008_1767177244" },
    [pscustomobject]@{ Month = 8;  File = "BVG-2026-08-Aug.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0009_1767177251" },
    [pscustomobject]@{ Month = 9;  File = "BVG-2026-09-Sep.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0010_1767177263" },
    [pscustomobject]@{ Month = 10; File = "BVG-2026-10-Oct.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0011_1767177277" },
    [pscustomobject]@{ Month = 11; File = "BVG-2026-11-Nov.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0012_1767177296" },
    [pscustomobject]@{ Month = 12; File = "BVG-2026-12-Dec.jpg"; Url = "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0013_1767177301" }
)

function Ensure-WallpaperDir {
    if (-not (Test-Path -LiteralPath $WallpaperDir)) {
        New-Item -ItemType Directory -Path $WallpaperDir | Out-Null
    }
}

function Get-WallpaperPath {
    param([Parameter(Mandatory)] $Item)
    Join-Path $WallpaperDir $Item.File
}

function Save-Url {
    param(
        [Parameter(Mandatory)] [string] $Url,
        [Parameter(Mandatory)] [string] $OutFile
    )

    $TempFile = "$OutFile.download"
    if (Test-Path -LiteralPath $TempFile) {
        Remove-Item -LiteralPath $TempFile -Force
    }

    $downloaded = $false
    try {
        $ProgressPreference = "SilentlyContinue"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $Url -OutFile $TempFile -UseBasicParsing -Headers @{ "User-Agent" = "Mozilla/5.0" }
        $downloaded = $true
    }
    catch {
        $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
        if ($curl) {
            & $curl.Source -L --fail --ssl-no-revoke -A "Mozilla/5.0" -o $TempFile $Url
            $downloaded = ($LASTEXITCODE -eq 0)
        }
    }

    if (-not $downloaded -or -not (Test-Path -LiteralPath $TempFile)) {
        throw "Could not download $Url"
    }

    Move-Item -LiteralPath $TempFile -Destination $OutFile -Force
}

function Ensure-WallpaperFile {
    param([Parameter(Mandatory)] $Item)

    Ensure-WallpaperDir
    $path = Get-WallpaperPath -Item $Item
    if (Test-Path -LiteralPath $path) {
        $existing = Get-Item -LiteralPath $path
        if ($existing.Length -gt 0) {
            return $path
        }
    }

    Write-Host "Downloading month $($Item.Month): $($Item.File)"
    Save-Url -Url $Item.Url -OutFile $path
    return $path
}

function Set-DesktopWallpaper {
    param([Parameter(Mandatory)] [string] $Path)

    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "10"
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"

    if (-not ("Wallpaper.NativeMethods" -as [type])) {
        Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
namespace Wallpaper {
    public static class NativeMethods {
        [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
        public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
}
"@
    }

    $ok = [Wallpaper.NativeMethods]::SystemParametersInfo(20, 0, $resolvedPath, 3)
    if (-not $ok) {
        throw "Windows did not accept the wallpaper change."
    }
}

function Install-MonthlyTask {
    $scriptPath = (Resolve-Path -LiteralPath $PSCommandPath).Path
    $taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    & schtasks.exe /Create /TN $TaskName /SC MONTHLY /D 1 /ST 09:00 /TR $taskCommand /F | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "Could not create the monthly Windows task."
    }
}

function Remove-MonthlyTask {
    & schtasks.exe /Delete /TN $TaskName /F | Out-Host
}

if ($RemoveMonthlyTask) {
    Remove-MonthlyTask
    exit
}

if ($DownloadAll) {
    foreach ($item in $Wallpapers) {
        [void](Ensure-WallpaperFile -Item $item)
    }
}

$selected = $Wallpapers | Where-Object { $_.Month -eq $Month } | Select-Object -First 1
$wallpaperPath = Ensure-WallpaperFile -Item $selected
Set-DesktopWallpaper -Path $wallpaperPath

if ($InstallMonthlyTask) {
    Install-MonthlyTask
}

if ($OpenFolder) {
    Invoke-Item -LiteralPath $WallpaperDir
}

Write-Host "BVG wallpaper set for month ${Month}: $wallpaperPath"
