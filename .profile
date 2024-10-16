#!/bin/env bash

# Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export PICTURES_DIR="$HOME/pictures"
export DOWNLOADS_DIR="$HOME/downloads"
export DOCUMENTS_DIR="$HOME/documents"
export SCRIPTS_DIR="$HOME/.local/bin"
export SHELL_LIBRARY_HOME="$HOME/.local/lib/shell"
export DOTFILES_DIR="$HOME/.dotfiles"
export VCS_DIR="$HOME/vcs"
export AUR_DIR="$XDG_CACHE_HOME/paru/clone"
export WORK_DIR="$HOME/work"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export ANDROID_SDK_HOME="$XDG_DATA_HOME/android"
export ANDROID_PREFS_ROOT="$XDG_CONFIG_HOME/android"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android/emulator"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export MIX_HOME="$XDG_DATA_HOME/mix"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"

# Files
export LESSHISTFILE="/dev/null"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export PYTHONHISTORY="$XDG_DATA_HOME/python/python_history"
export XAUTHORITY="$XDG_RUNTIME_DIR/xauthority"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export IDEA_PROPERTIES="$XDG_CONFIG_HOME/intellij/idea.properties"
export IDEA_VM_OPTIONS="$XDG_CONFIG_HOME/intellij/idea64.vmoptions"
export PGPASSFILE="$XDG_CONFIG_HOME/postgres/pgpass"
export MPV_FIFO="/tmp/mpv-fifo" # hardcoded in ~/.config/mpv/mpv.conf
export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config-5.4.lua"
export VIMINIT='let $MYVIMRC = has("nvim") ? "$XDG_CONFIG_HOME/nvim/init.lua" : "$XDG_CONFIG_HOME/vim/vimrc" | so $MYVIMRC'

# Paths
export PATH="${PATH}:${SCRIPTS_DIR}:/usr/lib/jvm/java-21-graalvm-ee/bin"
eval "$(luarocks path --bin)"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="librewolf"
export TERMINAL="kitty"
export PDF_READER="zathura"
export FILE_MANAGER="ranger"
export MEDIA_PLAYER="mpv"

# Settings
export MANPAGER="nvim +Man!"
export LESS="-igRF -j.5 --mouse --wheel-lines=2"
export RANGER_LOAD_DEFAULT_RC="false"
export PASSWORD_STORE_CLIP_TIME="10"
export QT_STYLE_OVERRIDE=adwaita-dark
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore --glob '!.git' --glob '!.dotfiles'"
export FZF_DEFAULT_OPTS="
--reverse
--height 10%
--preview-window='right:80%'
--color='preview-bg:-1'
--bind='ctrl-a:toggle-all'
--bind='ctrl-p:toggle-preview'
--bind='alt-j:preview-half-page-down'
--bind='alt-k:preview-half-page-up'
"

# Colors
export NONE=$(echo -en '\033[0m')
export BLACK=$(echo -en '\033[0;30m')
export RED=$(echo -en '\033[0;31m')
export GREEN=$(echo -en '\033[0;32m')
export YELLOW=$(echo -en '\033[0;33m')
export BLUE=$(echo -en '\033[0;34m')
export PINK=$(echo -en '\033[0;35m')
export CYAN=$(echo -en '\033[0;36m')
export LIGHT_GRAY=$(echo -en '\033[0;37m')
export DARK_GRAY=$(echo -en '\033[1;30m')
export LIGHT_RED=$(echo -en '\033[1;31m')
export LIGHT_GREEN=$(echo -en '\033[1;32m')
export LIGHT_YELLOW=$(echo -en '\033[1;33m')
export LIGHT_YELLOW_UNDERLINE=$(echo -en '\033[7;33m')
export LIGHT_BLUE=$(echo -en '\033[1;34m')
export LIGHT_PINK=$(echo -en '\033[1;35m')
export LIGHT_CYAN=$(echo -en '\033[1;36m')
export WHITE=$(echo -en '\033[1;37m')

[ -f "$XDG_CONFIG_HOME/private/env" ] && source "$XDG_CONFIG_HOME/private/env"

[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx "$XDG_CONFIG_HOME/x11/xinitrc"
