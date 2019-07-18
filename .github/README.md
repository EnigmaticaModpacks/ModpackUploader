# ModpackUploader

This tool can automate the process of uploading modpacks to Curseforge.
It creates a modpack manifest, which is then posted along with metadata to Curseforge for upload.
When the upload has completed, server files are attached. 
The server files are automatically generated from files/folders you specify.

Almost everything can be toggled on/off in the settings.

## Usage
* Unzip the file into your modded Minecraft Instance.
* Fill in the .build.json file with appropriate information - This specifies the manifest information. The mods folder is automatically included.
* Fill in the settings.ps1 file.
* Double-click the ModpackUploader.bat or ModpackUploader.sh

## Dependencies
* cURL - https://curl.haxx.se/download.html
* 7-Zip - https://www.7-zip.org/download.html

## Linux
* Linux users need to download a specific version of the Twitch Export Builder. Rename it to "TwitchExportBuilder.exe".
    Find it here: https://github.com/Gaz492/twitch-export-builder/releases/

* Linux users need Powershell Core to run Powershell scripts.
    Find it here: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6

* The setting ENABLE_ALWAYS_UPDATE_JARS only works on Windows.
### Credits
A huge thanks goes out to Gaz492 for his Twitch Export Builder project, which made this tool possible.

https://github.com/Gaz492/twitch-export-builder/
