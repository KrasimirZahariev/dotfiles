let mapleader=" "

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                        PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'kmARC/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dadbod', { 'on': ['DB', 'DBUI'] }
Plug 'kristijanhusak/vim-dadbod-ui', { 'on': ['DB', 'DBUI'] }
Plug 'junegunn/fzf.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'unblevable/quick-scope'
Plug 'liuchengxu/vista.vim', {'for': ['java']}
Plug 'jiangmiao/auto-pairs'
Plug 'wellle/targets.vim'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-signify'
Plug 'junegunn/gv.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'puremourning/vimspector', {'for': 'java'}
Plug 'vim-test/vim-test', {'for': 'java'}
Plug 'uiiaoo/java-syntax.vim', {'for': 'java'}
Plug 'machakann/vim-highlightedyank'
Plug 'psliwka/vim-smoothie'
Plug 'ap/vim-css-color'
Plug 'ThePrimeagen/vim-be-good', { 'on': 'VimBeGood' }
Plug 'Yggdroot/indentLine'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'takac/vim-hardtime'
Plug 'ryanoasis/vim-devicons'
Plug 'bfrg/vim-cpp-modern', {'for': ['cpp', 'c']}
Plug 'TaDaa/vimade'
call plug#end()

source $XDG_CONFIG_HOME/nvim/plug-config.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                        SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc
  autocmd!
augroup END

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg=#ffffff gui=underline,bold
  autocmd ColorScheme * highlight QuickScopeSecondary guifg=#5fffff gui=underline,bold
augroup END

colorscheme gruvbox
syntax on

highlight CocWarningSign guifg=#fabd2f
highlight CocWarningFloat guifg=#fabd2f
highlight CocWarningHighlight guisp=#fabd2f
highlight CocHighlightText guibg=#665c54


set termguicolors
set guifont=Fira\ Code\ Regular\ Nerd\ Font\ Complete:h13
set encoding=utf-8
set autoread
set history=5000
set backspace=indent,eol,start
set complete-=i
set mouse=a
set hidden
set timeout
set timeoutlen=350
set updatetime=100
set cursorline
set ruler
set number
set relativenumber
set nrformats-=octal
set incsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=longest:full,full
set autoindent
set tabstop=2 shiftwidth=2 expandtab
set clipboard=unnamedplus
set lazyredraw
set splitbelow
set splitright
set sessionoptions-=options
set viewoptions-=options
set undofile
set undodir=$XDG_CONFIG_HOME/nvim/undodir
set noswapfile
set nobackup
set nowritebackup
set inccommand=nosplit
set cmdheight=1
set shortmess+=c
set signcolumn=yes
set nowrapscan
set nowrap
set display+=lastline
set scrolloff=5
set sidescrolloff=5
set formatoptions+=j
set list
set listchars=tab:>>\ ,extends:⟩,precedes:⟨
" set foldmethod=syntax
" set foldenable
" syn region foldImports start="import" end=/import.*\n^$/ fold keepend
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                          MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------General
nnoremap D "_D
nnoremap X "_X
nnoremap x "_x
nnoremap C "_C
nnoremap c "_c
nnoremap Y y$
nnoremap H ^
nnoremap L $
nnoremap Q @q

" delete inner and paste
nnoremap piw "_diwP
nnoremap pi{ "_di{P
nnoremap pi} "_di}P
nnoremap pi( "_di(P
nnoremap pi) "_di)P
nnoremap pi' "_di'P
nnoremap pi" "_di"P

" paste latest yank
nnoremap <Leader>p "0p
" replace visual selection with yank and reuse it
xnoremap <C-v> "+pgvy

nnoremap <TAB> %
nnoremap <silent> gf <C-w>f:q<CR>:bnext<CR>
nnoremap <Leader>w :w<CR>

" Split navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
" Maximize current split
nnoremap <C-m> <C-w>_<C-w><Bar>

" Buffer navigation
nnoremap <Leader>1 :bfirst<CR>
nnoremap <Leader>2 :bfirst<CR>:bn<CR>
nnoremap <Leader>3 :bfirst<CR>:2bn<CR>
nnoremap <Leader>4 :bfirst<CR>:3bn<CR>
nnoremap <Leader>5 :bfirst<CR>:4bn<CR>
nnoremap <Leader>6 :bfirst<CR>:5bn<CR>
nnoremap <Leader>7 :bfirst<CR>:6bn<CR>
nnoremap <Leader>8 :bfirst<CR>:7bn<CR>
nnoremap <Leader>9 :bfirst<CR>:8bn<CR>
nnoremap <Leader>l :bnext<CR>
nnoremap <Leader>h :bprevious<CR>
nnoremap <Leader>q :bd<CR>
" Toggle between two buffers
nnoremap <Leader><TAB> :b#<CR>

" Tabs
nnoremap <Leader>t :tabnew<cr>

" clear the highlighting of :set hlsearch.
nnoremap <silent> <CR> :nohlsearch<CR>

" correct the last spelling mistake
inoremap <C-s> <ESC>:set spell<CR>[s1z=<ESC>:set nospell<CR>A

" quick visual selection
nnoremap vv ^vg_

" Dot-able visual
vnoremap . :norm. &lt;CR&lt;<CR>

" move lines in visual
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" change the word under cursor and repeat the action
" for the next/previous one with .
nnoremap c> *Ncgn
nnoremap c< #NcgN

" Indent everything
nnoremap <Leader>= miggvG=`i

" q to quit the help menu
function! s:at_help()
  if &buftype == 'help'
    nnoremap <buffer> <silent> q :q<CR>
  endif
endfunction

"------Command mode
" Movement
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-w> <s-right>
cnoremap <c-b> <s-left>

" nnoremap <Leader><CR> :vnew | terminal
"------Terminal mode
" leave terminal mode
tnoremap <Esc><Esc> <C-\><C-n>
autocmd vimrc TermOpen * nnoremap <buffer> <Leader>q :bd!<CR>

"------CtrlSF
" Search the word under the cursor
nmap <leader>s <Plug>CtrlSFCwordPath<CR>

"------UndoTree
nnoremap <Leader>u :UndotreeShow<CR>
" Remapping function
function g:Undotree_CustomMap()
  "Select the current state
  map <buffer> o <cr>
endfunction

"------NERDTree
nnoremap <C-n> :call NerdTreeToggleFind()<CR>

"------TestVim
nnoremap <silent> tn :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
nnoremap <silent> tl :TestLast<CR>
nnoremap <silent> tv :TestVisit<CR>

"------VistaVim
nnoremap <Leader>v :<c-u>call vista#sidebar#Toggle()<CR>
autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> q :<c-u>call vista#sidebar#Close()<CR>
autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> o :<c-u>call vista#cursor#FoldOrJump()<CR>
autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> p :<c-u>call vista#cursor#TogglePreview()<CR>
autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> i :<c-u>call vista#cursor#lsp#GetInfo()<CR>
autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<CR>

"------FZF
nnoremap <leader>o :Files<CR>

"------CoC
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" make <cr> select the first completion item, confirm the completion
" when no item has been selected and reformat the code.
if exists('*complete_info')
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use K to show documentation in preview window.
" Don't forget to install JDK source
nmap <silent> <Leader>i :call <SID>show_documentation()<CR>

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>fs  <Plug>(coc-format-selected)
nmap <Leader>fs  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
xmap <Leader>as  <Plug>(coc-codeaction-selected)
nmap <Leader>as  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>a  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>af  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                      AUTOCMD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically reload .vimrc file on save
autocmd vimrc BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
" q to quit help
autocmd vimrc BufEnter *.txt call s:at_help()

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd vimrc BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" Delete trailing whitespaces and new lines on save
autocmd vimrc BufWritePre * %s/\s\+$//e
autocmd vimrc BufWritepre * %s/\n\+\%$//e

" Highlight yank
if exists('##TextYankPost')
  autocmd vimrc TextYankPost * silent! lua require'vim.highlight'.on_yank('Substitute', 200)
endif

" Disables automatic commenting on newline
autocmd vimrc FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" json = javascript syntax highlight
autocmd vimrc FileType json setlocal syntax=javascript
" Match json comments
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+

" Less syntax highlight for long XML lines by default
autocmd vimrc FileType xml setlocal wrap synmaxcol=300
autocmd vimrc FileType xml nnoremap <buffer> <leader>H :setlocal synmaxcol=300<CR>
" Enable if necessary
" autocmd vimrc FileType xml nnoremap <buffer> <leader>h :setlocal synmaxcol=0<CR>

"------FZF
autocmd vimrc FileType fzf set laststatus=0 noshowmode noruler nonumber
      \| autocmd vimrc BufLeave <buffer> set laststatus=2 showmode ruler

"------NERDTree
" close vim if the only window left open is a NERDTree
autocmd vimrc BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"------CoC
" Highlight the symbol and its references when holding the cursor.
autocmd vimrc CursorHold * silent call CocActionAsync('highlight')
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                      FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"------NerdTree
function! NerdTreeToggleFind()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeClose
  elseif filereadable(expand('%'))
    NERDTreeFind
  else
    NERDTree
  endif
endfunction

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

"------CoC
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"------Redir
function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . " <<< $" . cleaned_lines)
    endif
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction

"------CheckoutBranch with fzf
function! s:changebranch(branch)
  execute 'Git checkout' . a:branch
endfunction

function! CheckoutBranch()
  let dir = expand('%:h')
  let fzf_source = 'git -C '.dir.' branch -r | sed "s/ origin\///"'
  let branch = fzf#run(fzf#wrap({'source':fzf_source, 'sink': function('s:changebranch')}))
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"			                        COMMANDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Ev execute ":e $MYVIMRC"
command! Sv execute ":source $MYVIMRC"

" Save file as sudo
command! W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

command! Gbranch call CheckoutBranch()
cabbrev gb Gbranch

"------CoC
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
