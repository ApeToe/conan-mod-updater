#!/bin/bash

# Check if running in Pterodactyl
if [ -z "${PTERO_USER}" ]; then
  # Running via Pterodactyl
  #MODS_LOCATION="/home/container/ConanSandbox/Mods"
  #INSTALL_DIR="/home/container"  # Modify this line if needed
  MODS_LOCATION="/var/lib/pterodactyl/volumes/12c24e3e-855f-4f08-8868-78747494b373/ConanSandbox/Mods"
  INSTALL_DIR="/var/lib/pterodactyl/volumes/12c24e3e-855f-4f08-8868-78747494b373"  # Modify this line with the desired installation path
else
  # Running manually
  MODS_LOCATION="/var/lib/pterodactyl/volumes/12c24e3e-855f-4f08-8868-78747494b373/ConanSandbox/Mods"
  INSTALL_DIR="/var/lib/pterodactyl/volumes/12c24e3e-855f-4f08-8868-78747494b373"  # Modify this line with the desired installation path
fi

# Progress bar function
function show_progress() {
  local current=$1
  local total=$2
  local width=50
  local progress=$((current * width / total))
  local percent=$((current * 100 / total))
  printf "["
  for ((i = 0; i < progress; i++)); do printf "#"; done
  for ((i = progress; i < width; i++)); do printf " "; done
  printf "] %3d%% (%d/%d)\r" $percent $current $total
}

# Rest of the script...

APPID_Mods=440900
MODS_IDS_FILE="$INSTALL_DIR/mods.txt"
MODS_MODLIST_FILE="$MODS_LOCATION/modlist.txt"

# DO NOT EDIT
INSTALL_MODS=""
TOTAL_MODS=0
CURRENT_MOD=0

while read modid; do
  INSTALL_MODS+="+workshop_download_item $APPID_Mods $modid "
  TOTAL_MODS=$((TOTAL_MODS + 1))
done < "$MODS_IDS_FILE"

if [ "$INSTALL_MODS" == "" ]; then
  echo "No mods detected. Skip."
else
  echo "Installing mods with $INSTALL_MODS"
  INSTALL_COMMAND="steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$INSTALL_DIR" +login anonymous $INSTALL_MODS+quit"
  echo "$INSTALL_COMMAND"
  eval "$INSTALL_COMMAND"

  # Remove existing files
  rm -rf "$MODS_LOCATION"/*

  # Copy mods and update modlist.txt
  while read modid; do
    if [ -d "$INSTALL_DIR/steamapps/workshop/content/$APPID_Mods/$modid" ]; then
      for filename in $(cd "$INSTALL_DIR/steamapps/workshop/content/$APPID_Mods/$modid" && find -name "*.pak"); do
        filename="$(basename "$filename")"
        modname="${filename%.*}"  # Extract the mod name without extension
        echo "Enabling Mod $modid. Adding pak-file for mod: '$modname.pak'"
        cp "$INSTALL_DIR/steamapps/workshop/content/$APPID_Mods/$modid/$filename" "$MODS_LOCATION/$modname.pak"
        echo "$modname.pak" >> "$MODS_MODLIST_FILE"
        CURRENT_MOD=$((CURRENT_MOD + 1))
        show_progress $CURRENT_MOD $TOTAL_MODS
      done
    fi
  done < "$MODS_IDS_FILE"

  echo ""
fi

# Check if the script ran successfully
if [ $? -eq 0 ]; then
  # Success
  echo -e "\n\u2714 Script ran successfully!"
  echo ""
else
  # Failure
  echo -e "\n\u2718 Script failed!"
  echo ""
fi

# Pause for 2 seconds to see the result
sleep 2
