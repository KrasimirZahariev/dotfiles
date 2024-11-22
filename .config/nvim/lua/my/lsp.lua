local M = {}

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "MyDiffDelete",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "MyRedBold",
      [vim.diagnostic.severity.WARN]  = "YellowSign",
      [vim.diagnostic.severity.INFO]  = "BlueSign",
      [vim.diagnostic.severity.HINT]  = "YellowSign",
    },
  },
})

local lsp = vim.lsp

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

local flags = {
  debounce_text_changes = 150,
  allow_incremental_sync = true
}

local function do_nothing() end
local handlers = {
  ["textDocument/codeLens"] = do_nothing,
  ["language/status"] = do_nothing,
  ["textDocument/hover"] = lsp.buf.hover({ border = "rounded" }),
  ["textDocument/signatureHelp"] = lsp.buf.hover({ border = "rounded" }),
}

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local function on_attach(client, bufnr)
  require("my.mappings").lsp(bufnr)
  require("my.autocmds").lsp(client, bufnr)

  if vim.bo.filetype == "java" then
    return
  end

  -- require("lsp-inlayhints").on_attach(client, bufnr)
end

function M.get_config()
  return {
    capabilities = get_capabilities(),
    flags = flags,
    handlers = handlers,
    on_init = on_init,
    on_attach = on_attach,
  }
end


return M
