# Modpack Uploader

Modpack Uploader is a tool designed to automate uploading of modpacks to CurseForge.

It creates a modpack manifest, which is then posted along with metadata to CurseForge for upload.
When the upload has completed, server files are attached which are generated from the tool.

Almost everything can be toggled on/off in the settings.

## Getting Started

1. Download the latest release, and unzip into your modpack instance.
   - You can place it in a subfolder, but you need to change the `$INSTANCE_ROOT` in the `settings.ps1` file.
2. Fill in the `settings.ps1` file with your modpack information.
3. Fill in the `secrets.ps1` file with your CurseForge Upload API Token.
4. Run the `modpack-uploader.ps1` when you're ready to upload your modpack.

## Dependencies

- [cURL](https://curl.haxx.se/download.html)
- [7-Zip](https://www.7-zip.org/download.html)
- [PowerShell](https://docs.microsoft.com/en-us/powershell/)
  - Windows comes with Powershell pre-installed.
  - [Linux Download Instructions](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux)
  - [Mac Download Instructions](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

### Credits

A big thanks goes out to:

[TheRandomLabs](https://github.com/TheRandomLabs), for their [Changelog Generator](https://github.com/TheRandomLabs/ChangelogGenerator), which allows this project to incoorperate the changelogs of the mods that are updated.

[CrankySupertoon](https://github.com/CrankySupertoon), for her help in improving this tool while making it easier to use.

[ModdingX](https://github.com/ModdingX) for their project [Modlist Creator](https://github.com/ModdingX/ModListCreator), which allows this project to create nice looking modlists.
