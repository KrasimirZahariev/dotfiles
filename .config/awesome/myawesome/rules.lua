local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

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
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },

  -- Don't add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = false }
  },

  -- Application tag assignment
  {rule = {class = "[J:j]etbrains.*"},
    properties = {screen = 1, tag = "1", switchtotag = true}
  },

  {rule = {class = "st-256color"},
    properties = {screen = 1, tag = "2", switchtotag = true}
  },

  {rule_any = {class = {"[F:f]irefox", "[L:l]ibre[W:w]olf"}},
    properties = {screen = 1, tag = "3", switchtotag = true}
  },

  {rule_any = {class = {"[S:s]kype", "[D:d]iscord"}},
    properties = {screen = 1, tag = "4", switchtotag = false}
  },

  {rule = {class = "mpv"},
    properties = {screen = 1, tag = "5", switchtotag = true}
  },

  {rule = {class = "[V:v]irtual[B:b]ox ([M:m]achine|[M:m]anager)"},
    properties = {screen = 1, tag = "7", switchtotag = true}
  },

  {rule = {class = "[K:k]afka.*"},
    properties = {screen = 1, tag = "8", switchtotag = true}
  },

  {rule_any = {class = {"[P:p]ostman", "[B:b]urp.*"}},
    properties = {screen = 1, tag = "9", switchtotag = true}
  },

  {rule = {class = "[D:d][B:b]eaver"},
    properties = {screen = 1, tag = "0", switchtotag = true}
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {"pinentry"},

      class = {
        "scratchpad-terminal",
        "scratchpad-notes",
        "scratchpad-todo",
        "scratchpad-restclient"
      },

      -- xev
      name = {"Event Tester"},

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
      floating = true ,
      placement = awful.placement.centered,
      width = 1020,
      x = 450,
      height = 680,
      y = 200
    }
  },

}
