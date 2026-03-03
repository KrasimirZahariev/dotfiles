local M = {}

local awful       = require("awful")
local wibox       = require("wibox")
local theme       = require("myawesome.ui.theme")
local tags        = require("myawesome.ui.widgets.tags")
local system      = require("myawesome.ui.widgets.system")
local music       = require("myawesome.ui.widgets.music")


local function get_left_widgets(screen)
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 20,

    tags.get_widget(screen),
    music.get_widget(),
  }
end

local function get_right_widgets()
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,

    wibox.widget.systray(),
    system.get_widget(),
  }
end

local function get_widgets(screen)
  return {
    layout = wibox.layout.align.horizontal,
    expand = "none",

    get_left_widgets(screen),
    get_right_widgets(),
  }
end

function M.get(screen)
  local bar = awful.wibar({
    position = "top",
    screen = screen,
    bg = theme.bg_normal,
  })

  bar:setup(get_widgets(screen))

  return bar
end

return M
