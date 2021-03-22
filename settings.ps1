# Settings for the ModpackUploader
# For details/help see: https://github.com/NillerMedDild/ModpackUploader

# =====================================================================//
#  CURSEFORGE ACCOUNT SETTINGS
# =====================================================================//

$CURSEFORGE_USER = "MyUserName"

# ProjectID can be found on the modpack's Curseforge Projects page, under "About This Project"
$CURSEFORGE_PROJECT_ID = 999999


#=====================================================================//
#  DEPENDENCIES URL
#=====================================================================//

# File name of the latest https://github.com/Gaz492/twitch-export-builder/releases
$TwitchExportBuilderDLWindows = "twitch-export-builder_windows_amd64.exe"
$TwitchExportBuilderDLLinux = "twitch-export-builder_linux_amd64"
$TwitchExportBuilderDLMac = "twitch-export-builder_darwin_amd64"

# File name of the latest https://github.com/TheRandomLabs/ChangelogGenerator/releases
$ChangelogGeneratorDL = "ChangelogGenerator-2.0.0-pre10.jar"

# File name of the latest https://github.com/CrankySupertoon/ModPackDownloader/releases
$ModpackDownloaderDL = "ModpackDownloader-cli-0.6.1.jar"

# =====================================================================//
#  MAIN MODPACK SETTINGS
# =====================================================================//

# This is the Pack Name
$CLIENT_FANCY_NAME = "My Modpack"

# Name of the Modpack in the ZIP File
$CLIENT_NAME = "MyModpack"

# Version Of The Modpack
$MODPACK_VERSION = "1.0.1"

# Last Version Of The Modpack
# Needed For Changelog Parsing
$LAST_MODPACK_VERSION = "1.0.0"

# Modpacks Forge Version:
# Default: "14.23.5.2854"
$FORGE_VERSION=14.23.5.2854


# =====================================================================//
#  CHANGELOG SETTINGS
# =====================================================================//

# Changelog Type
# Can be "markdown", "text" or "html"
$CLIENT_CHANGELOG_TYPE = "html"

# Changelog
# Must be a single string. Use Powershell escaping for new lines etc. New line is `n and indent is `t
$CLIENT_CHANGELOG = "Empty"


# =====================================================================//
#  CURSEFORGE PROJECT SETTINGS
# =====================================================================//

# Modpack's Minecraft Version
# @(6756) - is Minecraft 1.12.2
# @(7722) - is Minecraft 1.15.2
# @(8134) - is Minecraft 1.16.4
# More can be found by running GetGameVersions
$GAME_VERSIONS = @(6756)

# Can be "alpha", "beta" or "release"
$CLIENT_RELEASE_TYPE = "alpha"


#=====================================================================//
#  CLIENT FILE SETTINGS
#=====================================================================//

# All of these are defined in .build.json. # Sorry for the inconvience.


#=====================================================================//
#  SERVER FILE SETTINGS
#=====================================================================//

# List of Mods to remove for the Server
# In the format @("filename", "filename")
$CLIENT_MODS_TO_REMOVE_FROM_SERVER_FILES = @()

# A continuous line of the folders and files (with extensions) to zip into Server Files.
# Default: @("mods", "config")
$CONTENTS_TO_ZIP = @("mods", "config")

# =====================================================================//
#  MODULES
# =====================================================================//

# Toggles CurseForge Client Files Generation
# Default: $true
$ENABLE_CURSE_CLIENT_MODULE = $true

# Toggles Modpack Uploading to CurseForge
# Setting this to $false will also disable the Server File and Changelog Generator Modules.
# Default: $true
$ENABLE_MODPACK_UPLOADER_MODULE = $true

# Toggles Server Files
# Default: $true
$ENABLE_SERVER_FILE_MODULE = $true

# Toggles Changelog Generstion. This Reauires an Older Version of the Pack
# Default: $false
$ENABLE_CHANGELOG_GENERATOR_MODULE=$false

# Toggles the Redwonloadment or Thrid Party Dependencies Every Time you Conpile the Pack
# Default: $false
$ENABLE_ALWAYS_UPDATE_JARS = $false

# Toggles Extra Logging on/off.
# Default: $false
$ENABLE_EXTRA_LOGGING = $false

# Toggles GitHub Changelog Generator integration on/off.
# Requires extensive setup, this is an advanced step.
# See below link for info:
# https://github.com/github-changelog-generator/github-changelog-generator
# Default: $false
$ENABLE_GITHUB_CHANGELOG_GENERATOR_MODULE = $false
$GITHUB_NAME = "MyName"
$GITHUB_TOKEN = "$GITHUB_NAME`:MyToken"
$GITHUB_REPOSITORY = "MyRepo"
$CHANGES_SINCE_VERSION = "1.0.0"

# =====================================================================//
#  ADVANCED
#  Do not change anything unless you
#  know what you are doing!
# =====================================================================//

# Syntax of the Client ZIP File
$CLIENT_ZIP_NAME = "$CLIENT_NAME-$MODPACK_VERSION"

# Syntax of the Previous Versions Client ZIP File
$LAST_MODPACK_ZIP_NAME = "$CLIENT_NAME-$LAST_MODPACK_VERSION"

# Syntax of the Display name on CurseForge
$CLIENT_FILE_DISPLAY_NAME = "$CLIENT_FANCY_NAME $MODPACK_VERSION"

# ZIP Name for the Server Files
# This reads the values above and ammends server onto it.
$SERVER_ZIP_NAME = "$CLIENT_NAME-Server-$MODPACK_VERSION"

# Display Name for the Server Files
# This reads the values above and ammends server onto it.
$SERVER_FILE_DISPLAY_NAME = "$CLIENT_FANCY_NAME Server $MODPACK_VERSION"

# Can be "markdown", "text" or "html"
# Default: $CLIENT_CHANGELOG_TYPE
$SERVER_CHANGELOG_TYPE = $CLIENT_CHANGELOG_TYPE

# Changelog for the Server
# Must be a single string. Use Powershell escaping for new lines etc. New line is `n and indent is `t
# Default: $CLIENT_CHANGELOG
$SERVER_CHANGELOG = $CLIENT_CHANGELOG

# Release Type for Server Files on CurseForge
# Can be "alpha", "beta" or "release"
$SERVER_RELEASE_TYPE = $CLIENT_RELEASE_TYPE
