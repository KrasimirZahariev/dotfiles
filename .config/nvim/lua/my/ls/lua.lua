local lspconfig = require('lspconfig')
local coq = require('coq')

local M = {}

local function get_root_dir()
  return vim.fn.expand('%:p:h');
end

local function get_cmd()
  local main_lua = '/usr/lib/lua-language-server/bin/Linux/main.lua'
  local cmd = {'lua-language-server', '-E', main_lua}

  return cmd
end

local function get_awesome_settings()
  return {
    version = 'Lua 5.3',

    globals = {'awesome', 'client', 'globalkeys', 'clientkeys', 'clientbuttons', 'screen',
      'root', 'terminal', 'editor', 'editor_cmd', 'myawesomemenu', 'mymainmenu', 'mylauncher',
      'mykeyboardlayout', 'mytextclock'
    },

    library = {
      ['/usr/share/awesome/lib'] = true,
      [os.getenv('XDG_CONFIG_HOME') .. '/awesome'] = true
    }
  }
end

local function get_neovim_settings()
  return {
    version = 'LuaJIT',

    globals = {'vim', 'use'},

    library = {
      [os.getenv('VIMRUNTIME') .. '/lua'] = true,
      [os.getenv('XDG_CONFIG_HOME') .. '/nvim'] = true,
      [os.getenv('XDG_DATA_HOME') .. '/nvim/site/pack/packer/start'] = true
    }
  }
end

local function get_default_settings()
  return {
    version = 'Lua 5.4',
    globals = {},
    library = {
      ['/usr/share/lua/5.4'] = true,
      [os.getenv('XDG_DATA_HOME') .. '/luarocks/share/lua/5.4'] = true
    }
  }
end

local function get_workspace_settings()
  local root_dir = get_root_dir()
  local neovim_cfg_dir = os.getenv('XDG_CONFIG_HOME') .. '/nvim'
  local awesome_cfg_dir = os.getenv('XDG_CONFIG_HOME') .. '/awesome'

  local is_neovim_cfg_dir = string.find(root_dir, neovim_cfg_dir) ~= nil
  local is_awesome_cfg_dir = string.find(root_dir, awesome_cfg_dir) ~= nil

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
