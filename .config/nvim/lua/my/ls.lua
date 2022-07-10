local ls = {
  java = function() return require('my.ls.java') end;
  lua = function() return require('my.ls.lua') end;
  sh = function() return require('my.ls.bash') end;
  rust = function() return require('my.ls.rust') end;
  -- elixir = function() return require('my.ls.elixir') end;
  -- python = function() return require('my.ls.python') end;
}

local current_bufnr = vim.api.nvim_get_current_buf()
local ft = vim.api.nvim_buf_get_option(current_bufnr, 'filetype')
if ls[ft] ~= nil then
  -- vim.lsp.set_log_level('debug')
  local base_config = require('my.ls.base').get_config()
  -- print(vim.inspect(base_config))
  ls[ft]().setup(base_config)
end
