local M = {}

local base = require("myawesome.ui.widgets.base")
local naughty = require("naughty")

local battery_icon = base.build_icon_widget("/battery-100.png")
local battery_icon_inner = battery_icon[1][1]

local battery = base.build_text_widget()

local function send_notification(icon)
  naughty.notify({
    title = "Battery",
    text  = "Low battery",
    timeout = 5,
    icon = base.BASE_ICONS_DIR..icon,
    icon_size = 30,
  })
end

local function update_icon(stdout)
  local icon
  local level = tonumber(stdout)
  if level > 90 then
    icon = "/battery-5.png"
  elseif level > 75 then
    icon = "/battery-4.png"
  elseif level > 40 then
    icon = "/battery-3.png"
  elseif level > 10 then
    icon = "/battery-2.png"
  else
    icon = "/battery-1.png"
    send_notification(icon)
  end

  base.set_widget_icon(battery_icon_inner, icon)
end

local function update_text(stdout)
  local trimmed = stdout:gsub("\n", "")
  battery:set_text(trimmed.."%")
end

local function update_battery(stdout)
  update_text(stdout)
  update_icon(stdout)
end

function M.get()
  base.watch("battery_level", 180, {}, function(_, stdout)
    update_battery(stdout)
  end)

  return {
    icon = battery_icon,
    widget = battery,
  }
end

return M
