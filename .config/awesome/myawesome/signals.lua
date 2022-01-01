local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local M = {}

local function on_error()
  local in_error = false
  return function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end

    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end
end

-- Prevent clients from being unreachable after screen count changes.
local function client_on_manage()
  return function(c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then

      awful.placement.no_offscreen(c)
    end
  end
end

local function client_on_focus()
  return function(c) c.border_color = beautiful.border_focus end
end

local function client_on_unfocus()
  return function(c) c.border_color = beautiful.border_normal end
end

-- No borders for single non-floating or maximized client
local function screen_on_arrange()
  return function (s)
    local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    -- iterate over clients instead of tiled_clients
    -- as tiled_clients doesn't include maximized windows
    for _, c in pairs(s.clients) do
        if (max or only_one) and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
  end
end

function M.setup()
  awesome.connect_signal("debug::error", on_error())
  client.connect_signal("manage", client_on_manage())
  client.connect_signal("unfocus", client_on_unfocus())
  client.connect_signal("focus", client_on_focus())
  screen.connect_signal("arrange", screen_on_arrange())
end


return M
