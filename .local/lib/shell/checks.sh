#!/bin/dash

# shellcheck disable=SC1091
. "$SHELL_LIBRARY_HOME"/messaging.sh

_FILE_NOT_EXISTS="File '%s' doesn't exist"
_FILE_EXISTS="File '%s' already exists"

_PROCESS_NOT_EXISTS="Process '%s' doesn't exist"
_PROCESS_EXISTS="Process '%s' already exists"

_BINARY_NOT_EXISTS="Binary '%s' doesn't exist"
_NO_EXEC_PERMISSION="Binary '%s' no exec permission"


# File exists checks
check_file_exists_or_warn() {
  _file="$1"
  _check_file_exists "$_file" warn
}

check_file_exists_or_err() {
  _file="$1"
  _check_file_exists "$_file" err
}

# File not exists checks
check_file_not_exists_or_warn() {
  _file="$1"
  _check_file_not_exists "$_file" warn
}

check_file_not_exists_or_err() {
  _file="$1"
  _check_file_not_exists "$_file" err
}

# Process exists checks
check_process_exists_or_warn() {
  _process="$1"
  _check_process_exists "$_process" warn
}

check_process_exists_or_err() {
  _process="$1"
  _check_process_exists "$_process" err
}

# Process not exists checks
check_process_not_exists_or_warn() {
  _process="$1"
  _check_process_not_exists "$_process" warn
}

check_process_not_exists_or_err() {
  _process="$1"
  _check_process_not_exists "$_process" err
}

# Binary exec permission checks
check_binary_exec_perm_or_warn() {
  _binary="$1"
  _check_binary_exec_perm "$_binary" warn
}

check_binary_exec_perm_or_err() {
  _binary="$1"
  _check_binary_exec_perm "$_binary" err
}

# Path checks
check_absolute_path() {
  _path="$1"
  [ "${_path%"${_path#?}"}" = "/" ] && pathchk --portability "$_path" 2>/dev/null
}

check_relative_path() {
  _path="$1"
  [ "${_path%"${_path#?}"}" != "/" ] && pathchk --portability "$_path" 2>/dev/null
}


# Private functions
_check_file_exists() {
  _file="$1"
  _function="$2"
  [ ! -f "$_file" ] && _print_message "$_file" "$_function" "$_FILE_NOT_EXISTS"
}

_check_file_not_exists() {
  _file="$1"
  _function="$2"
  [ -f "$_file" ] && _print_message "$_file" "$_function" "$_FILE_EXISTS"
}

_check_process_exists() {
  _process="$1"
  _function="$2"
  pgrep -iaf "$_process" > /dev/null \
    || _print_message "$_process" "$_function" "$_PROCESS_NOT_EXISTS"
}

_check_process_not_exists() {
  _process="$1"
  _function="$2"
  pgrep -iaf "$_process" > /dev/null \
    && _print_message "$_process" "$_function" "$_PROCESS_EXISTS"
}

_check_binary_exec_perm() {
  _binary="$1"
  _function="$2"
  _binary_full_path="$(command -v "$_binary")"
  _return_code=$?

  if [ "$_return_code" -ne 0 ]; then
    _print_message "$_binary" "$_function" "$_BINARY_NOT_EXISTS" \
      && return 1
  else
    [ ! -x "$_binary_full_path" ] \
      && _print_message "$_binary" "$_function" "$_NO_EXEC_PERMISSION" \
      && return 1
  fi

  return 0
}

# shellcheck disable=SC2059
_print_message() {
  _file="$1"
  _function="$2"
  _message="$3"
  _formatted_message="$(printf "$_message" "$_file")"

  # call the messaging function
  "$_function" "$_formatted_message"
}
