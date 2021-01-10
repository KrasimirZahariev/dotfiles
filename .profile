#!/bin/sh

export PATH="${PATH}:$HOME/.local/bin"

# Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export PICTURES_DIR="$HOME/pictures"
export DOWNLOADS_DIR="$HOME/downloads"
export DOCUMENTS_DIR="$HOME/documents"
export SCRIPTS_DIR="$HOME/.local/bin"
export DOTFILES_DIR="$HOME/.dotfiles"
export VCS_DIR="$HOME/vcs"
export AUR_DIR="$HOME/aur"
export WORK_DIR="$HOME/work"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export ANDROID_SDK_HOME="$XDG_DATA_HOME/android"
export ANDROID_PREFS_ROOT="$XDG_CONFIG_HOME/android"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android/emulator"

# Files
export LESSHISTFILE="/dev/null"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export PYTHONHISTORY="$XDG_DATA_HOME/python/python_history"
export XAUTHORITY="$XDG_RUNTIME_DIR/xauthority"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export IDEA_PROPERTIES="$XDG_CONFIG_HOME/intellij/idea.properties"


# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export TERMINAL="st"
export PDF_READER="zathura"
export FILE_MANAGER="ranger"
export MEDIA_PLAYER="mpv"

# Settings
export LESS="-igR -j.5 --mouse --wheel-lines=2"
export RANGER_LOAD_DEFAULT_RC="false"
export BAT_THEME="ansi-dark"
export PASSWORD_STORE_CLIP_TIME="10"
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore --glob '!.git' --glob '!.dotfiles'"
export FZF_DEFAULT_OPTS="
--reverse
--height 10%
--preview-window='right:80%'
--color='preview-bg:-1'
--bind='ctrl-a:toggle-all'
--bind='ctrl-p:toggle-preview'
--bind='alt-j:preview-down'
--bind='alt-d:preview-half-page-down'
--bind='alt-k:preview-up'
--bind='alt-u:preview-half-page-up'
"

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Start an X session
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx $XDG_CONFIG_HOME/x11/xinitrc
fi
