#!/bin/sh

export PATH="${PATH}:$HOME/.local/bin"
export XDG_CONFIG_HOME="$HOME/.config"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export SCRIPTS="$HOME/.local/bin"
export GIT="$HOME/git"
export DOTFILES="$GIT/dotfiles"
export AUR="$GIT/aur"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export READER="zathura"
export FILE="ranger"
export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/password-store"
export PASSWORD_STORE_CLIP_TIME="10"
export RANGER_LOAD_DEFAULT_RC="false"
export BAT_THEME="ansi-dark"

#Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
   	 . "$HOME/.bashrc"
    fi
fi

# startx after login
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx $HOME/.config/xinitrc
fi
