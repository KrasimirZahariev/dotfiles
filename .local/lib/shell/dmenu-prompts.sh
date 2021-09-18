#!/bin/dash

dmenu_choose() {
  _options="$(echo "$@" | tr ' ' '\n')"
  _choice="$(echo "$_options" | dmenu -l 10 -g 1)"

  _is_choice_valid \
    && echo "$_choice" \
    && return 0

  return 1
}

_is_choice_valid() {
  echo "$_options" | grep -qw "$_choice"
}
