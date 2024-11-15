local M = {}

local wibox = require("wibox")
local awful = require("awful")
local json = require("myawesome.json")
local base = require("myawesome.ui.widgets.base")
local theme = require("myawesome.ui.theme")

local HORIZONTAL = wibox.layout.fixed.horizontal

local fng_text_widget = base.build_text_widget()
local fng_icon_widget = base.build_icon_widget({icon = "/fng.png"})

local popup_config = theme.my_ticker_popup
popup_config.widget = base.build_text_widget()

local popup = awful.popup(popup_config)
popup.visible = false

local widget = {
  layout = HORIZONTAL,
  spacing = 4,
  fng_icon_widget,
  fng_text_widget,
}

local function color_value(value)
  local color
  if     tonumber(value) < 25  then color = "red"
  elseif tonumber(value) < 50  then color = "orange"
  elseif tonumber(value) < 75  then color = "yellow"
  elseif tonumber(value) < 101 then color = "lime"
  end

  return string.format("<span font_weight='bold' foreground='%s'>%s</span>", color, value)
end

local function calculate_SMA50(data)
  local sum = 0
  for _, fng in ipairs(data) do
    sum = sum + fng.value
  end

  return sum / 50
end

local cmd = "curl -s 'https://api.alternative.me/fng/?limit=50'"
awful.spawn.easy_async(cmd, function (stdout)
  local response = json.parse(stdout)

  fng_text_widget:set_markup(color_value(response.data[1].value))

  local sma50 = calculate_SMA50(response.data)
  popup_config.widget:set_text("  50 Day SMA "..sma50.."  ")

  fng_icon_widget[1][1]:connect_signal("mouse::enter", function(_) popup.visible = true end)
  fng_icon_widget[1][1]:connect_signal("mouse::leave", function(_) popup.visible = false end)

  fng_text_widget:connect_signal("mouse::enter", function(_) popup.visible = true end)
  fng_text_widget:connect_signal("mouse::leave", function(_) popup.visible = false end)
end)

function M.get_widget()
  return widget
end

return M
