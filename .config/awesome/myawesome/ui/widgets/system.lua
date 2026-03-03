local M = {}

local awful   = require("awful")
local wibox   = require("wibox")
local base    = require("myawesome.ui.widgets.base")
local theme   = require("myawesome.ui.theme")
local volume  = require("myawesome.ui.widgets.volume")

local vpn_icon = base.build_icon_widget({icon = "/vpn.png"})
local vpn_widget = base.build_text_widget()

local keyboard_layout_icon = base.build_icon_widget({icon = "/keyboard.png"})
local keyboard_layout = awful.widget.keyboardlayout()
keyboard_layout.widget.font = theme.my_widget_font

local memory_icon = base.build_icon_widget({icon = "/memory.png"})
local memory = base.build_text_widget()

local cpu_icon = base.build_icon_widget({icon = "/processor.png"})
local cpu = base.build_text_widget()

local volume_config = volume.get()
local volume_icon = volume_config.icon
local volume_widget = volume_config.widget

local HORIZONTAL = wibox.layout.fixed.horizontal

local system_info_widget = wibox.widget({
  layout = HORIZONTAL,
  spacing = 10,
  {
    layout = HORIZONTAL,
    spacing = 2,

    vpn_icon,
    vpn_widget,
  },

  {
    layout = HORIZONTAL,
    spacing = 0,

    {
      layout = HORIZONTAL,
      spacing = 0,

      keyboard_layout_icon,
      keyboard_layout,
    },
    {
      layout = HORIZONTAL,
      spacing = 10,

      {
        layout = HORIZONTAL,
        spacing = 2,

        memory_icon,
        memory,
      },
      {
        layout = HORIZONTAL,
        spacing = 2,

        cpu_icon,
        cpu,
      },
      {
        layout = HORIZONTAL,
        spacing = 2,

        volume_icon,
        volume_widget,
      },
    }
  }
})

function M.get_widget()
  base.watch("memory_cpu_usage", 3, {memory, cpu, vpn_widget})
  return system_info_widget
end

return M
