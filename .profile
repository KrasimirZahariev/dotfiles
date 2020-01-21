#!/bin/sh

export PATH="${PATH}:$HOME/.local/bin:$HOME/.scripts"
export TERMINAL="xterm-termite"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export READER="zathura"
export FILE="ranger"
export RANGER_LOAD_DEFAULT_RC="false"
export XDG_CONFIG_HOME="$HOME/.config"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
   	 . "$HOME/.bashrc"
    fi
fi

# startx after login
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
