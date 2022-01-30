local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local M = {}

-- https://github.com/EliverLara/candy-icons
local ICONS_DIR = os.getenv("XDG_CONFIG_HOME") .. "/awesome/myawesome/icons/"
local TAG_1_ICON = ICONS_DIR .. "idea.svg"
-- local TAG_2_ICON = ICONS_DIR .. "terminal.svg"
local TAG_2_ICON = ICONS_DIR .. "terminix.svg"
-- local TAG_3_ICON = ICONS_DIR .. "librewolf.svg"
local TAG_3_ICON = ICONS_DIR .. "firefox.svg"
-- local TAG_4_ICON = ICONS_DIR .. "electronic-wechat.svg"
-- local TAG_4_ICON = ICONS_DIR .. "discord-canary.svg"
local TAG_4_ICON = ICONS_DIR .. "cliq.svg"
-- local TAG_5_ICON = ICONS_DIR .. "mpv.svg"
local TAG_5_ICON = ICONS_DIR .. "applications-multimedia.svg"
-- local TAG_6_ICON = ICONS_DIR .. "distributor-logo-archlinux.svg"
local TAG_7_ICON = ICONS_DIR .. "virtualbox.svg"
local TAG_8_ICON = ICONS_DIR .. "kmymoney.svg"
local TAG_9_ICON = ICONS_DIR .. "burp.svg"
local TAG_0_ICON = ICONS_DIR .. "dbeaver.svg"

local function show_bar()
  return function(s)
    -- awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])
    awful.tag.add("1", {
        icon = TAG_1_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("2", {
        icon = TAG_2_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
        selected = true,
    })

    awful.tag.add("3", {
        icon = TAG_3_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("4", {
        icon = TAG_4_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("5", {
        icon = TAG_5_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("6", {
        -- icon = TAG_6_ICON,
        -- icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("7", {
        icon = TAG_7_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("8", {
        icon = TAG_8_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("9", {
        icon = TAG_9_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    awful.tag.add("0", {
        icon = TAG_0_ICON,
        icon_only = true,
        layout = awful.layout.suit.tile,
        screen = s,
    })

    local taglist = awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
    }

    local date = wibox.widget.textclock()

    local crypto = awful.widget.watch("polybar-crypto", 60)

    local battey_level = awful.widget.watch("cat /sys/class/power_supply/BAT0/capacity", 120)

    local keyboard_layout = awful.widget.keyboardlayout()

    local padding = wibox.widget.textbox()
    padding.text = "\t\t\t"

    local bar = awful.wibar({
      position = "top",
      screen = s,
      bg = beautiful.bg_normal .. "00"
    })

    -- Add widgets to the wibox
    bar:setup {
      layout = wibox.layout.align.horizontal,
      expand = "none",

      -- Left
      {
        layout = wibox.layout.fixed.horizontal,
        taglist,
      },

      -- Middle
      {
        layout = wibox.layout.fixed.horizontal,
        date,
        padding,
        crypto,
      },

      -- Right
      {
        layout = wibox.layout.fixed.horizontal,
        wibox.widget.systray(),
        keyboard_layout,
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

  beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

  awful.screen.connect_for_each_screen(show_bar())
end

return M
