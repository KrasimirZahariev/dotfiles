-- Make luarocks pkgs available if present
pcall(require, "luarocks.loader")
require("awful.autofocus")
-- dynamic tags
require("eminent")

local naughty = require("naughty")
local mysignals = require("myawesome.signals")
local myui = require("myawesome.ui.ui")
local mybindings = require("myawesome.bindings")
local myrules = require("myawesome.rules")


-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

mysignals.setup()
myui.setup()
local bindings = mybindings.setup()
myrules.setup(bindings)
