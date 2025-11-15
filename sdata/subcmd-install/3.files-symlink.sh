# This script is meant to be sourced.
# It creates symlinks instead of copying files
# Usage: Set INSTALL_MODE=symlink before sourcing 3.files.sh

# shellcheck shell=bash

# Backup directory for replaced files/directories
SYMLINK_BACKUP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/.ii-install-backups"

function symlink_dir_s_t(){
  local s=$1
  local t=$2

  # If target is already a symlink, update it without backing up
  if [ -L "$t" ]; then
    echo -e "${STY_BLUE}[$0]: \"$t\" is already a symlink (no backup needed).${STY_RST}"
    local current_target=$(readlink "$t")
    if [ "$current_target" = "$s" ]; then
      echo -e "${STY_GREEN}[$0]: Symlink already points to correct location.${STY_RST}"
    else
      echo -e "${STY_YELLOW}[$0]: Updating symlink from $current_target to $s${STY_RST}"
      v rm "$t"
      v ln -sf "$s" "$t"
    fi
  # Only backup if it's a real directory (not a symlink)
  elif [ -d "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists as a directory. Backing up and creating symlink.${STY_RST}"
    v mkdir -p "$SYMLINK_BACKUP_DIR"
    local backup_name="$(basename "$t").backup-$(date +%Y%m%d-%H%M%S)"
    v mv "$t" "$SYMLINK_BACKUP_DIR/$backup_name"
    v ln -sf "$s" "$t"
  elif [ -e "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists as a file. Backing up and creating symlink.${STY_RST}"
    v mkdir -p "$SYMLINK_BACKUP_DIR"
    local backup_name="$(basename "$t").backup-$(date +%Y%m%d-%H%M%S)"
    v mv "$t" "$SYMLINK_BACKUP_DIR/$backup_name"
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

  # If target is already a symlink, update it without backing up
  if [ -L "$t" ]; then
    echo -e "${STY_BLUE}[$0]: \"$t\" is already a symlink (no backup needed).${STY_RST}"
    local current_target=$(readlink "$t")
    if [ "$current_target" = "$s" ]; then
      echo -e "${STY_GREEN}[$0]: Symlink already points to correct location.${STY_RST}"
    else
      echo -e "${STY_YELLOW}[$0]: Updating symlink from $current_target to $s${STY_RST}"
      v rm "$t"
      v ln -sf "$s" "$t"
    fi
  # Only backup if it's a real file (not a symlink)
  elif [ -e "$t" ]; then
    echo -e "${STY_YELLOW}[$0]: \"$t\" exists. Backing up and creating symlink.${STY_RST}"
    v mkdir -p "$SYMLINK_BACKUP_DIR"
    local backup_name="$(basename "$t").backup-$(date +%Y%m%d-%H%M%S)"
    v mv "$t" "$SYMLINK_BACKUP_DIR/$backup_name"
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

# MISC (For dots/.config/* but not quickshell, not fish, not hypr, not fontconfig)
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

# For Hyprland - symlink entire directory
case "${SKIP_HYPRLAND}" in
  true) sleep 0;;
  *)
    symlink_dir_s_t "$(pwd)/dots/.config/hypr" "$XDG_CONFIG_HOME/hypr"
    ;;
esac

# Icon file - copy instead of symlink (small file)
v cp -f "dots/.local/share/icons/illogical-impulse.svg" "${XDG_DATA_HOME}/icons/illogical-impulse.svg"

# Symlink files from dots/.home to home directory
if [ -d "dots/.home" ]; then
  echo "[$0]: Symlinking home directory dotfiles from dots/.home/"
  for i in $(find dots/.home/ -mindepth 1 -maxdepth 1 ! -name 'README.md' -exec basename {} \;); do
    echo "[$0]: Found home dotfile: $i"
    if [ -d "dots/.home/$i" ]; then
      symlink_dir_s_t "$(pwd)/dots/.home/$i" "$HOME/$i"
    elif [ -f "dots/.home/$i" ]; then
      symlink_file_s_t "$(pwd)/dots/.home/$i" "$HOME/$i"
    fi
  done
fi

v touch "${FIRSTRUN_FILE}"

echo -e "${STY_GREEN}[$0]: Symlink setup complete!${STY_RST}"
echo -e "${STY_CYAN}Note: All config directories are now symlinked to the repo.${STY_RST}"
echo -e "${STY_CYAN}Changes in the repo will immediately affect your config, and vice versa.${STY_RST}"
if [ -d "$SYMLINK_BACKUP_DIR" ]; then
  echo -e "${STY_YELLOW}Backups of replaced files are in: $SYMLINK_BACKUP_DIR${STY_RST}"
fi
