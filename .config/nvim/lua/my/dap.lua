local dap = require('dap')
local mappings = require('lua.my.mappings')

local M = {}

function M.setup()
  dap.defaults.fallback.terminal_win_cmd = '15split new'
  dap.defaults.fallback.external_terminal = {
    command = os.getenv('TERMINAL');
    -- args = {'-e'};
  }

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

  mappings.set_debug_mappings()
end

function M.debug_app()
  require('dap').continue()
  require('dapui').toggle()
end

M.setup()

return M
