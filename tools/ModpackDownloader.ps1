Set-Location "$PSScriptRoot\.."

. .\settings.ps1

function Download-GithubRelease {
    param(
        [parameter(Mandatory = $true)]
        [string]
        $repo,
        [parameter(Mandatory = $true)]
        [string]
        $file
    )

    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host "Determining latest release of $repo"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $tag = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)[0].tag_name

    $download = "https://github.com/$repo/releases/download/$tag/$file"

    if ($IsWindows) {
        $name = $file.Split(".")[0]
    }

    Write-Host Dowloading...
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest $download -Out $file

    # Cleaning up target dir
    if ($IsWindows) {
        Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Clear-SleepHost {
    Start-Sleep 2
    Clear-Host
}
if ($IsLinux) {
    #Lets Check if the user has Curl Installed
    if (-not (test-path "/usr/bin/curl")) { Write-Host "Curl needed to use the ModpackUploader." }
    Set-Alias cl "curl"

    #If Program is NOT installed KILL
    if (-not (test-path "/usr/bin/curl")) { Break }
}
elseif ($IsWindows) {
    #Lets Check if the user has 7-Zip Installed
    if (-not (test-path "$env:C:\Windows\System32\curl.exe")) { Write-Host "Curl needed to use the ModpackUploader." }
    Set-Alias cl "$env:C:\Windows\System32\curl.exe"

    #If Program is NOT installed KILL
    if (-not (test-path "$env:C:\Windows\System32\curl.exe")) { Break }
}

#Download the Mod Pack Downloader Tool
if (!(Test-Path "ModpackDownloader.jar") -or $ENABLE_ALWAYS_UPDATE_JARS) {
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Downloading Modpack Downloader...     " -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Download-GithubRelease -repo "CrankySupertoon/ModPackDownloader" -file $ModpackDownloaderDL
    New-Item "./tools" -ItemType "directory" -Force -ErrorAction SilentlyContinue
    Move-Item -Path "$ModpackDownloaderDL" -Destination "tools/ModpackDownloader.jar"
}

#Now lets download the mods
Write-Host "######################################" -ForegroundColor Cyan
Write-Host ""
Write-Host "Downloading Mods...                   " -ForegroundColor Green
Write-Host ""
Write-Host "######################################" -ForegroundColor Cyan
java -jar tools/ModpackDownloader.jar -manifest mods.json -folder mods
