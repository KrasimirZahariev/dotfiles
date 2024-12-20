local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local M = {}

function M.setup(bindings)
  -- Rules to apply to new clients (through the "manage" signal).
  awful.rules.rules = {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = bindings.client_bindings,
        buttons = bindings.mouse_bindings,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        size_hints_honor = false,
        titlebars_enabled = false
      }
    },

    -- Application tag assignment
    {rule_any = {class = {"[J:j]etbrains.*", "nvim%-ide"}},
      properties = {screen = 1, tag = "1", switchtotag = true}
    },

    {rule_any = {class = {"st-256color", "kitty"}},
      properties = {screen = 1, tag = "2", switchtotag = true}
    },

    {rule_any = {class = {"[F:f]irefox", "[L:l]ibre[W:w]olf"}},
      properties = {screen = 1, tag = "3", switchtotag = true}
    },

    {rule_any = {class = {"[D:d]iscord"}},
      properties = {screen = 1, tag = "4", switchtotag = false}
    },

    {rule_any = {class = {"libreoffice"}},
      properties = {screen = 1, tag = "5", switchtotag = false}
    },

    {rule_any = {class = {"[V:v]irtual[B:b]ox [M:m]anager", "[V:v]irt%-manager"}},
      properties = {screen = 1, tag = "7", switchtotag = true}
    },

    {rule_any = {class = {"mpv"}},
      properties = {screen = 1, tag = "8", switchtotag = true}
    },

    {rule_any = {class = {"[V:v]irtual[B:b]ox [M:m]achine", "[V:v]irt%-viewer"}},
      properties = {screen = 1, tag = "9", switchtotag = true}
    },

    {rule_any = {class = {"[B:b]urp.*", "[W:w]ireshark"}},
      properties = {screen = 1, tag = "0", switchtotag = true}
    },


    -- Floating clients
    {
      rule_any = {
        class = {
          "scratchpad-terminal",
          "scratchpad-notes",
          "scratchpad-todo",
          "scratchpad-restclient"
        },
        role = {
          "pop-up",
          "bubble",
          "task_dialog",
          "Preferences",
          "dialog",
          "menu"
        }
      },

      properties = {
        floating = true,
        ontop = true,
        width = awful.screen.focused().geometry.width * 0.6,
        height = awful.screen.focused().geometry.height * 0.7
      },

      callback = function(c)
        awful.placement.centered(c, {honor_padding = true, honor_workarea=true})
        gears.timer.delayed_call(function() c.urgent = false end)
      end
    },
  }
end


return M
