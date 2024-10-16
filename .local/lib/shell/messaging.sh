#!/bin/dash

info() {
  echo >&1 "${GREEN}INFO:::${NONE} $*"
}

warn() {
  echo >&2 "${YELLOW}WARNING:::${NONE} $*"
}

err() {
  echo >&2 "${LIGHT_RED}ERROR:::${NONE} $*"
  exit 1
}
