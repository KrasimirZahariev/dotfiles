local fn = vim.fn
local INSTALL_PATH = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

local packer_bootstrap
---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(INSTALL_PATH)) > 0 then
  packer_bootstrap = fn.system({
    "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", INSTALL_PATH
  })
end

-- NOTE: If you use a function value for config or setup keys in any plugin specifications,
-- it must not have any upvalues (i.e. captures).
return require("packer").startup(function(use, packer)
  local config = require("my.plugins-config")

  use "lewis6991/impatient.nvim"
  use "wbthomason/packer.nvim"
  use {"antoinemadec/FixCursorHold.nvim",     config = config.fix_cursor_hold}
  use "sainnhe/gruvbox-material"
  use "tpope/vim-repeat"
  use "tpope/vim-commentary"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  use {"unblevable/quick-scope",              config = config.quick_scope}
  use {"mbbill/undotree",                     cmd = "UndotreeToggle", config = config.undotree}
  use {"norcalli/nvim-colorizer.lua",         opt = true, cmd = "ColorizerToggle"}
  use {"mboughaba/i3config.vim",              ft = "i3config"}
  use "psliwka/vim-smoothie"
  use "tommcdo/vim-exchange"
  use "wellle/targets.vim"
  use "nvim-lua/plenary.nvim"
  use {"hrsh7th/nvim-cmp",                    config = config.cmp}
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "dmitmel/cmp-cmdline-history"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  use {"hrsh7th/cmp-nvim-lsp"}
  use {"hrsh7th/cmp-nvim-lsp-signature-help"}
  use {"hrsh7th/cmp-nvim-lua"}
  use {"folke/neodev.nvim",                   config = config.neodev}
  use {"neovim/nvim-lspconfig",               after = "neodev.nvim"}
  use {"j-hui/fidget.nvim",                   config = config.fidget}
  use {"lewis6991/satellite.nvim",            config = config.satellite}
  use {"mfussenegger/nvim-jdtls"}
  use {"simrat39/rust-tools.nvim"}
  use {"weilbith/nvim-code-action-menu",      config = config.nvim_code_action_menu}
  use {"lvimuser/lsp-inlayhints.nvim",        config = config.lsp_inlayhints}
  use {"mfussenegger/nvim-dap"}
  use {"rcarriga/nvim-dap-ui",                config = config.dapui}
  use {"kyazdani42/nvim-web-devicons",        config = config.devicons}
  use {"nvim-lualine/lualine.nvim",           config = config.lualine}
  use {"nvim-treesitter/nvim-treesitter",     run = ":TSUpdate", config = config.treesitter}
  use {"nvim-treesitter/playground",          opt = true, cmd = "TSPlaygroundToggle"}
  use "jbyuki/venn.nvim"
  use "romainl/vim-cool"
  use "PeterRincker/vim-searchlight"
  use "junegunn/vim-easy-align"
  use {"kyazdani42/nvim-tree.lua",            config = config.nvim_tree}
  use {"lukas-reineke/indent-blankline.nvim", config = config.indent_blakline}
  use {"ggandor/leap.nvim",                   config = config.leap}
  use {"lewis6991/gitsigns.nvim",             config = config.gitsigns}
  use {"smjonas/live-command.nvim",           config = config.live_command}
  -- use {"zbirenbaum/neodim",                config = config.neodim}
  use {"kylechui/nvim-surround",              config = config.nvim_surround}
  use "tpope/vim-dadbod"
  use {"kristijanhusak/vim-dadbod-ui",        config = config.dadbod_ui}
  use "kristijanhusak/vim-dadbod-completion"
  use "famiu/bufdelete.nvim"
  use {"theHamsta/nvim-dap-virtual-text",     config = config.nvim_dap_virtual_text}
  use {"ibhagwan/fzf-lua",                    config = config.fzf}
  use {'Weissle/persistent-breakpoints.nvim', config = config.persistent_breakpoints}
  use {"natecraddock/sessions.nvim",          config = config.sessions}
  use {"natecraddock/workspaces.nvim",        config = config.workspaces}

  use {"akinsho/git-conflict.nvim",           config = config.git_conflict}

  use "kevinhwang91/nvim-bqf"


  -- use "stevearc/dressing.nvim"
  -- use {"gbprod/substitute.nvim"}
  -- use {ja-ford/delaytrain.nvim"}
  -- use "anuvyklack/hydra.nvim"
  -- use "andymass/vim-matchup"
  -- use "nvim-treesitter/nvim-treesitter-textobjects"
  -- use "rmagatti/auto-session"
  -- use "ldelossa/litee.nvim"
  -- use "sindrets/diffview.nvim"
  -- use "ray-x/lsp_signature.nvim"
  -- use "jbyuki/one-small-step-for-vimkind"
  -- use "nanotee/luv-vimdocs"
  -- use "rcarriga/cmp-dap"
  -- use "vim-scripts/dbext.vim"
  -- use "smjonas/inc-rename.nvim"
  -- use "mhinz/vim-grepper
  -- use "ThePrimeagen/refactoring.nvim"

  -- use "dyng/ctrlsf.vim"
  -- use {"liuchengxu/vista.vim", {"for": ["java"]}}
  -- use "junegunn/gv.vim"
  -- use {"puremourning/vimspector", {"for": "java"}}
  -- use {"vim-test/vim-test", {"for": "java"}}
  -- use {"ThePrimeagen/vim-be-good", { "on": "VimBeGood" }
  -- use "takac/vim-hardtime"
  -- use "rstacruz/vim-closer"
  -- use "shumphrey/fugitive-gitlab.vim"



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    packer.sync()
  end
end)
