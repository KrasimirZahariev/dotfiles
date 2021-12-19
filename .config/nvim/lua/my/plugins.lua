local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'unblevable/quick-scope'
  use 'mbbill/undotree'
  use 'uiiaoo/java-syntax.vim'
  use 'machakann/vim-highlightedyank'
  use 'psliwka/vim-smoothie'
  use 'ap/vim-css-color'
  use 'TaDaa/vimade'
  use 'mboughaba/i3config.vim'
  use 'tommcdo/vim-exchange'
  use 'wellle/targets.vim'
  use 'nvim-lua/plenary.nvim'
  use 'neovim/nvim-lspconfig'
  use 'ms-jpq/coq_nvim'
  use 'mfussenegger/nvim-jdtls'
  use 'mfussenegger/nvim-dap'
  use {"rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}}
  use 'kosayoda/nvim-lightbulb'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'akinsho/bufferline.nvim'

  -- use 'jbyuki/one-small-step-for-vimkind'
  -- use 'norcalli/nvim-colorizer.lua'
  -- use 'vim-scripts/dbext.vim'
  -- use 'jbyuki/venn.nvim'

  -- use {'tpope/vim-dadbod', { 'on': ['DB', 'DBUI'] }}
  -- use {'kristijanhusak/vim-dadbod-ui', { 'on': ['DB', 'DBUI'] }}
  -- use 'junegunn/fzf.vim'
  -- use 'dyng/ctrlsf.vim'
  -- use {'liuchengxu/vista.vim', {'for': ['java']}}
  -- use 'mhinz/vim-signify'
  -- use 'junegunn/gv.vim'
  -- use 'preservim/nerdtree'
  -- use {'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }}
  -- use 'neoclide/coc.nvim', {'branch': 'release'}
  -- use 'honza/vim-snippets'
  -- use {'puremourning/vimspector', {'for': 'java'}}
  -- use {'vim-test/vim-test', {'for': 'java'}}
  -- use {'uiiaoo/java-syntax.vim', ft = 'java'}
  -- use {'ThePrimeagen/vim-be-good', { 'on': 'VimBeGood' }
  -- use 'Yggdroot/indentLine'
  -- use 'vim-airline/vim-airline'
  -- use 'vim-airline/vim-airline-themes'
  -- use 'takac/vim-hardtime'
  -- use {'bfrg/vim-cpp-modern', {'for': ['cpp', 'c']}}
  -- use 'rstacruz/vim-closer'
  -- use 'shumphrey/fugitive-gitlab.vim'

  -- Lazy loading:
  -- Load on specific commands
  -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  -- use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  -- use {
  --   'w0rp/ale',
  --   ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --   cmd = 'ALEEnable',
  --   config = 'vim.cmd[[ALEEnable]]'
  -- }

  -- Plugins can have dependencies on other plugins
  -- use {
  --   'haorenW1025/completion-nvim',
  --   opt = true,
  --   requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  -- }

  -- Plugins can also depend on rocks from luarocks.org:
  -- use {
  --   'my/supercoolplugin',
  --   rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
  -- }

  -- You can specify rocks in isolation
  -- use_rocks 'penlight'
  -- use_rocks {'lua-resty-http', 'lpeg'}

  -- Post-install/update hook with neovim command
  -- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Use specific branch, dependency and run lua file after load
  -- use {
  --   'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
  --   requires = {'kyazdani42/nvim-web-devicons'}
  -- }

  -- Use dependency and run lua function after load
  -- use {
  --   'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
  --   config = function() require('gitsigns').setup() end
  -- }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if Packer_bootstrap then
    packer.sync()
  end
end)
