. ./secrets.ps1

curl -H X-Api-Token:$CURSEFORGE_TOKEN https://minecraft.curseforge.com/api/game/versions >> game-versions.json
