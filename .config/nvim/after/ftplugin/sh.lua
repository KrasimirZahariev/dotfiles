local base_config = require("my.lsp").get_config()

local config = {
  root_dir = vim.fn.expand("%:p:h");
  cmd = {"bash-language-server", "start"};

  -- Prevent recursive scanning which will cause issues when opening a file
  -- directly in the home directory (e.g. ~/foo.sh).
  -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
  cmd_env = {GLOB_PATTERN = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)"};

  flags = base_config.flags;
  handlers = base_config.handlers;
  capabilities = base_config.capabilities;
  on_init = base_config.on_init;
  on_attach = base_config.on_attach;
}

local client_id = vim.lsp.start_client(config)
local bufnr = vim.api.nvim_get_current_buf()
vim.lsp.buf_attach_client(bufnr, client_id)
