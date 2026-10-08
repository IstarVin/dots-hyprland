# ~/.zshrc
# Refactored Arch Linux Zsh configuration

# -----------------------------------------------------------------------------
# Powerlevel10k instant prompt
# Keep this near the top. Anything that can require interactive input should
# stay above this block.
# -----------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------------------------------------
# Environment / paths
# -----------------------------------------------------------------------------

# Keep PATH/FPATH entries unique while preserving order.
typeset -U path fpath

# Deno completions must be on FPATH before compinit.
fpath=(
  "$HOME/.zsh/completions"
  $fpath
)

# Tool-managed environment.
[[ -s "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

export PNPM_HOME="$HOME/.local/share/pnpm"

# Prefer user-installed tools before system binaries.
path=(
  "$HOME/.local/bin"
  "$HOME/.bin"
  "$HOME/.config/hypr/scripts"
  "$HOME/.bun/bin"
  "$HOME/.local/share/JetBrains/Toolbox/scripts"
  "$HOME/.local/share/gem/ruby/3.4.0/bin"
  "$HOME/.deno/bin"
  "$HOME/.dotnet/tools"
  "$HOME/Android/Sdk/build-tools/37.0.0"
  "/opt/android-sdk/platform-tools"
  "$PNPM_HOME"
  "${GOBIN:-${GOPATH:-$HOME/go}/bin}"
  $path
)

export PATH

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# -----------------------------------------------------------------------------
# Zinit
# -----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME/.git" ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# -----------------------------------------------------------------------------
# Powerlevel10k
# -----------------------------------------------------------------------------
zinit ice depth=1
zinit light romkatv/powerlevel10k

# -----------------------------------------------------------------------------
# Completion system
#
# zsh-completions must extend FPATH before compinit.
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-completions

ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Completion behavior.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# -----------------------------------------------------------------------------
# Oh My Zsh snippets
# -----------------------------------------------------------------------------
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Optional snippets:
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx

# -----------------------------------------------------------------------------
# zsh-vi-mode
#
# Initialize while sourcing so later plugins can establish their final
# keybindings deterministically.
# -----------------------------------------------------------------------------
ZVM_INIT_MODE=sourcing

function zvm_after_init() {
  bindkey '^O' autosuggest-accept
  bindkey '^P' history-search-backward
  bindkey '^N' history-search-forward
  bindkey '^[w' kill-region
}

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# -----------------------------------------------------------------------------
# Shell integrations
#
# Load fzf's own bindings before fzf-tab so fzf-tab becomes the final owner
# of the Tab completion widget.
# -----------------------------------------------------------------------------
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# fzf-tab must load after compinit and before autosuggestions/highlighting.
zinit light Aloxaf/fzf-tab

# Preview completion candidates.
if (( $+commands[lsd] )); then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -lah --color=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -lah --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -lah --color=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -lah --color=always $realpath'
fi

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

# Yazi wrapper: leave the shell in Yazi's final directory.
function yy() {
  local tmp cwd

  tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return 1
  yazi "$@" --cwd-file="$tmp"

  cwd="$(<"$tmp")"
  rm -f -- "$tmp"

  if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
}

# -----------------------------------------------------------------------------
# Desktop-specific helpers
# -----------------------------------------------------------------------------
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]] && (( $+commands[gdctl] )); then
  alias 60fps='gdctl set -L -p -M eDP-1 -m 1920x1080@60.004+vrr'
  alias 144fps='gdctl set -L -p -M eDP-1 -m 1920x1080@144.003+vrr'
elif (( $+commands[hyprctl] )); then
  alias 60fps='hyprctl eval "hl.monitor({output=\"\",mode=\"1920x1080@60\"})"'
  alias 144fps='hyprctl eval "hl.monitor({output=\"\",mode=\"1920x1080@144\"})"'
fi

if [[ "$TERM" == "xterm-kitty" ]] && (( $+commands[kitty] )); then
  alias ssh='kitty +kitten ssh'
fi

# -----------------------------------------------------------------------------
# General aliases
# -----------------------------------------------------------------------------
if (( $+commands[lsd] )); then
  alias ls='lsd'
  alias l='lsd'
  alias ll='lsd -lh'
  alias la='lsd -lah'
  alias tree='lsd --tree'
else
  alias l='ls'
  alias ll='ls -lh'
  alias la='ls -lah'
fi

(( $+commands[bat] )) && alias cat='bat'
(( $+commands[nvim] )) && alias vim='nvim'
(( $+commands[gnome-text-editor] )) && alias gedit='gnome-text-editor'

alias c='clear'
alias py='python3'
alias ..='cd ..'
alias co='curl -O'
alias ip='ip -c'

alias pn='cat /sys/class/power_supply/BAT0/power_now'
alias sw='cat /tmp/specialworkspace'

alias source-zsh='source ~/.zshrc'
alias incognito='unset HISTFILE'

# -----------------------------------------------------------------------------
# Arch / system aliases
# -----------------------------------------------------------------------------
if (( $+commands[yay] )); then
  alias S='yay -S'
  alias Ss='yay -Ss'
fi

alias update-mirrors='sudo reflector -a 48 -c JP -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist'

if (( $+commands[asusctl] )); then
  alias Quiet='asusctl profile -P Quiet'
  alias Balanced='asusctl profile -P Balanced'
  alias Performance='asusctl profile -P Performance'
  alias charge='asusctl battery limit'
  alias keyboard_color='asusctl aura static -c 803dba'
fi

alias powersave-services='sudo systemctl stop libvirtd docker containerd'
alias restore-services='sudo systemctl start libvirtd docker containerd'
alias reboot-windows='systemctl reboot --boot-loader-entry=windows.conf'

# -----------------------------------------------------------------------------
# Hyprland / GPU helpers
# -----------------------------------------------------------------------------
if (( $+commands[hyprctl] )); then
  alias animation-off='hyprctl keyword animations:enabled 0'
  alias animation-on='hyprctl keyword animations:enabled 1'
fi

(( $+commands[switcherooctl] )) && alias nvrun='switcherooctl launch -g 1'

# -----------------------------------------------------------------------------
# SSH / server shortcuts
# -----------------------------------------------------------------------------
alias home-server='ssh home-server'
alias aj-server='ssh aj-server'
alias kali='ssh aj@172.21.0.2'

# -----------------------------------------------------------------------------
# Project / development shortcuts
# -----------------------------------------------------------------------------
alias mpv-hehe='/mnt/AJ/Projects/mpv-shim-hehe/main'

alias android-builder='docker start android-builder && docker exec -it android-builder /bin/zsh'

alias source-funcs='source <(curl -fsSL https://arch-install.pages.dev/other/functions.sh)'

# -----------------------------------------------------------------------------
# CTF aliases
# -----------------------------------------------------------------------------
alias factordb='uv --directory /mnt/AJ/Projects/factordb run /mnt/AJ/Projects/factordb/factordb.py'
alias rsactftool='uv --directory="$HOME/AJ/Projects/ctf/tools/RsaCtfTool" run RsaCtfTool'
alias pcrt='python2 /mnt/AJ/Projects/ctf/PCRT/PCRT.py'

alias grepico='grep -o "picoCTF{.*}"'
alias copy='wl-copy'
alias grepicopy='grepico | copy'
alias mkctf='mkdir -p "Binary Exploitation" Cryptography Forensics "General Skills" Others "Reverse Engineering" "Web Exploitation"'

# -----------------------------------------------------------------------------
# Tool completions
# -----------------------------------------------------------------------------
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Replay any compdefs Zinit recorded before compinit.
zinit cdreplay -q

# -----------------------------------------------------------------------------
# Plugins that wrap ZLE widgets
#
# Keep autosuggestions late and syntax-highlighting last.
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# -----------------------------------------------------------------------------
# Powerlevel10k configuration
# -----------------------------------------------------------------------------
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

