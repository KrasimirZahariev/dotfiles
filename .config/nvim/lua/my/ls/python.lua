local M = {}

local function get_config(base_config)
  return {
    -- root_dir = function() return vim.fn.expand('%:p:h') end;
    -- root_dir = function() return "/usr/lib/node_modules/pyright/dist/" end;
    -- cmd = {'pylsp'};
    -- single_file_support = true;
    flags = base_config.flags;
    handlers = base_config.handlers;
    capabilities = base_config.capabilities;
    on_init = base_config.on_init;
    on_attach = base_config.on_attach;
  }
end

function M.setup(base_config)
  local config = get_config(base_config)
  -- local client_id = vim.lsp.start_client(coq.lsp_ensure_capabilities(config))
  -- local bufnr = vim.api.nvim_get_current_buf()
  -- vim.lsp.buf_attach_client(bufnr, client_id)

  -- require("lspconfig").pylsp.setup(coq.lsp_ensure_capabilities(config))

  require("lspconfig").pyright.setup(config)
end


return M
