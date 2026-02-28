-- used by javascript.lua and typescript.lua ftplugins
---@class my.slp.base_ts
local M = {}

local TS_ROOT_MARKERS = { 'tsconfig.json', 'package.json', '.git' }

function M.start()
  local base = require('my.lsp.base').get_config()

  vim.lsp.start({
    name = "typescript_ls",
    root_dir = vim.fs.root(0, TS_ROOT_MARKERS) or vim.fn.expand("%:p:h"),
    cmd = { 'typescript-language-server', '--stdio' },
    flags = base.flags,
    handlers = base.handlers,
    capabilities = base.capabilities,
    on_attach = base.on_attach,
    on_init = base.on_init,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  })
end

return M
