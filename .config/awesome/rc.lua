-- Make luarocks pkgs available if present
pcall(require, "luarocks.loader")
require("awful.autofocus")
-- dynamic tags
require("eminent")

local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

require("myawesome.signals").setup()
local myrules = require("myawesome.rules")
local bindings = require("myawesome.bindings").setup()
myrules.setup(bindings)
require("myawesome.ui.ui").setup()
