local M = {}

function M.setup(base_config)
  require('rust-tools').setup({
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
      hover_with_actions = false,
      inlay_hints = {
        only_current_line = true,
        show_parameter_hints = false,
      }
    },

    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(
          '/usr/lib/codelldb/adapter/codelldb',
          '/usr/lib/codelldb/adapter/libcodelldb.so'
        ),
      -- adapter = {
      --   type = "executable",
      --   command = "lldb-vscode",
      --   name = "rt_lldb",
      -- },
    }
  })
  -- require("lspconfig").rust_analyzer.setup {
  --   settings = {
  --     ["rust-analyzer"] = {
  --       assist = {
  --         importGranularity = "module",
  --         importPrefix = "self",
  --       },
  --       checkOnSave = {
  --         command = "clippy"
  --       },
  --       cargo = {
  --         loadOutDirsFromCheck = true
  --       },
  --       procMacro = {
  --         enable = true
  --       },
  --     }
  --   };

  --   flags = base_config.flags;
  --   handlers = base_config.handlers;
  --   capabilities = base_config.capabilities;
  --   on_init = base_config.on_init;
  --   on_attach = base_config.on_attach;
  -- }
end

return M
