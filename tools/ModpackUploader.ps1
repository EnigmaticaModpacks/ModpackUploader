Set-Location ".."
. .\settings.ps1
. .\secrets.ps1

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

    #Lets Check if the user has 7-Zip Installed
    if (-not (test-path "/usr/bin/7z")) { 
        Write-Host "7-Zip needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return
    }
    Set-Alias sz "7z"

    #Lets Check if the user has Curl Installed
    if (-not (test-path "/usr/bin/curl")) { 
        Write-Host "Curl needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return
    }
    Set-Alias cl "curl"

}
elseif ($IsMacOS) {

    #Lets Check if the user has 7-Zip Installed
    if (-not (test-path "/usr/local/bin/7z")) { 
        Write-Host "7-Zip needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return
    }
    Set-Alias sz "7z"

    #Lets Check if the user has Curl Installed
    if (-not (test-path "/usr/bin/curl")) { 
        Write-Host "Curl needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return
    }
    Set-Alias cl "curl"

}
elseif ($IsWindows) {
    if (test-path "$env:ProgramFiles\7-Zip\7z.exe") {
        Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"
    }
    elseif (test-path "$env:USERPROFILE/scoop/apps/7zip/current/7z.exe") {
        Set-Alias sz "$env:USERPROFILE/scoop/apps/7zip/current/7z.exe"
    }
    else {
        Write-Host "7-Zip needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return 
    }

    #Lets Check if the user has Curl Installed
    if (-not (test-path "C:\Windows\System32\curl.exe")) {
        Set-Alias cl "C:\Windows\System32\curl.exe"
    }
    elseif (test-path "$env:USERPROFILE/scoop/apps/curl/current/bin/curl.exe") {
        Set-Alias cl "$env:USERPROFILE/scoop/apps/curl/current/bin/curl.exe"
    }
    else {
        Write-Host "cURL needed to use the ModpackUploader."
        #If Program is NOT installed stop the script
        return 
    }
}

if ($ENABLE_CURSE_CLIENT_MODULE) {
    #Lets Check if the user has Twitch Export Builder Installed
    if ($IsLinux) {
        if (!(Test-Path ./tools/TwitchExportBuilder) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        	Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Downloading Twitch Export Builder..." -ForegroundColor Green
            Write-Host ""
            Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            #Lets remove the existing copy and grab a fresh copy
            Remove-Item ./TwitchExportBuilder -Recurse -Force -ErrorAction SilentlyContinue
            Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file ./$TwitchExportBuilderDLLinux
            New-Item "./tools" -ItemType "directory" -Force -ErrorAction SilentlyContinue
            Move-Item -Path "$TwitchExportBuilderDLLinux" -Destination ./tools/TwitchExportBuilder -ErrorAction SilentlyContinue
            #Lets also mark it executable
            chmod +x ./TwitchExportBuilder
        }
    }
    if ($IsMacOS) {
        if (!(Test-Path ./tools/TwitchExportBuilder) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        	Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Downloading Twitch Export Builder..." -ForegroundColor Green
            Write-Host ""
            Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            #Lets remove the existing copy and grab a fresh copy
            Remove-Item ./TwitchExportBuilder -Recurse -Force -ErrorAction SilentlyContinue
            Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file ./$TwitchExportBuilderDLMac
            New-Item "./tools" -ItemType "directory" -Force -ErrorAction SilentlyContinue
            Move-Item -Path "$TwitchExportBuilderDLMac" -Destination ./tools/TwitchExportBuilder -ErrorAction SilentlyContinue
            #Lets also mark it executable
            chmod +x ./tools/TwitchExportBuilder
        }
    }
    elseif ($IsLinux) {
        if (!(Test-Path ./tools/TwitchExportBuilder) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        	Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Downloading Twitch Export Builder..." -ForegroundColor Green
            Write-Host ""
            Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            #Lets remove the existing copy and grab a fresh copy
            Remove-Item ./TwitchExportBuilder -Recurse -Force -ErrorAction SilentlyContinue
            Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file ./$TwitchExportBuilderDLLinux
            New-Item "./tools" -ItemType "directory" -Force -ErrorAction SilentlyContinue
            Move-Item -Path "$TwitchExportBuilderDLLinux" -Destination ./tools/TwitchExportBuilder -ErrorAction SilentlyContinue
            #Lets also mark it executable
            chmod +x ./tools/TwitchExportBuilder
        }
    }
    elseif ($IsWindows) {
        if (!(Test-Path ./tools/TwitchExportBuilder.exe) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        	Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Downloading Twitch Export Builder..." -ForegroundColor Green
            Write-Host ""
            Write-Host "######################################" -ForegroundColor Cyan
            Write-Host ""
            #Lets remove the existing copy and grab a fresh copy
            Remove-Item TwitchExportBuilder.exe -Recurse -Force -ErrorAction SilentlyContinue
            Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file $TwitchExportBuilderDLWindows
            New-Item "./tools" -ItemType directory -Force -ErrorAction SilentlyContinue
            Move-Item -Path "$TwitchExportBuilderDLWindows" -Destination ./tools/TwitchExportBuilder.exe -ErrorAction SilentlyContinue
        }
    }
    Clear-SleepHost
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Compressing Client Files..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    #Lets remove the existing copy of the same version incase it exists due to failed attempts
    Remove-Item "$CLIENT_ZIP_NAME.zip" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "tmp" -Recurse -Force -ErrorAction SilentlyContinue
    if ($IsLinux -or $IsMacOS) {
        #Lets compile the Curse Manifest
        ./tools/TwitchExportBuilder -n "$CLIENT_NAME" -p "$MODPACK_VERSION"
    }
    elseif ($IsWindows) {
        #Lets compile the Curse Manifest
        ./tools/TwitchExportBuilder.exe -n "$CLIENT_NAME" -p "$MODPACK_VERSION"
    }
    #Now lets rename it to the name you selected in the settings.ps1
    Rename-Item -Path "$CLIENT_NAME-$MODPACK_VERSION.zip" -NewName "$CLIENT_ZIP_NAME.zip" -ErrorAction SilentlyContinue
    
    #Nows lets extract the manifest.json from the ZIP for proper version controlling.
    Remove-Item mods.json -Force -ErrorAction SilentlyContinue
    sz e -bd "$CLIENT_ZIP_NAME.zip" manifest.json
    Rename-Item -Path manifest.json -NewName mods.json -Force -ErrorAction SilentlyContinue
    Remove-Item "tmp" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-SleepHost
}

if ($ENABLE_CHANGELOG_GENERATOR_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {
    if (!(Test-Path "./tools/ChangelogGenerator.jar") -or $ENABLE_ALWAYS_UPDATE_JARS) {
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Downloading Modpack Chanelog Generator..." -ForegroundColor Green
        Write-Host ""
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Remove-Item ChangelogGenerator.jar -Recurse -ErrorAction SilentlyContinue
        New-Item "./tools" -ItemType "directory" -Force -ErrorAction SilentlyContinue
        Download-GithubRelease -repo "TheRandomLabs/ChangelogGenerator" -file $ChangelogGeneratorDL
        Move-Item -Path "$ChangelogGeneratorDL" -Destination ./tools/ChangelogGenerator.jar -ErrorAction SilentlyContinue
    }
    #Lets Extract the old manifest from the previous version of the modpack
    #Lets also use the current mods.json manifest for the changelog compilation as well
    Clear-SleepHost
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Generating changelog..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    #now lets make the changelog
    New-Item "./changelog" -ItemType "directory" -Force -ErrorAction SilentlyContinue
    java -jar tools/ChangelogGenerator.jar -m -n "$CLIENT_ZIP_NAME.zip" -o "$LAST_CLIENT_ZIP_NAME.zip" -O "./changelog/$MODPACK_VERSION.md"
}

if ($ENABLE_GITHUB_CHANGELOG_GENERATOR_MODULE) {

    $BASE64TOKEN = [System.Convert]::ToBase64String([char[]]$GITHUB_TOKEN);
    $Uri = "https://api.github.com/repos/$GITHUB_NAME/$GITHUB_REPOSITORY/releases?access_token=$GITHUB_TOKEN"

    $Headers = @{
        Authorization = 'Basic {0}' -f $Base64Token;
    };

    $Body = @{
        tag_name         = $MODPACK_VERSION;
        target_commitish = 'master';
        name             = $MODPACK_VERSION;
        body             = $CLIENT_CHANGELOG;
        draft            = $false;
        prerelease       = $false;
    } | ConvertTo-Json;

    Clear-SleepHost
    if ($ENABLE_EXTRA_LOGGING) {
        Write-Host "Release Data:"
        Write-Host $Body
    }

    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Making GitHub Release..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Headers $Headers -Uri $Uri -Body $Body -Method Post

    Start-Process Powershell.exe -Argument "-NoProfile -Command github_changelog_generator --since-tag $CHANGES_SINCE_VERSION"
}

if ($ENABLE_MODPACK_UPLOADER_MODULE) {


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
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    $Response = cl --url "https://minecraft.curseforge.com/api/projects/$CURSEFORGE_PROJECT_ID/upload-file" --user "$CURSEFORGE_USER`:$CURSEFORGE_TOKEN" -H "Accept: application/json" -H X-Api-Token:$CURSEFORGE_TOKEN -F metadata=$CLIENT_METADATA -F file=@"$CLIENT_ZIP_NAME.zip" --progress-bar | ConvertFrom-Json
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

if ($ENABLE_SERVER_FILE_MODULE) {
    Clear-SleepHost
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Compressing Server files..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""

    Remove-Item "tmp" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "server/" -Destination "tmp" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path $SERVER_CONTENTS_TO_ZIP -Destination "tmp" -Recurse -Force -ErrorAction SilentlyContinue

    Remove-Item "Server.zip" -Recurse -Force -ErrorAction SilentlyContinue
    sz a -tzip "Server.zip" $SERVER_CONTENTS_TO_ZIP
    Remove-Item "$SERVER_ZIP_NAME.zip" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Removing Client Mods from Server Files" -ForegroundColor Cyan
    foreach ($clientMod in $CLIENT_MODS_TO_REMOVE_FROM_SERVER_FILES) {
        Write-Host "Removing Client Mod $clientMod"
        sz d Server.zip "mods/$clientMod*" | Out-Null
    }

    Rename-Item -Path Server.zip -NewName "$SERVER_ZIP_NAME.zip"
    Remove-Item "tmp" -Recurse -Force -ErrorAction SilentlyContinue

    Start-Sleep 3
}


if ($ENABLE_SERVER_FILE_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {

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
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    $SERVER_UPLOAD_ZIP = "$SERVER_ZIP_NAME.zip"
    $ResponseServer = cl --url "https://minecraft.curseforge.com/api/projects/$CURSEFORGE_PROJECT_ID/upload-file" --user "$CURSEFORGE_USER`:$CURSEFORGE_TOKEN" -H "Accept: application/json" -H X-Api-Token:$CURSEFORGE_TOKEN -F metadata=$SERVER_METADATA -F file=@$SERVER_UPLOAD_ZIP --progress-bar
}

Clear-SleepHost

Write-Host "######################################" -ForegroundColor Cyan
Write-Host ""
Write-Host "The Modpack Uploader has completed." -ForegroundColor Green
Write-Host ""
Write-Host "######################################" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 5