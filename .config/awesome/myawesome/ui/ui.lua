local M = {}

local awful        = require("awful")
local beautiful    = require("beautiful")
local theme        = require("myawesome.ui.theme")
local bar          = require("myawesome.ui.bar")

local function show_bar()
  return function(screen)
    bar.get(screen)
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
