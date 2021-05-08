#!/bin/dash

info() {
  echo >&1 "${GREEN}INFO:::${NO_COLOR} $*"
}

warn() {
  echo >&2 "${YELLOW}WARNING:::${NO_COLOR} $*"
}

err() {
  echo >&2 "${LIGHT_RED}ERROR:::${NO_COLOR} $*"
  exit 1
}
