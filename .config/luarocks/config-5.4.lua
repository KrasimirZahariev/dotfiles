-- LuaRocks configuration

local LUAROCKS_DATA_HOME = home .. '/.local/share/luarocks'

home_tree = LUAROCKS_DATA_HOME

rocks_trees = {
   { name = "user", root = LUAROCKS_DATA_HOME };
   { name = "system", root = "/usr" };
}

lua_interpreter = "lua5.4";

variables = {
   LUA_DIR = "/usr";
   LUA_BINDIR = "/usr/bin";
}
