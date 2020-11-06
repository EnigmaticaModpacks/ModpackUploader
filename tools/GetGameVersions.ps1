Set-Location ".."
. ./settings.ps1

curl -H X-Api-Token:$CURSEFORGE_TOKEN https://minecraft.curseforge.com/api/game/versions >> GameVersions.json
