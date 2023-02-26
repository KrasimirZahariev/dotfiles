local M = {}

local debug = require("gears.debug")
local naughty = require("naughty")

function M.notify(data)
  local debug_message = debug.dump_return(data, "DEBUG")
  naughty.notify({text = debug_message, timeout = 0})
end

return M
