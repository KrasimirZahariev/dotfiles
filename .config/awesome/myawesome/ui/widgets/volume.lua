local M = {}

local awful = require("awful")
local base = require("myawesome.ui.widgets.base")

local volume_icon = base.build_icon_widget({icon = "/audio.png"})
local volume_icon_inner = volume_icon[1][1]

local volume = base.build_text_widget()

local function toggle_mute()
  awful.spawn.easy_async("bar-output toggle_mute", function()
    if volume_icon_inner.my_muted then
      base.set_widget_icon(volume_icon_inner, "/audio.png")
      volume_icon_inner.my_muted = false
    else
      base.set_widget_icon(volume_icon_inner, "/mute.png")
      volume_icon_inner.my_muted = true
    end
  end)
end

local function change_volume(step, widget)
  awful.spawn.easy_async("bar-output change_volume "..step, function(stdout, _, _, _)
    widget:set_text(stdout)
  end)
end

volume:connect_signal("button::press", function(_, _, _, button, _, metadata)
  if button == 1 then
    toggle_mute()
  elseif button == 4 then
    change_volume("+2", metadata.widget)
  elseif button == 5 then
    change_volume("-2", metadata.widget)
  end
end)

local function setup()
  awful.spawn.easy_async("bar-output get_volume", function(stdout, _, _, _)
    volume:set_text(stdout)
  end)

  awful.spawn.easy_async("bar-output get_volume_mute", function(stdout, _, _, _)
    if stdout == "yes" then
      volume_icon_inner.my_muted = true
    else
      volume_icon_inner.my_muted = false
    end
  end)
end

function M.get()
  setup()

  return {
    icon = volume_icon,
    widget = volume,
  }
end

return M
