#!/bin/sh

export PATH="${PATH}:$HOME/.local/bin"

# Directories
export XDG_CONFIG_HOME="$HOME/.config"
export PICTURES_DIR="$HOME/pictures"
export DOWNLOADS_DIR="$HOME/downloads"
export DOCUMENTS_DIR="$HOME/documents"
export SCRIPTS_DIR="$HOME/.local/bin"
export DOTFILES_DIR="$HOME/.dotfiles"
export VCS_DIR="$HOME/vcs"
export AUR_DIR="$HOME/aur"
export WORK_DIR="$HOME/work"
export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/password-store"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export PDF_READER="zathura"
export FILE_MANAGER="ranger"

# Settings
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export RANGER_LOAD_DEFAULT_RC="false"
export BAT_THEME="ansi-dark"
export PASSWORD_STORE_CLIP_TIME="10"

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
  exec startx $XDG_CONFIG_HOME/xinitrc
fi
