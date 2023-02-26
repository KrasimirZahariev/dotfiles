local M = {}

local awful = require("awful")
local wibox = require("wibox")

local ICONS_DIR = os.getenv("XDG_CONFIG_HOME").."/awesome/myawesome/ui/icons"

-- list, because the order of adding tags matters
local tags_config = {
  {name = "1", icon = ICONS_DIR.."/neovim.svg"},
  {name = "2", icon = ICONS_DIR.."/kitty-dark.png"},
  {name = "3", icon = ICONS_DIR.."/firefox.png"},
  {name = "4", icon = ICONS_DIR.."/chat.png"},
  {name = "5", icon = ICONS_DIR.."/movie.png"},
  {name = "6", icon = ICONS_DIR.."/6.png"},
  {name = "7", icon = ICONS_DIR.."/virtual-machine.png"},
  {name = "8", icon = ICONS_DIR.."/8.png"},
  {name = "9", icon = ICONS_DIR.."/9.png"},
  {name = "0", icon = ICONS_DIR.."/0.png"},
}

local function add_tags(screen)
  for _, tag in ipairs(tags_config) do
    local props = {
      icon = tag.icon,
      icon_only = true,
      layout = awful.layout.suit.tile,
      screen = screen,
    }

    if tag.name == "2" then
      props.selected = true
    end

    awful.tag.add(tag.name, props)
  end
end

function M.get_widget(screen)
  add_tags(screen)

  local widget = awful.widget.taglist({
    screen = screen,
    filter = awful.widget.taglist.filter.selected,
  })

  return {
    layout = wibox.container.place(widget, "center", "bottom"),

    {
      layout = wibox.container.constraint(widget, "exact", 25, 25),
      widget,
    },
  }
end

return M
