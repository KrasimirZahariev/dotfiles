#!/bin/dash

dmenu_select() {
  if [ -t 0 ]; then
    _options="$(echo "$@" | tr ' ' '\n')"
  else
    _options=$(cat)
  fi

  _choice="$(echo "$_options" | dmenu -l 10 -g 1)"

  _is_choice_valid || return 1

  echo "$_choice"
  return 0
}

_is_choice_valid() {
  echo "$_options" | grep -qw "$_choice"
}
