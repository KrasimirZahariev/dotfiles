local M = {}

function M.setup()
  local dap = require('dap')

  dap.defaults.fallback.terminal_win_cmd = '15split new'
  dap.defaults.fallback.external_terminal = {
    command = os.getenv('TERMINAL');
    -- args = {'-e'};
  }

  -- dap.configurations.rust = {
  --   {
  --     name = "Launch Debug",
  --     type = "rt_lldb",
  --     request = "launch",
  --     program = function()
  --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/" .. "")
  --     end,
  --     cwd = "${workspaceFolder}",
  --     stopOnEntry = false,
  --     args = {},
  --     initCommand = {},
  --     -- runInTerminal = false,
  --   },
  -- }

  -- dap.defaults.fallback.force_external_terminal = true

  -- dap.configurations.java = {
  --   {
  --     type = 'java';
  --     request = 'attach';
  --     name = "🪲Remote";
  --     hostName = "10.10.10.10";
  --     port = 5005;
  --   },
  -- }

  -- dap.set_log_level('TRACE')

  require("mappings").debug()
end

function M.debug_app()
  require('dap').continue()
  require('dapui').toggle()
end


return M
