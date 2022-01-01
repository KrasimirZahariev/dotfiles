local lspconfig = require('lspconfig')
local coq = require('coq')

local M = {}

local XDG_CONFIG_HOME = os.getenv('XDG_CONFIG_HOME')
local XDG_DATA_HOME = os.getenv('XDG_DATA_HOME')

local LUA_DEFAULT_VERSION = 'Lua 5.3'
local LUA_LS_BINARY = 'lua-language-server'
local LUA_LS_MAIN = '/usr/lib/lua-language-server/bin/Linux/main.lua'

local LUA_DEFAULT_DIR = '/usr/share/lua/5.4'
local LUAROCKS_DIR = XDG_DATA_HOME .. '/luarocks/share/lua/5.4'

local AWESOME_LIB_DIR = '/usr/share/awesome/lib'
local AWESOME_CONFIG_DIR = XDG_CONFIG_HOME .. '/awesome'
local AWESOME_LUA_VERSION = 'Lua 5.3'
local AWESOME_GLOBALS = {'awesome', 'client', 'screen', 'root'}

local VIMRUNTIME = os.getenv('VIMRUNTIME')
local NEOVIM_LUA_RUNTIME_DIR = VIMRUNTIME .. '/lua'
local NEOVIM_CONFIG_DIR = XDG_CONFIG_HOME .. '/nvim'
local NEOVIM_LUA_PLUGINS_DIR = XDG_DATA_HOME .. '/nvim/site/pack/packer/start'
local NEOVIM_LUA_VERSION = 'LuaJIT'
local NEOVIM_GLOBALS = {'vim', 'use'}


local function get_root_dir()
  return vim.fn.expand('%:p:h');
end

local function get_cmd()
  return {LUA_LS_BINARY, '-E', LUA_LS_MAIN}
end

local function get_awesome_settings()
  return {
    version = AWESOME_LUA_VERSION,
    globals = AWESOME_GLOBALS,
    library = {
      [AWESOME_LIB_DIR] = true,
      [AWESOME_CONFIG_DIR] = true
    }
  }
end

local function get_neovim_settings()
  return {
    version = NEOVIM_LUA_VERSION,
    globals = NEOVIM_GLOBALS,
    library = {
      [NEOVIM_LUA_RUNTIME_DIR] = true,
      [NEOVIM_CONFIG_DIR] = true,
      [NEOVIM_LUA_PLUGINS_DIR] = true
    }
  }
end

local function get_default_settings()
  return {
    version = LUA_DEFAULT_VERSION,
    globals = {},
    library = {
      [LUA_DEFAULT_DIR] = true,
      [LUAROCKS_DIR] = true
    }
  }
end

local function get_workspace_settings()
  local root_dir = get_root_dir()

  local is_neovim_cfg_dir = string.find(root_dir, NEOVIM_CONFIG_DIR) ~= nil
  local is_awesome_cfg_dir = string.find(root_dir, AWESOME_CONFIG_DIR) ~= nil

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
        path = package.path
      },

      diagnostics = {
        globals = workspace_settings.globals
      },

      workspace = {
        library = workspace_settings.library
      },

      telemetry = {
        enable = false
      }
    }
  }
end

local function get_config(base_config)
  return {
    root_dir = get_root_dir;
    cmd = get_cmd();
    settings = get_settings();
    flags = base_config.flags;
    handlers = base_config.handlers;
    capabilities = base_config.capabilities;
    on_init = base_config.on_init;
    on_attach = base_config.on_attach;
  }
end

function M.setup(base_config)
  local config = get_config(base_config)
  lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities(config))

  -- local config = get_config(base_config)
  -- local client_id = vim.lsp.start_client(coq.lsp_ensure_capabilities(config))
  -- local bufnr = vim.api.nvim_get_current_buf()
  -- vim.lsp.buf_attach_client(bufnr, client_id)
end


return M
