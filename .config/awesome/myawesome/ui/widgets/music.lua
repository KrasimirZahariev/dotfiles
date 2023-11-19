local M = {}

local awful = require("awful")
local wibox = require("wibox")
local base  = require("myawesome.ui.widgets.base")
local utils = require("myawesome.utils")
local theme = require("myawesome.ui.theme")

local music_icon = base.build_icon_widget({icon = "/play.png", size = 19})
local music_icon_inner = music_icon[1][1]
music_icon_inner.visible = false
music_icon_inner.my_paused = false

local music_popup_config = theme.my_music_popup
music_popup_config.widget = base.build_text_widget()
local music_popup = awful.popup(music_popup_config)

local function find_value(key)
  local file_content = utils.file_to_table(os.getenv("MPV_FIFO"))
  for i = #file_content, 1, -1 do
    local prefix, suffix = file_content[i]:match("(.-)%:(.+)")
    if prefix == key then
      return suffix
    end
  end
end

music_icon_inner:connect_signal("mouse::enter", function(_)
  if not music_icon_inner.visible then
    return
  end

  local title = find_value("Title")
  assert(title, "title not set")

  music_popup.widget:set_text(title)
  music_popup.visible = true
end)

music_icon_inner:connect_signal("mouse::leave", function(_) music_popup.visible = false end)

music_icon_inner:connect_signal("button::press", function(_, _, _, button, _, _)
  if not music_icon_inner.visible then
    return
  end

  if button == 1 then
    local url = find_value("Playing")
    assert(url, "url not set")

    utils.open_with_browser(url)
  end
end)

awesome.connect_signal("music_player_open", function() music_icon_inner.visible = true end)

awesome.connect_signal("music_player_quit", function() music_icon_inner.visible = false end)

awesome.connect_signal("music_player_toggle_paused", function()
  if not music_icon_inner.my_paused then
    base.set_widget_icon(music_icon_inner, "/pause.png")
    music_icon_inner.my_paused = true
  else
    base.set_widget_icon(music_icon_inner, "/play.png")
    music_icon_inner.my_paused = false
  end
end)


function M.get_widget()
  return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 2,

    music_icon,
  }
end

return M
