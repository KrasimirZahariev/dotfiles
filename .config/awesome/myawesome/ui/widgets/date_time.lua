local M = {}

local awful = require("awful")
local wibox = require("wibox")
local theme = require("myawesome.ui.theme")
local base = require("myawesome.ui.widgets.base")

local date_time_icon = base.build_icon_widget({icon = "/clock.png"})

local date_time = wibox.widget({
  font = theme.my_widget_font,
  format = theme.my_calendar.format,
  widget = wibox.widget.textclock(),
})

local month_calendar = awful.widget.calendar_popup.month(theme.my_calendar)
date_time:connect_signal("mouse::enter", function(_) month_calendar:toggle() end)
date_time:connect_signal("mouse::leave", function(_) month_calendar:toggle() end)

function M.get_widget()
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 4,

    date_time_icon,
    date_time,
  }
end

return M
