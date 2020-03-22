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

if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed to use the ModpackUploader."} 
    Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (test-path "$env:C:\Windows\System32\curl.exe")) {throw "$env:Windows\System32\curl.exe needed to use the ModpackUploader."} 
    Set-Alias cl "$env:C:\Windows\System32\curl.exe"

if ($ENABLE_MANIFEST_BUILDER_MODULE) {
    if (!(Test-Path TwitchExportBuilder.exe) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Downloading Twitch Export Builder..." -ForegroundColor Green
        Write-Host ""
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Remove-Item TwitchExportBuilder.exe -Recurse -Force -ErrorAction SilentlyContinue
        Download-GithubRelease -repo "Gaz492/twitch-export-builder" -file $TwitchExportBuilderDL	
		Rename-Item -Path $TwitchExportBuilderDL -NewName TwitchExportBuilder.exe -ErrorAction SilentlyContinue	
    }
    Clear-SleepHost
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Compressing Client Files..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Remove-Item "$CLIENT_ZIP_NAME.zip" -Recurse -Force -ErrorAction SilentlyContinue
    .\TwitchExportBuilder.exe -n "$CLIENT_NAME" -p "$MODPACK_VERSION"
	Rename-Item -Path "$CLIENT_NAME-$MODPACK_VERSION.zip" -NewName "$CLIENT_ZIP_NAME.zip" -ErrorAction SilentlyContinue
    Clear-SleepHost
}

if ($ENABLE_CHANGELOG_GENERATOR_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {
    if (!(Test-Path ChangelogGenerator.jar) -or $ENABLE_ALWAYS_UPDATE_JARS) {
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Downloading Modpack Chanelog Generator..." -ForegroundColor Green
        Write-Host ""
        Write-Host "######################################" -ForegroundColor Cyan
        Write-Host ""
        Remove-Item ChangelogGenerator.jar -Recurse -ErrorAction SilentlyContinue
        Download-GithubRelease -repo "TheRandomLabs/ChangelogGenerator" -file $ChangelogGeneratorDL
		Rename-Item -Path $ChangelogGeneratorDL -NewName ChangelogGenerator.jar -ErrorAction SilentlyContinue
    }
    Remove-Item old.json, new.json, shortchangelog.txt, MOD_CHANGELOGS.txt -ErrorAction SilentlyContinue
    sz e -bd "$LAST_MODPACK_ZIP_NAME.zip" manifest.json
    Rename-Item -Path manifest.json -NewName old.json
    sz e -bd "$CLIENT_ZIP_NAME.zip" manifest.json
    Rename-Item -Path manifest.json -NewName new.json
    Clear-SleepHost
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Generating changelog..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    java -jar ChangelogGenerator.jar
    Remove-Item MOD_CHANGELOGS.txt -Recurse -Force -ErrorAction SilentlyContinue
    Rename-Item -Path changelog.txt -NewName MOD_CHANGELOGS.txt
}

if ($ENABLE_GITHUB_CHANGELOG_GENERATOR_MODULE) {

    $BASE64TOKEN = [System.Convert]::ToBase64String([char[]]$GITHUB_TOKEN);
    $Uri = "https://api.github.com/repos/$GITHUB_NAME/$GITHUB_REPOSITORY/releases?access_token=$GITHUB_TOKEN"

    $Headers = @{
        Authorization = 'Basic {0}' -f $Base64Token;
    };

    $Body = @{
        tag_name = $MODPACK_VERSION;
        target_commitish = 'master';
        name = $MODPACK_VERSION;
        body = $CLIENT_CHANGELOG;
        draft = $false;
        prerelease = $false;
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

if ($ENABLE_SERVER_FILE_MODULE -and $ENABLE_MODPACK_UPLOADER_MODULE) {
    Clear-SleepHost
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Compressing Server files..." -ForegroundColor Green
    Write-Host ""
    Write-Host "######################################" -ForegroundColor Cyan
    Write-Host ""

    Remove-Item "Server.zip" -Recurse -Force -ErrorAction SilentlyContinue
    sz a -tzip "Server.zip" $CONTENTS_TO_ZIP
    Remove-Item "$SERVER_ZIP_NAME.zip" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Removing Client Mods from Server Files" -ForegroundColor Cyan
    foreach ($clientMod in $CLIENT_MODS_TO_REMOVE_FROM_SERVER_FILES) {
        Write-Host "Removing Client Mod $clientMod"
        sz d Server.zip "mods/$clientMod*" | Out-Null
    }
    Rename-Item -Path Server.zip -NewName "$SERVER_ZIP_NAME.zip"
    
    Start-Sleep 3

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