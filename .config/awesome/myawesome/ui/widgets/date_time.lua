local M = {}

local awful = require("awful")
local wibox = require("wibox")
local theme = require("myawesome.ui.theme")

local date_time = wibox.widget({
  font = theme.my_widget_font,
  widget = wibox.widget.textclock(),
})

local month_calendar = awful.widget.calendar_popup.month(theme.my_calendar)
date_time:connect_signal("mouse::enter", function(_) month_calendar:toggle() end)
date_time:connect_signal("mouse::leave", function(_) month_calendar:toggle() end)

function M.get_widget()
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 2,

    date_time,
  }
end

return M
