#!/bin/dash

_get_xresources_color() {
  _color_number="$1"

  xrdb -query \
    | grep "\*color$_color_number:" \
    | awk '{print $2}'
}
