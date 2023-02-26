local M = {}

local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")

M.font            = "JetBrains Mono ExtraBold 7.5"

-- Colors
M.fg_normal       = "#afaf00"
M.fg_focus        = "#afaf00"
M.fg_urgent       = "#CC9393"
M.bg_normal       = "#282828"
M.bg_focus        = "#282828"
M.bg_urgent       = "#d75f5f"
M.bg_systray      = M.bg_normal

-- Borders
M.useless_gap     = dpi(0)
M.border_width    = dpi(2)
M.border_normal   = M.bg_normal
M.border_focus    = M.fg_focus
M.border_marked   = "#CC9393"

M.my_widget_font = "JetBrains Mono ExtraBold 9"

local function rounded_rect()
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
  end
end

M.my_calendar = {
  position = "tc",
  bg = M.bg_normal,
  margin = 2,
  spacing = 5,
  long_weekdays = true,

  style_month = {
    padding = 5,
  },

  style_header = {
    fg_color = M.fg_focus,
    bg_color = "#333333",
    shape = rounded_rect(),
    border_width = 1,
    border_color = M.fg_focus,
  },

  style_weekday = {
    fg_color = M.fg_focus,
    shape = rounded_rect(),
  },

  style_focus = {
    fg_color = M.bg_normal,
    bg_color = M.fg_focus,
    shape = rounded_rect(),
    padding = 6,
  },

  style_normal = {
    fg_color = M.fg_focus,
    bg_color = "#333333",
    shape = rounded_rect(),
    padding = 6,
    border_width = 0.3,
    border_color = M.fg_focus
  },
}

M.my_music_popup = {
  border_color = M.fg_focus,
  border_width = 0.3,
  ontop        = true,
  bg           = "#333333",
  fg           = M.fg_focus,
  shape        = rounded_rect(),
  x            = 60,
  y            = 1,
}

M.my_gitlab_popup = {
  border_color = M.fg_focus,
  border_width = 2,
  ontop        = true,
  bg           = M.bg_normal,
  fg           = M.fg_focus,
  shape        = rounded_rect(),
  placement = awful.placement.top_right + awful.placement.no_offscreen,
}

return M
