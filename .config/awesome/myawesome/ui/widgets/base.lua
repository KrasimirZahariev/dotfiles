local M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("myawesome.ui.theme")
local utils = require("myawesome.utils")

M.BASE_ICONS_DIR = os.getenv("XDG_CONFIG_HOME").."/awesome/myawesome/ui/icons"

function M.build_icon_widget(config)
  local widget = wibox.widget{
    image  = config.icon_path or M.BASE_ICONS_DIR..config.icon,
    widget = wibox.widget.imagebox,
  }

  local size = config.size or 17

  return {
    layout = wibox.container.place(widget, "center", "center"),

    {
      layout = wibox.container.constraint(widget, "exact", size, size),
      widget,
    },
  }
end

function M.set_widget_icon(widget, icon)
  widget:set_image(gears.surface.load_uncached(M.BASE_ICONS_DIR..icon))
end

function M.download_and_set_image(image_url, image_download_path, widget)
  local cmd = string.format("wget '%s' -O %s", image_url, image_download_path)
  awful.spawn.easy_async(cmd, function ()
    widget:set_image(gears.surface.load_uncached(image_download_path))
  end)
end

function M.build_text_widget(text, font)
  local widget = wibox.widget({
    font = font or theme.my_widget_font,
    widget = wibox.widget.textbox,
  })

  if text ~= nil then
    widget:set_text(text)
  end

  return widget
end

function M.update_widgets(widgets, stdout)
  local output = utils.split_stdout(stdout)

  for index, widget in ipairs(widgets) do
    widget:set_text(output[index])
  end
end

function M.watch(args, time, widgets, callback)
  callback = callback or function(_, stdout) M.update_widgets(widgets, stdout) end
  awful.widget.watch("bar-output "..args, time, callback)
end


return M
