#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias definitions.
if [ -f ~/.config/bash-aliases ]; then
    . ~/.config/bash-aliases
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Prepend cd when entering just a path in the shell
shopt -s autocd

# Allow to cd in dir which value is held in variable
shopt -s cdable_vars

# Show commands run on multiple lines on one in history
shopt -s cmdhist

# Number of lines to store
HISTFILESIZE="100000"

# Don't store duplicate lines and lines starting with space
HISTCONTROL="ignoreboth"

# Don't store the following commands
HISTIGNORE="ls:la:ll:bg:fg:history:clear:ev:ec:es:notes"

# Store in history immediately
PROMPT_COMMAND="history -a"

# Show git branch
git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Custom shell prompt
PS1="\[\033[38;5;46m\]\u\[$(tput sgr0)\]\[\033[38;5;226m\]@\[$(tput sgr0)\]\[\033[38;5;46m\]\h\[$(tput sgr0)\]\[\033[38;5;226m\]:\[$(tput sgr0)\]\[\033[38;5;46m\][\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;226m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;46m\]]\[$(tput sgr0)\]\[\033[38;5;226m\]>\[\033[38;5;51m\]\$(git_branch)\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;46m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)

# Shows where the command typed can be found if not present in the system
source /usr/share/doc/pkgfile/command-not-found.bash

# Git completion
source /usr/share/git/completion/git-completion.bash

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Further completion of file names and commands
complete -cf sudo man


