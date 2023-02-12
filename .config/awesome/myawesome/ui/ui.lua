local M = {}

local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local gears     = require("gears")
local lain      = require("lain")
local theme     = require("myawesome.ui.theme")

local ICONS_DIR = os.getenv("XDG_CONFIG_HOME").."/awesome/myawesome/ui/icons"

-- list, because the order of adding tags matters
local tags_config = {
  {name = "1", icon = ICONS_DIR.."/code-tags.svg"},
  {name = "2", icon = ICONS_DIR.."/console-line.svg"},
  {name = "3", icon = ICONS_DIR.."/firefox.svg"},
  {name = "4", icon = ICONS_DIR.."/chat-processing-outline.svg"},
  {name = "5", icon = ICONS_DIR.."/play-circle.svg"},
  {name = "6", icon = ICONS_DIR.."/numeric-6-circle-outline.svg"},
  {name = "7", icon = ICONS_DIR.."/package-variant.svg"},
  {name = "8", icon = ICONS_DIR.."/numeric-8-circle-outline.svg"},
  {name = "9", icon = ICONS_DIR.."/numeric-9-circle-outline.svg"},
  {name = "0", icon = ICONS_DIR.."/numeric-0-circle-outline.svg"},
}

local function build_tags(screen)
  for _, tag in ipairs(tags_config) do
    local props = {
      icon = gears.color.recolor_image(tag.icon, theme.fg_focus),
      icon_only = true,
      layout = awful.layout.suit.tile,
      screen = screen,
    }

    if tag.name == "2" then
      props.selected = true
    end

    awful.tag.add(tag.name, props)
  end

  return awful.widget.taglist({
    screen = screen,
    filter = awful.widget.taglist.filter.all,
  })
end

local function show_bar()
  return function(sreen)
    local tags = build_tags(sreen)

    local current_track = awful.widget.watch("bar-output current_track", 3)

    local date = wibox.widget.textclock()

    local tickers = awful.widget.watch("bar-output tickers", 60)

    local battey_level = awful.widget.watch("bar-output battery_level", 120)

    local keyboard_layout = awful.widget.keyboardlayout()

    local mem = lain.widget.mem {
      settings = function() widget:set_markup("MEM " .. mem_now.used) end
    }

    local cpu = lain.widget.cpu {
      settings = function() widget:set_markup("CPU " .. cpu_now.usage) end
    }

    local padding = wibox.widget.textbox()
    padding.text = "\t"

    local bar = awful.wibar({
      position = "top",
      screen = sreen,
      bg = theme.bg_normal,
    })

    -- Add widgets to the wibox
    bar:setup {
      layout = wibox.layout.align.horizontal,
      expand = "none",

      -- Left
      {
        layout = wibox.layout.fixed.horizontal,
        tags,
        padding,
        current_track,
      },

      -- Middle
      {
        layout = wibox.layout.fixed.horizontal,
        date,
        padding,
        tickers,
      },

      -- Right
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        keyboard_layout,
        padding,
        mem,
        padding,
        cpu,
        padding,
        battey_level,
      },
    }
  end
end

function M.setup()
  -- Table of layouts to cover with awful.layout.inc, order matters.
  awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
  }

  beautiful.init(theme)

  awful.screen.connect_for_each_screen(show_bar())
end

return M
