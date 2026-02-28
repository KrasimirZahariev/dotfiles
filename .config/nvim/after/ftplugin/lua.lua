local LUA_DEFAULT_VERSION  = 'Lua 5.3'
local LUA_LS_BINARY        = 'lua-language-server'
local LUA_LS_MAIN          = '/usr/lib/lua-language-server/bin/Linux/main.lua'
local LUA_DEFAULT_DIR      = '/usr/share/lua/5.4'
local LUA_LIB_DIR          = '/usr/lib/lua/5.4'
local LUAROCKS_DIR         = XDG_DATA_HOME  .. '/luarocks/share/lua/5.4'
local AWESOME_LIB_DIR      = '/usr/share/awesome/lib'
local AWESOME_CONFIG_DIR   = XDG_CONFIG_HOME .. '/awesome'
local AWESOME_LUA_VERSION  = 'Lua 5.3'
local AWESOME_GLOBALS      = { 'awesome', 'client', 'screen', 'root' }
local NEOVIM_CONFIG_DIR    = XDG_CONFIG_HOME .. '/nvim'
local NEOVIM_LUA_VERSION   = 'LuaJIT'
local NEOVIM_GLOBALS       = { 'vim' }

local function get_root_dir()
  local current_dir = vim.fn.expand('%:p:h')
  local is_neovim_cfg_dir  = current_dir:find(NEOVIM_CONFIG_DIR,  1, true)
  local is_awesome_cfg_dir = current_dir:find(AWESOME_CONFIG_DIR, 1, true)
  if is_neovim_cfg_dir then
    return NEOVIM_CONFIG_DIR
  elseif is_awesome_cfg_dir then
    return AWESOME_CONFIG_DIR
  else
    return current_dir
  end
end

local function workspace_settings()
  local root_dir = get_root_dir()
  if NEOVIM_CONFIG_DIR == root_dir then
    return {
      version = NEOVIM_LUA_VERSION,
      globals = NEOVIM_GLOBALS,
      library = {},
    }
  elseif AWESOME_CONFIG_DIR == root_dir then
    return {
      version = AWESOME_LUA_VERSION,
      globals = AWESOME_GLOBALS,
      library = { AWESOME_LIB_DIR, AWESOME_CONFIG_DIR },
    }
  else
    return {
      version = LUA_DEFAULT_VERSION,
      globals = {},
      library = { LUA_DEFAULT_DIR, LUA_LIB_DIR, LUAROCKS_DIR },
    }
  end
end

local function build_settings(ws)
  return {
    Lua = {
      runtime = {
        version = ws.version,
        path    = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library         = ws.library,
        maxPreload      = 1000,
        preloadFileSize = 200,
        checkThirdParty = true,
      },
      diagnostics = {
        globals = ws.globals,
      },
      completion = {
        callSnippet    = "Replace",
        displayContext = 10,
      },
      semantic = {
        enable   = false,
        variable = false,
      },
      telemetry = {
        enable = false,
      },
    },
  }
end

local base = require('my.lsp.base').get_config()

vim.lsp.start({
  name         = 'lua_ls',
  root_dir     = get_root_dir(),
  cmd          = { LUA_LS_BINARY, '-E', LUA_LS_MAIN },
  flags        = base.flags,
  handlers     = base.handlers,
  capabilities = base.capabilities,
  on_attach    = base.on_attach,
  on_init      = base.on_init,
  settings     = build_settings(workspace_settings()),
})
