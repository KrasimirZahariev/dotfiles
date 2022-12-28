local LUA_DEFAULT_VERSION = 'Lua 5.3'
local LUA_LS_BINARY = 'lua-language-server'
local LUA_LS_MAIN = '/usr/lib/lua-language-server/bin/Linux/main.lua'

local LUA_DEFAULT_DIR = '/usr/share/lua/5.4'
local LUA_LIB_DIR = '/usr/lib/lua/5.4'
local LUAROCKS_DIR = XDG_DATA_HOME .. '/luarocks/share/lua/5.4'

local AWESOME_LIB_DIR = '/usr/share/awesome/lib'
local AWESOME_CONFIG_DIR = XDG_CONFIG_HOME .. '/awesome'
local AWESOME_LUA_VERSION = 'Lua 5.3'
local AWESOME_GLOBALS = {'awesome', 'client', 'screen', 'root'}

local NEOVIM_CONFIG_DIR = XDG_CONFIG_HOME .. '/nvim'
local NEOVIM_LUA_VERSION = 'LuaJIT'
local NEOVIM_GLOBALS = {'vim'}


local function get_cmd()
  return {LUA_LS_BINARY, '-E', LUA_LS_MAIN}
end

local function get_awesome_settings()
  return {
    version = AWESOME_LUA_VERSION,
    globals = AWESOME_GLOBALS,
    library = {AWESOME_LIB_DIR, AWESOME_CONFIG_DIR}
  }
end

local function get_neovim_settings()
  return {
    version = NEOVIM_LUA_VERSION,
    globals = NEOVIM_GLOBALS,
  }
end

local function get_default_settings()
  return {
    version = LUA_DEFAULT_VERSION,
    globals = {},
    library = {LUA_DEFAULT_DIR, LUA_LIB_DIR, LUAROCKS_DIR}
  }
end

local function get_workspace_settings()
  local current_dir = vim.fn.expand('%:p:h')

  local is_neovim_cfg_dir = string.find(current_dir, NEOVIM_CONFIG_DIR) ~= nil
  local is_awesome_cfg_dir = string.find(current_dir, AWESOME_CONFIG_DIR) ~= nil

  local settings
  if is_neovim_cfg_dir then
    settings = get_neovim_settings()
  elseif is_awesome_cfg_dir then
    settings = get_awesome_settings()
  else
    settings = get_default_settings()
  end

  return settings
end

local function get_settings()
  local workspace_settings = get_workspace_settings()

  return {
    Lua = {
      runtime = {
        version = workspace_settings.version,
        path = {"?.lua", "?/init.lua"},
      },

      workspace = {
        library = workspace_settings.library,
        maxPreload = 1000,
        preloadFileSize = 200,
        checkThirdParty = false,
      },

      diagnostics = {
        globals = workspace_settings.globals,
      },

      completion = {
        callSnippet = "Replace",
        displayContext = 10,
      },

      semantic = {
        enable = false,
        variable = false,
      },

      telemetry = {
        enable = false,
      }
    }
  }
end

local function get_config()
  local base_config = require("my.lsp").get_config()
  return {
    cmd = get_cmd();
    settings = get_settings();
    flags = base_config.flags;
    handlers = base_config.handlers;
    capabilities = base_config.capabilities;
    on_init = base_config.on_init;
    on_attach = base_config.on_attach;
  }
end

require("neodev").setup()
require("lspconfig").sumneko_lua.setup(get_config())
