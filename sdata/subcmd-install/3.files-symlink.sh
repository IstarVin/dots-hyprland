# This script is meant to be sourced.
# It creates symlinks instead of copying files
# Usage: Set INSTALL_MODE=symlink before sourcing 3.files.sh

# shellcheck shell=bash

function symlink_dir_s_t(){
  local s=$1
  local t=$2

  if [ -L "$t" ]; then
    echo -e "${STY_BLUE}[$0]: \"$t\" is already a symlink.${STY_RST}"
    local current_target=$(readlink "$t")
    if [ "$current_target" = "$s" ]; then
      echo -e "${STY_GREEN}[$0]: Symlink already points to correct location.${STY_RST}"
    else
      echo -e "${STY_YELLOW}[$0]: Symlink points to different location: $current_target${STY_RST}"
      v rm "$t"
      v ln -sf "$s" "$t"
    fi
  elif [ -d "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists as a directory. Backing up and creating symlink.${STY_RST}"
    v mv "$t" "$t.backup-$(date +%Y%m%d-%H%M%S)"
    v ln -sf "$s" "$t"
  elif [ -e "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists as a file. Backing up and creating symlink.${STY_RST}"
    v mv "$t" "$t.backup-$(date +%Y%m%d-%H%M%S)"
    v ln -sf "$s" "$t"
  else
    echo -e "${STY_GREEN}[$0]: Creating new symlink: $t -> $s${STY_RST}"
    v mkdir -p "$(dirname "$t")"
    v ln -sf "$s" "$t"
  fi
}

function symlink_file_s_t(){
  local s=$1
  local t=$2

  if [ -L "$t" ]; then
    echo -e "${STY_BLUE}[$0]: \"$t\" is already a symlink.${STY_RST}"
    local current_target=$(readlink "$t")
    if [ "$current_target" = "$s" ]; then
      echo -e "${STY_GREEN}[$0]: Symlink already points to correct location.${STY_RST}"
    else
      echo -e "${STY_YELLOW}[$0]: Symlink points to different location: $current_target${STY_RST}"
      v rm "$t"
      v ln -sf "$s" "$t"
    fi
  elif [ -e "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists. Backing up and creating symlink.${STY_RST}"
    v mv "$t" "$t.backup-$(date +%Y%m%d-%H%M%S)"
    v ln -sf "$s" "$t"
  else
    echo -e "${STY_GREEN}[$0]: Creating new symlink: $t -> $s${STY_RST}"
    v mkdir -p "$(dirname "$t")"
    v ln -sf "$s" "$t"
  fi
}

#####################################################################################
# In case some dirs does not exist
v mkdir -p $XDG_BIN_HOME $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME/icons

echo -e "${STY_CYAN}[$0]: Using SYMLINK mode - files will be symlinked instead of copied${STY_RST}"

# MISC (For dots/.config/* but not quickshell, not fish, not Hyprland, not fontconfig)
case "${SKIP_MISCCONF}" in
  true) sleep 0;;
  *)
    for i in $(find dots/.config/ -mindepth 1 -maxdepth 1 ! -name 'quickshell' ! -name 'fish' ! -name 'hypr' ! -name 'fontconfig' -exec basename {} \;); do
      echo "[$0]: Found target: dots/.config/$i"
      if [ -d "dots/.config/$i" ]; then
        symlink_dir_s_t "$(pwd)/dots/.config/$i" "$XDG_CONFIG_HOME/$i"
      elif [ -f "dots/.config/$i" ]; then
        symlink_file_s_t "$(pwd)/dots/.config/$i" "$XDG_CONFIG_HOME/$i"
      fi
    done
    # For konsole, symlink the directory
    symlink_dir_s_t "$(pwd)/dots/.local/share/konsole" "${XDG_DATA_HOME:-$HOME/.local/share}/konsole"
    ;;
esac

case "${SKIP_QUICKSHELL}" in
  true) sleep 0;;
  *)
    symlink_dir_s_t "$(pwd)/dots/.config/quickshell" "$XDG_CONFIG_HOME/quickshell"
    ;;
esac

case "${SKIP_FISH}" in
  true) sleep 0;;
  *)
    symlink_dir_s_t "$(pwd)/dots/.config/fish" "$XDG_CONFIG_HOME/fish"
    ;;
esac

case "${SKIP_FONTCONFIG}" in
  true) sleep 0;;
  *)
    case "$FONTSET_DIR_NAME" in
      "") symlink_dir_s_t "$(pwd)/dots/.config/fontconfig" "$XDG_CONFIG_HOME/fontconfig" ;;
      *) symlink_dir_s_t "$(pwd)/dots-extra/fontsets/$FONTSET_DIR_NAME" "$XDG_CONFIG_HOME/fontconfig" ;;
    esac
    ;;
esac

# For Hyprland - special handling since we need to symlink subdirectories
case "${SKIP_HYPRLAND}" in
  true) sleep 0;;
  *)
    if ! [ -d "$XDG_CONFIG_HOME/hypr" ]; then v mkdir -p "$XDG_CONFIG_HOME/hypr"; fi

    # Symlink the hyprland subdirectory
    symlink_dir_s_t "$(pwd)/dots/.config/hypr/hyprland" "$XDG_CONFIG_HOME/hypr/hyprland"

    # For main config files, create copies (not symlinks) on first run
    # This allows user customization while keeping modular configs synced
    for i in hypr{land,lock}.conf {monitors,workspaces}.conf; do
      if [ ! -e "$XDG_CONFIG_HOME/hypr/$i" ]; then
        echo -e "${STY_GREEN}[$0]: Creating initial copy of $i (customizable)${STY_RST}"
        v cp "dots/.config/hypr/$i" "$XDG_CONFIG_HOME/hypr/$i"
      else
        echo -e "${STY_BLUE}[$0]: $i already exists, not overwriting${STY_RST}"
      fi
    done

    for i in hypridle.conf; do
      if [ ! -e "$XDG_CONFIG_HOME/hypr/$i" ]; then
        if [[ "${INSTALL_VIA_NIX}" == true ]]; then
          v cp "dots-extra/via-nix/$i" "$XDG_CONFIG_HOME/hypr/$i"
        else
          v cp "dots/.config/hypr/$i" "$XDG_CONFIG_HOME/hypr/$i"
        fi
      fi
    done

    if [ "$OS_GROUP_ID" = "fedora" ]; then
      if ! grep -q "polkit-kde-authentication-agent-1" "${XDG_CONFIG_HOME}/hypr/hyprland/execs.conf" 2>/dev/null; then
        v bash -c "printf \"# For fedora to setup polkit\nexec-once = /usr/libexec/kf6/polkit-kde-authentication-agent-1\n\" >> ${XDG_CONFIG_HOME}/hypr/hyprland/execs.conf"
      fi
    fi

    # Create custom directory if it doesn't exist (this is for user customizations)
    if [ ! -d "$XDG_CONFIG_HOME/hypr/custom" ]; then
      v mkdir -p "$XDG_CONFIG_HOME/hypr/custom"
      # Copy template files
      for f in dots/.config/hypr/custom/*; do
        if [ -f "$f" ]; then
          v cp "$f" "$XDG_CONFIG_HOME/hypr/custom/$(basename "$f")"
        fi
      done
    fi
    ;;
esac

# Icon file - copy instead of symlink (small file)
v cp -f "dots/.local/share/icons/illogical-impulse.svg" "${XDG_DATA_HOME}/icons/illogical-impulse.svg"

v touch "${FIRSTRUN_FILE}"

echo -e "${STY_GREEN}[$0]: Symlink setup complete!${STY_RST}"
echo -e "${STY_CYAN}Note: Most directories are now symlinked to the repo.${STY_RST}"
echo -e "${STY_CYAN}Changes in the repo will immediately affect your config, and vice versa.${STY_RST}"
