local set = require('lua.my.helper').set

set('termguicolors')
set('guifont', 'Fira Code Regular Nerd Font Complete:h13')
set('encoding', 'utf-8')
set('selection', 'old')
set('autoread')
set('history', 5000)
set('backspace', 'indent,eol,start')
set('complete', '-i')
set('mouse', 'a')
set('hidden')
set('timeout')
set('timeoutlen', 220)
set('updatetime', 100)
set('cursorline')
set('ruler')
set('number')
set('relativenumber')
set('nrformats', '+alpha')
set('incsearch')
set('ignorecase')
set('smartcase')
set('wildmenu')
set('wildmode', 'longest:full,full')
set('wildcharm', 26) -- <C-z>
set('autoindent')
set('tabstop', 2)
set('shiftwidth', 2)
set('expandtab')
set('clipboard', '+unnamedplus')
set('lazyredraw')
set('splitbelow')
set('splitright')
set('sessionoptions', '-options')
set('viewoptions', '-options')
set('undofile')
set('undodir', os.getenv('XDG_DATA_HOME')..'/nvim/undodir')
set('swapfile', false)
set('backup', false)
set('writebackup', false)
set('inccommand', 'nosplit')
set('cmdheight', 1)
set('shortmess', '+c')
set('signcolumn', 'auto')
set('wrapscan')
set('wrap', false)
set('display', '+lastline')
set('scrolloff', 5)
set('sidescrolloff', 5)
set('formatoptions', '+j')
set('list')
set('listchars', 'tab:>>,extends:⟩,precedes:⟨')
-- set('foldmethod', 'syntax')
-- set('foldenable')
-- vim.cmd('syn region foldImports start="import" end=/import.*\\n^$/ fold keepend')

vim.cmd('colorscheme gruvbox')
vim.cmd('syntax on')

vim.cmd([[
highlight LspReference guifg=#000000 guibg=#b8bb26 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=NONE
hi! def link LspReferenceText LspReference
hi! def link LspReferenceRead LspReference
hi! def link LspReferenceWrite LspReference
hi! def link LspCodeLens Include
hi! def link LspSignatureActiveParameter WarningMsg
hi! def link NormalFloat Normal

sign define DiagnosticSignError text= texthl= linehl= numhl=GruvboxRedSign
sign define DiagnosticSignWarn text= texthl= linehl= numhl=GruvboxYellowSign
sign define DiagnosticSignInfo text= texthl= linehl= numhl=GruvboxBlueSign
sign define DiagnosticSignHint text= texthl= linehl= numhl=GruvboxGreenSign
]])
