local dpi = require("beautiful.xresources").apply_dpi

local M = {}

M.font = "sans 7.5"
M.taglist_spacing = 5

-- Colors
M.fg_normal  = "#DCDCCC"
M.fg_focus   = "#F0DFAF"
M.fg_urgent  = "#CC9393"
M.bg_normal  = "#3F3F3F"
M.bg_focus   = "#1E2320"
M.bg_urgent  = "#3F3F3F"
M.bg_systray = M.bg_normal

-- Borders
M.useless_gap   = dpi(0)
M.border_width  = dpi(2)
M.border_normal = "#3F3F3F"
M.border_focus  = "#6F6F6F"
M.border_marked = "#CC9393"

-- M.useless_gap = 3

return M
