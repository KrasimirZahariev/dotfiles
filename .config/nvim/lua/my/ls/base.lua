local mappings = require('lua.my.mappings')
local autocmds = require('lua.my.autocmds')

local lsp = vim.lsp

local M = {}

local function get_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.workspace.configuration = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

local flags = {
  debounce_text_changes = 150,
  allow_incremental_sync = true
}

local handlers = {
  ['language/status'] = function() end;
  ['textDocument/hover'] = lsp.with(lsp.handlers.hover, {border = 'rounded'});
  ['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {border = 'rounded'});
  ['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      update_in_insert = true
    }
  );
}

local function on_init(client)
  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
  end
end

local function on_attach(client, bufnr)
  mappings.set_base_lsp_mappings(client, bufnr)
  autocmds.lsp(client, bufnr)
end

function M.get_config()
  return {
    capabilities = get_capabilities();
    flags = flags;
    handlers = handlers;
    on_init = on_init;
    on_attach = on_attach;
  }
end


return M
