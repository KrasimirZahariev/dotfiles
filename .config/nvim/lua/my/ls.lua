local base_ls = require('lua.my.ls.base')
local java_ls = require('lua.my.ls.java')
local lua_ls = require('lua.my.ls.lua')

local M = {}

local ls = {
  java = java_ls;
  lua = lua_ls;
}

function M.setup()
  -- lsp.set_log_level('trace')
  local current_bufnr = 0
  local ft = vim.api.nvim_buf_get_option(current_bufnr, 'filetype')
  if ls[ft] ~= nil then
    local base_config = base_ls.get_config()
    ls[ft].setup(base_config)
  end
end

M.setup()


return M
