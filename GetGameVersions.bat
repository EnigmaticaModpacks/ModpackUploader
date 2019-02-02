@ECHO OFF

:: Load Settings from config
ECHO Loading variables from modpack_upload_settings.cfg
for /f "delims==; tokens=1,2 eol=;" %%G in (modpack_upload_settings.cfg) do set %%G=%%H

curl -H X-Api-Token:%CURSEFORGE_TOKEN% https://minecraft.curseforge.com/api/game/versions >> GameVersions.json