if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-commentary'
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
call plug#end()


set number relativenumber
set wildmode=longest,list,full
syntax on
colorscheme gruvbox
set shiftwidth=4
set softtabstop=4
set noexpandtab
    
nnoremap H ^
nnoremap L $
let mapleader=" "
