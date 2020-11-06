# Settings for the ModpackUploader
# For details/help see: https://github.com/NillerMedDild/ModpackUploader

# =====================================================================//
#  CURSEFORGE SETTINGS
# =====================================================================//

$CURSEFORGE_USER = "MyUserName"

# For details see: https://www.curseforge.com/account/api-tokens
$CURSEFORGE_TOKEN = "1111111"

# ProjectID can be found on the modpack's Curseforge Projects page, under "About This Project"
$CURSEFORGE_PROJECT_ID = 999999

#=====================================================================//
#  DEPENDENCIES URL
#=====================================================================//

# File name of the latest https://github.com/Gaz492/twitch-export-builder/releases
$TwitchExportBuilderDLWindows = "twitch-export-builder_windows_amd64.exe"
$TwitchExportBuilderDLLinux = "twitch-export-builder_linux_amd64"


# File name of the latest https://github.com/TheRandomLabs/ChangelogGenerator/releases
$ChangelogGeneratorDL = "ChangelogGenerator-2.0.0-pre3.jar"

# =====================================================================//
#  MODPACK & CLIENT FILE SETTINGS
# =====================================================================//

# Version Of The Modpack
$MODPACK_VERSION = "1.0.1"

# Name of the Modpack in the ZIP File
$CLIENT_NAME = "MyModpack"
$CLIENT_ZIP_NAME = "$CLIENT_NAME-$MODPACK_VERSION"

# Last Version Of The Modpack
# Needed For Changelog Parsing
$LAST_MODPACK_VERSION = "1.0.0"
$LAST_MODPACK_ZIP_NAME = "$CLIENT_NAME-$LAST_MODPACK_VERSION"

# Modpacks Forge Version: 
# Default: "14.23.5.2854"
$FORGE_VERSION=14.23.5.2854

# Display Name of the Modpack on CurseForge
# Default: "$CLIENT_FANCY_NAME $MODPACK_VERSION"
$CLIENT_FANCY_NAME = "My Modpack"
$CLIENT_FILE_DISPLAY_NAME = "$CLIENT_FANCY_NAME $MODPACK_VERSION"

# An array of compatible game versions of Minecraft.
# See GameVersions.json for possible versions.
# @(6756) - is Minecraft 1.12.2
# @(7722) - is Minecraft 1.15.2
$GAME_VERSIONS = @(6756)

# Can be "markdown", "text" or "html"
$CLIENT_CHANGELOG_TYPE = "html"

# Must be a single string. Use Powershell escaping for new lines etc. New line is `n and indent is `t
$CLIENT_CHANGELOG = "Empty"

# Can be "alpha", "beta" or "release"
$CLIENT_RELEASE_TYPE = "alpha"

#=====================================================================//
#  SERVER FILE SETTINGS
#=====================================================================//

# In the format @("filename", "filename")
$CLIENT_MODS_TO_REMOVE_FROM_SERVER_FILES = @()

# Default: "$CLIENT_FILENAME Server $MODPACK_VERSION"
$SERVER_ZIP_NAME = "$CLIENT_NAME-Server-$MODPACK_VERSION"

# Default: $SERVER_FILENAME
$SERVER_FILE_DISPLAY_NAME = "$CLIENT_FANCY_NAME Server $MODPACK_VERSION"

# A continuous line of the folders and files (with extensions) to zip into Server Files.
# Default: @("mods", "config")
$CONTENTS_TO_ZIP = @("mods", "config")

# Can be "markdown", "text" or "html"
# Default: $CLIENT_CHANGELOG_TYPE
$SERVER_CHANGELOG_TYPE = $CLIENT_CHANGELOG_TYPE

# Must be a single string. Use Powershell escaping for new lines etc. New line is `n and indent is `t
# Default: $CLIENT_CHANGELOG
$SERVER_CHANGELOG = $CLIENT_CHANGELOG

# Can be "alpha", "beta" or "release"
# Default: $CLIENT_RELEASE_TYPE
$SERVER_RELEASE_TYPE = $CLIENT_RELEASE_TYPE

# =====================================================================//
#  MODULES
# =====================================================================//

# Toggle twitch-export-builder (automatic building of the manifest zip) on/off
# Default: $true
$ENABLE_MANIFEST_BUILDER_MODULE = $true

# Toggle the modpack uploader on/off
# Setting this to $false will also disable the Server File and Changelog Generator Modules.
# Default: $true
$ENABLE_MODPACK_UPLOADER_MODULE = $true

# Toggle server file feature on/off
# Default: $true
$ENABLE_SERVER_FILE_MODULE = $true

# Toggle automatic changelog generator on/off
# This module requires an older modpack manifest zip to be present, 
# Default: $false
$ENABLE_CHANGELOG_GENERATOR_MODULE=$true

# Toggle removal and re-download of jars on/off.	
# Setting this to true will ensure that you always have the latest 	
# Twitch Export Builder and ChangelogGenerator, but increases the	
# amount of time the script takes to finish.	
# Default: $false	
$ENABLE_ALWAYS_UPDATE_JARS = $false

# Toggles extra logging on/off.
# Recommended if you're having trouble making the Modpack Uploader
# work.
# Default: $false
$ENABLE_EXTRA_LOGGING = $false

# Toggles github changelog generator integration on/off.
# Requires extensive setup, this is an advanced step.
# See below link for info:
# https://github.com/github-changelog-generator/github-changelog-generator
# Default: $false
$ENABLE_GITHUB_CHANGELOG_GENERATOR_MODULE = $false
$GITHUB_NAME = "MyName"
$GITHUB_TOKEN = "$GITHUB_NAME`:MyToken"
$GITHUB_REPOSITORY = "MyRepo"
$CHANGES_SINCE_VERSION = "1.0.0"
