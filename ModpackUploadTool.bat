@ECHO OFF
SET PATH=%PATH%;C:\Program Files\7-Zip\

:: Load Settings from config
ECHO Loading variables from modpack_upload_settings.cfg
for /f "delims==; tokens=1,2 eol=;" %%G in (modpack_upload_settings.cfg) do set %%G=%%H

:: Create manifest
ECHO Making manifest...
twitch_export-win.exe -d "%cd%" -n "%CLIENT_FILENAME%" -p "%MODPACK_VERSION%" -c "%cd%/.build.json" -ct "%CURSEFORGE_TOKEN%"

ECHO Setting up metadata for uploading...
SET CLIENT_METADATA="{'changelog': '%CLIENT_CHANGELOG%','changelogType': '%CLIENT_CHANGELOG_TYPE%','displayName': '%CLIENT_FILE_DISPLAY_NAME%','gameVersions': %GAME_VERSIONS%,'releaseType': '%CLIENT_RELEASE_TYPE%'}"
ECHO Uploading Modpack to https://minecraft.curseforge.com/api/projects/%CURSEFORGE_PROJECT_ID%/upload-file
curl --user %USER%:%CURSEFORGE_TOKEN% -H "Accept: application/json" -H X-Api-Token:%CURSEFORGE_TOKEN% -F metadata=%CLIENT_METADATA% -F file=@%CLIENT_FILENAME%-%MODPACK_VERSION%.zip https://minecraft.curseforge.com/api/projects/%CURSEFORGE_PROJECT_ID%/upload-file >> ModpackFileId.json

SET /p FILE_ID=<ModpackFileId.json
:: Extracting ID from JSON
SET FILE_ID=%FILE_ID:{"id":=%
SET FILE_ID=%FILE_ID:}=%
CALL :TRIM %FILE_ID% FILE_ID
ECHO ID Returned: %FILE_ID%
DEL ModpackFileId.json

:: Create server files
ECHO Making server files...
7z a -tzip %SERVER_FILENAME%-%MODPACK_VERSION%.zip %CONTENTS_TO_ZIP%

:: Uploading Server Files...
ECHO Setting up metadata for uploading...
SET SERVER_METADATA="{'changelog': '%SERVER_CHANGELOG%','changelogType': '%SERVER_CHANGELOG_TYPE%','displayName': '%SERVER_FILE_DISPLAY_NAME%','parentFileId': %FILE_ID%,'releaseType': '%SERVER_RELEASE_TYPE%'}"
ECHO Uploading Modpack to https://minecraft.curseforge.com/api/projects/%CURSEFORGE_PROJECT_ID%/upload-file
curl --user %USER%:%CURSEFORGE_TOKEN% -H "Accept: application/json" -H X-Api-Token:%CURSEFORGE_TOKEN% -F metadata=%SERVER_METADATA% -F file=@%SERVER_FILENAME%-%MODPACK_VERSION%.zip https://minecraft.curseforge.com/api/projects/%CURSEFORGE_PROJECT_ID%/upload-file >> ModpackFileId.json

ECHO The Modpack Uploader Tool has finished.
PAUSE

:: Function used to TRIM the JSON output of the POST request
:TRIM
SET %2=%1
GOTO :EOF