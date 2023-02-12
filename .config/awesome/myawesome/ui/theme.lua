local dpi = require("beautiful.xresources").apply_dpi

local M = {}

M.font            = "JetBrains Mono ExtraBold 7.5"
M.taglist_spacing = 5

-- Colors
M.fg_normal       = "#afaf00"
M.fg_focus        = "#afaf00"
M.fg_urgent       = "#CC9393"
M.bg_normal       = "#282828"
M.bg_focus        = "#3F3F3F"
M.bg_urgent       = "#d75f5f"
M.bg_systray      = M.bg_normal

-- Borders
M.useless_gap     = dpi(0)
M.border_width    = dpi(2)
M.border_normal   = M.bg_normal
M.border_focus    = M.fg_focus
M.border_marked   = "#CC9393"

-- M.useless_gap = 3

return M
