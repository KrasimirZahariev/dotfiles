local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local M = {}

local XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME")

local function show_bar()
  return function(s)
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    local taglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
    }

    local date = wibox.widget.textclock()

    local crypto = awful.widget.watch("polybar-crypto", 60)

    local battey_level = awful.widget.watch("cat /sys/class/power_supply/BAT0/capacity", 120)

    local keyboard_layout = awful.widget.keyboardlayout()

    local padding = wibox.widget.textbox()
    padding.text = "\t\t\t"

    local bar = awful.wibar({position = "top", screen = s})
    -- Add widgets to the wibox
    bar:setup {
      layout = wibox.layout.align.horizontal,
      expand = "none",

      -- Left
      {
        layout = wibox.layout.fixed.horizontal,
        taglist,
      },

      -- Middle
      {
        layout = wibox.layout.fixed.horizontal,
        date,
        padding,
        crypto,
      },

      -- Right
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        keyboard_layout,
        padding,
        battey_level,
      },
    }
  end
end

function M.setup()
  -- Table of layouts to cover with awful.layout.inc, order matters.
  awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
  }

  beautiful.init(XDG_CONFIG_HOME .. "/awesome/themes/zenburn/theme.lua")

  awful.screen.connect_for_each_screen(show_bar())
end

return M
