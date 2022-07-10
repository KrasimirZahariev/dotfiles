local M = {}

local lsp = vim.lsp

local function get_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
      underline = false,
      virtual_text = false,
      update_in_insert = false
    }
  );
}

local function on_init(client)
  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', {settings = client.config.settings})
  end
end

local function on_attach(client, bufnr)
  -- print(vim.inspect(client))
  require('my.mappings').lsp(bufnr)
  require('my.autocmds').lsp(client, bufnr)
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
