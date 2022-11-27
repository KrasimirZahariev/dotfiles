local base_config = require("my.lsp").get_config()

local config = {
  root_dir = function() return vim.fn.expand("%:p:h") end;
  cmd = {"elixir-ls"};

  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false
    }
  };

  flags = base_config.flags;
  handlers = base_config.handlers;
  capabilities = base_config.capabilities;
  on_init = base_config.on_init;
  on_attach = base_config.on_attach;
}

-- local client_id = vim.lsp.start_client(coq.lsp_ensure_capabilities(config))
-- local bufnr = vim.api.nvim_get_current_buf()
-- vim.lsp.buf_attach_client(bufnr, client_id)

-- require("lspconfig").elixirls.setup(config)
