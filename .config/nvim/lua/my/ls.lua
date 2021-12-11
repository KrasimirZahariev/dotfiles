local base_ls = require('lua.my.ls.base')
local java_ls = require('lua.my.ls.java')
local lua_ls = require('lua.my.ls.lua')
local bash_ls = require('lua.my.ls.bash')

local M = {}

local ls = {
  java = java_ls;
  lua = lua_ls;
  sh = bash_ls;
}

function M.setup()
  vim.lsp.set_log_level('debug')
  local current_bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(current_bufnr, 'filetype')
  if ls[ft] ~= nil then
    local base_config = base_ls.get_config()
    -- print(vim.inspect(base_config))
    ls[ft].setup(base_config)
  end
end


return M
