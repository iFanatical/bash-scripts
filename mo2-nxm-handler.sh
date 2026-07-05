#!/usr/bin/env bash
STEAM_COMPAT_DATA_PATH="/drives/wd-sn570/SteamLibrary/steamapps/compatdata/489830"
STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
PROTON="$HOME/.steam/steam/compatibilitytools.d/GE-Proton10-34/proton"
MO2_EXE="/drives/wd-sn570/skyrim-modding/MO2/nxmhandler.exe"

export STEAM_COMPAT_DATA_PATH
export STEAM_COMPAT_CLIENT_INSTALL_PATH
export STEAM_COMPAT_APP_ID=489830
export SteamAppId=489830
export SteamGameId=489830

"$PROTON" run "$MO2_EXE" "$1"
