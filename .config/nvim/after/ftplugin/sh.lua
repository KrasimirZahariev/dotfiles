local base = require('my.lsp.base').get_config()

vim.lsp.start({
  name         = "bash_ls",
  root_dir     = vim.fn.expand("%:p:h"),
  cmd          = { 'bash-language-server', 'start' },
  flags        = base.flags,
  handlers     = base.handlers,
  capabilities = base.capabilities,
  on_init      = base.on_init,
  on_attach    = base.on_attach,
  cmd_env      = { GLOB_PATTERN = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)" },
})
