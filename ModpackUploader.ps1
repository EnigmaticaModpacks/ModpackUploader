. .\settings.ps1

function Download-GithubRelease {
    param(
        [parameter(Mandatory=$true)]
        [string]
        $repo,
        [parameter(Mandatory=$true)]
        [string]
        $file
    )

    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host "Determining latest release of $repo"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $tag = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)[0].tag_name

    $download = "https://github.com/$repo/releases/download/$tag/$file"
    $name = $file.Split(".")[0]

    Write-Host Dowloading...
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest $download -Out $file

    # Cleaning up target dir
    Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue
}

function Clear-SleepHost {
    Start-Sleep 2
    Clear-Host
}

if ($ENABLE_MANIFEST_BUILDER_MODULE) {
    $TwitchExportBuilder = "TwitchExportBuilder.exe"
    if (!(Test-Path $TwitchExportBuilder) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        Remove-Item $TwitchExportBuilder -Recurse -Force -ErrorAction SilentlyContinue
        Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file "twitch-export-builder_windows_amd64.exe"
    }
    Rename-Item -Path "twitch-export-builder_windows_amd64.exe" -NewName $TwitchExportBuilder
    .\TwitchExportBuilder.exe -n "$CLIENT_FILENAME" -p "$MODPACK_VERSION"
    Clear-SleepHost
}

if ($ENABLE_CHANGELOG_GENERATOR_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {
    $ChangelogGenerator = "ChangelogGenerator.jar"
    if (!(Test-Path $ChangelogGenerator) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        Remove-Item $ChangelogGenerator -Recurse -Force 
        Download-GithubRelease -repo "TheRandomLabs/ChangelogGenerator" -file $ChangelogGenerator
    }
    Remove-Item oldmanifest.json, manifest.json, shortchangelog.txt, MOD_CHANGELOGS.txt -ErrorAction SilentlyContinue
    if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed to generate changelogs"} 
    Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"

    sz e "$CLIENT_FILENAME $LAST_MODPACK_VERSION.zip" manifest.json
    Rename-Item -Path manifest.json -NewName oldmanifest.json
    sz e "$CLIENT_FILENAME-$MODPACK_VERSION.zip" manifest.json

    Clear-SleepHost
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Generating changelog..." -ForegroundColor Green
    Write-Host ""

    java -jar ChangelogGenerator.jar oldmanifest.json manifest.json
    Rename-Item -Path changelog.txt -NewName MOD_CHANGELOGS.txt
}

if ($ENABLE_MODPACK_UPLOADER_MODULE) {
    $CLIENT_FILENAME = "$CLIENT_FILENAME-$MODPACK_VERSION.zip"

    $CLIENT_METADATA = 
    "{
    'changelog': `'$CLIENT_CHANGELOG`',
    'changelogType': `'$CLIENT_CHANGELOG_TYPE`',
    'displayName': `'$CLIENT_FILE_DISPLAY_NAME`',
    'gameVersions': [$GAME_VERSIONS],
    'releaseType': `'$CLIENT_RELEASE_TYPE`'
    }"
    
    Clear-SleepHost
    if ($ENABLE_EXTRA_LOGGING) {
        Write-Host "Client Metadata:"
        Write-Host $CLIENT_METADATA 
    }

    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Uploading client files..." -ForegroundColor Green
    Write-Host ""

    $Response = curl.exe --url "https://minecraft.curseforge.com/api/projects/$CURSEFORGE_PROJECT_ID/upload-file" --user "$CURSEFORGE_USER`:$CURSEFORGE_TOKEN" -H "Accept: application/json" -H X-Api-Token:$CURSEFORGE_TOKEN -F metadata=$CLIENT_METADATA -F file=@$CLIENT_FILENAME --progress-bar | ConvertFrom-Json
    $ResponseId = $Response.id

    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "The modpack has been uploaded." -ForegroundColor Green
    Write-Host "ID returned: $ResponseId" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Start-Sleep -Seconds 1
}

if ($ENABLE_SERVER_FILE_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {
    Clear-SleepHost
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Compressing Server files..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""

    $SERVER_FILENAME = "$SERVER_FILENAME.zip"
    Compress-Archive -Path $CONTENTS_TO_ZIP -DestinationPath "$PSScriptRoot\$SERVER_FILENAME"

    $SERVER_METADATA = 
    "{
    'changelog': `'$SERVER_CHANGELOG`',
    'changelogType': `'$SERVER_CHANGELOG_TYPE`',
    'displayName': `'$SERVER_FILE_DISPLAY_NAME`',
    'parentFileId': $ResponseId,
    'releaseType': `'$SERVER_RELEASE_TYPE`'
    }"

    Clear-SleepHost
    if ($ENABLE_EXTRA_LOGGING) {
        Write-Host "Server Metadata:"
        Write-Host $SERVER_METADATA
    }

    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Uploading server files..." -ForegroundColor Green
    Write-Host ""

    $ResponseServer = curl.exe --url "https://minecraft.curseforge.com/api/projects/$CURSEFORGE_PROJECT_ID/upload-file" --user "$CURSEFORGE_USER`:$CURSEFORGE_TOKEN" -H "Accept: application/json" -H X-Api-Token:$CURSEFORGE_TOKEN -F metadata=$SERVER_METADATA -F file=@$SERVER_FILENAME --progress-bar
}

Clear-SleepHost

Write-Host "######################################" -ForegroundColor Cyan
Write-Host ""
Write-Host "The Modpack Uploader has completed." -ForegroundColor Green
Write-Host ""
Write-Host "######################################" -ForegroundColor Cyan

Start-Sleep -Seconds 5