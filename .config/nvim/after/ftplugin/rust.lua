local base_config = require("my.lsp").get_config()
require("rust-tools").setup({
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "self",
        },
        checkOnSave = {
          command = "clippy"
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = false
        },
      }
    };

    flags = base_config.flags;
    handlers = base_config.handlers;
    capabilities = base_config.capabilities;
    on_init = base_config.on_init;
    on_attach = base_config.on_attach;
  },

  tools = {
    inlay_hints = {
      show_parameter_hints = false,
    }
  },

  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(
        "/usr/lib/codelldb/adapter/codelldb",
        "/usr/lib/codelldb/adapter/libcodelldb.so"
      ),
    -- adapter = {
    --   type = "executable",
    --   command = "lldb-vscode",
    --   name = "rt_lldb",
    -- },
  }
})
