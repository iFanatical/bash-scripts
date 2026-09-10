#!/usr/bin/env bash
STEAM_COMPAT_DATA_PATH="/drives/crucial-mx300/SteamLibrary/steamapps/compatdata/489830"
STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
PROTON="$HOME/.steam/steam/compatibilitytools.d/GE-Proton11-1/proton"
VORTEX_EXE="/drives/crucial-mx300/SteamLibrary/steamapps/compatdata/489830/pfx/drive_c/Program Files/Vortex/Vortex.exe"
#VORTEX_EXE="/drives/crucial-mx300/modding-tools/vortex-setup-2.5.0.exe"

export STEAM_COMPAT_DATA_PATH
export STEAM_COMPAT_CLIENT_INSTALL_PATH
export STEAM_COMPAT_APP_ID=489830
export SteamAppId=489830
export SteamGameId=489830
export BROWSER=/usr/bin/brave-origin-nightly

"$PROTON" run "$VORTEX_EXE"
