# Modpack Uploader

Modpack Uploader is a Suite of Tools for Modpack Developers.

These tools can automate the process of uploading modpacks to CurseForge.
It creates a modpack manifest, which is then posted along with metadata to Curseforge for upload.
When the upload has completed, server files are attached which are generated from the tool.

It's possible to integrate [Github Changelog Generator](https://github.com/github-changelog-generator/github-changelog-generator) and [Changelog Generator for mods](https://github.com/TheRandomLabs/ChangelogGenerator) by toggling them in the settings, and configuring them.

Additionally this tool can fill the mods folder with mods from an exported instance, to make working through Git easier.

Almost everything can be toggled on/off in the settings.

## Usage
1. Clone the project into your Modded Minecraft Instance.
2. Fill in the .build.json file with appropriate information - This specifies the manifest information. The mods folder is automatically included.
3. Fill in the settings.ps1 file with appropriate information. Don't forget your token however.
4. Double-click the ModpackUploader script or start ModpackUploader.ps1 using the command line.
## Dependencies
* [cURL](https://curl.haxx.se/download.html)
* [7-Zip](https://www.7-zip.org/download.html)

### Credits
A big thanks goes out to:

[Gaz492](https://github.com/Gaz492/), for their
[Twitch Export Builder](https://github.com/Gaz492/twitch-export-builder/) project, which made the uploading of modpacks to CurseForge possible.

[Nincraft](https://github.com/Nincraft), for their [ModPack Downloader](https://github.com/Nincraft/ModPackDownloader), which made the downloading of mods in a workspace possible.

[TheRandomLabs](https://github.com/TheRandomLabs), for their [Changelog Generator](https://github.com/TheRandomLabs/ChangelogGenerator), which greatly improves this tool.

[CrankySupertoon](https://github.com/CrankySupertoon), for her help in improving this tool while making it easier to use.