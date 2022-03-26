# ⏫ Modpack Uploader

Modpack Uploader is a script that can automatically upload modpacks to CurseForge.

Almost everything can be toggled on/off in the settings.

# 🚧 Getting Started

1. Download the latest release, and unzip it into your modpack instance.
   - You can place it in a subfolder, but you need to change the `$INSTANCE_ROOT` in the `settings.ps1` file.
2. Fill in the `settings.ps1` file with your modpack information.
3. Fill in the `secrets.ps1` file with your CurseForge Upload API Token.
4. Run the `modpack-uploader.ps1` when you're ready to upload your modpack.

# ✔️Features

- Client ZIP file creation and upload with the `CLIENT_FILE_MODULE` and `MODPACK_UPLOADER_MODULE` ✔️ On by default
- Server ZIP file creation and upload with the `SERVER_FILE_MODULE` and `MODPACK_UPLOADER_MODULE` ✔️ On by default
- Automatic updating of `modpackUrl` in ServerStarter's `server-setup-config.yaml` ❌ _Off by default_
- Grab the changelogs of all the mods updated in your new release with the `CHANGELOG_GENERATOR_MODULE` ❌ _Off by default_
- Make a modlist complete with links to the mods and authors with the `MODLIST_CREATOR_MODULE` ✔️ _On by default_
- Make a new GitHub release when you upload your modpack with the `GITHUB_RELEASE_MODULE` ❌ _Off by default_

# ➕ Dependencies

- [cURL](https://curl.haxx.se/download.html)
- [7-Zip](https://www.7-zip.org/download.html)
- [PowerShell](https://docs.microsoft.com/en-us/powershell/)
  - Windows comes with Powershell pre-installed.
  - [Linux Download Instructions](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux)
  - [Mac Download Instructions](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

# ❤️ Special Thanks

- [TheRandomLabs](https://github.com/TheRandomLabs), for their [Changelog Generator](https://github.com/TheRandomLabs/ChangelogGenerator), which allows this project to incoorperate the changelogs of the mods that are updated.

- [CrankySupertoon](https://github.com/CrankySupertoon), for her help in improving this tool while making it easier to use.

- [ModdingX](https://github.com/ModdingX) for their project [Modlist Creator](https://github.com/ModdingX/ModListCreator), which allows this project to create nice looking modlists.
