HOME = os.getenv("HOME")
XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME")
XDG_DATA_HOME = os.getenv("XDG_DATA_HOME")
NVIM_DATA_HOME = os.getenv("XDG_DATA_HOME").."/nvim"
NVIM_CACHE_HOME = os.getenv("XDG_CACHE_HOME").."/nvim"

require("my.lazy")
require("my.settings")
require("my.functions")
require("my.commands")
require("my.autocmds")
require("my.mappings")
require("my.colors")
