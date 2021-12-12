local lspconfig = require('lspconfig')
local coq = require('coq')

local M = {}

local function get_library()
  local library = {}

  local function add_paths(paths)
    for _, path in pairs(paths) do
      library[path] = true
    end
  end

  add_paths({
    os.getenv('/usr/share/lua/5.4'),
    os.getenv('XDG_DATA_HOME') .. '/luarocks/share/lua/5.4',
    os.getenv('VIMRUNTIME') .. '/lua',
    os.getenv('XDG_CONFIG_HOME') .. '/nvim',
    os.getenv('XDG_DATA_HOME') .. '/nvim/site/pack/packer/start',
  })

  return library
end

local settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of nvim
      version = 'LuaJIT',
      path = package.path
    },

    diagnostics = {
      globals = {'vim', 'use'}
    },

    workspace = {
      library = get_library()
    },

    telemetry = {
      enable = false
    }
  }
}

local function get_cmd()
  local main_lua = '/usr/lib/lua-language-server/bin/Linux/main.lua'
  local cmd = {'lua-language-server', '-E', main_lua}

  return cmd
end

local function get_root_dir()
  return vim.fn.expand('%:p:h');
end

local function get_config(base_config)
  return {
    root_dir = get_root_dir;
    cmd = get_cmd();
    settings = settings;
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
