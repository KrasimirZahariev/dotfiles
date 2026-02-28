-- after/ftplugin/python.lua
local base = require('my.lsp.base').get_config()
local PY_ROOT_MARKERS = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }

vim.lsp.start({
  name = "python_ls",
  root_dir = vim.fs.root(0, PY_ROOT_MARKERS) or vim.fn.getcwd(),
  cmd = { 'pyright-langserver', '--stdio' },
  flags = base.flags,
  handlers = base.handlers,
  capabilities = base.capabilities,
  on_attach = base.on_attach,
  on_init = base.on_init,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
})
