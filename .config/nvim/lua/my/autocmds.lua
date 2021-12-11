-- https://github.com/neovim/neovim/pull/14661

local M = {}

vim.cmd([[
augroup vimrc
  autocmd!
augroup END
]])

vim.cmd([[
autocmd vimrc ColorScheme * highlight QuickScopePrimary guifg=#ffffff gui=underline,bold
autocmd vimrc ColorScheme * highlight QuickScopeSecondary guifg=#5fffff gui=underline,bold
]])

-- Reload vimrc on save
vim.cmd('autocmd vimrc BufWritePost $MYVIMRC source $MYVIMRC')

-- Reload tmux.conf on save
vim.cmd([[
autocmd vimrc BufWritePost $XDG_CONFIG_HOME/tmux/tmux.conf
      \ silent! !tmux source $XDG_CONFIG_HOME/tmux/tmux.conf && tmux display "CONFIG RELOADED"
]])

-- Reload i3 config on save
vim.cmd('autocmd vimrc BufWritePost $XDG_CONFIG_HOME/i3/config silent! !i3-msg restart')

-- Reload polybar config on save
vim.cmd('autocmd vimrc BufWritePost $XDG_CONFIG_HOME/polybar/config silent! !i3-msg restart')

-- q to exit help
vim.cmd('autocmd vimrc BufEnter *.txt call g:Help_buffer_mappings()')

-- q to exit terminal
vim.cmd('autocmd vimrc TermOpen * nnoremap <buffer> <Leader>q :bd!<CR>')

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.cmd([[
autocmd vimrc BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
]])

-- Delete trailing whitespaces and new lines on save
vim.cmd([[
autocmd vimrc BufWritePre * %s/\s\+$//e
autocmd vimrc BufWritepre * %s/\n\+\%$//e
]])

-- Highlight yank
vim.cmd([[
if exists('##TextYankPost')
  autocmd vimrc TextYankPost * silent! lua require'vim.highlight'.on_yank('Substitute', 200)
endif
]])

-- Disables automatic commenting on newline
vim.cmd('autocmd vimrc FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o')

-- Json = Javascript syntax highlight
vim.cmd('autocmd vimrc FileType json setlocal syntax=javascript')
-- Match json comments
vim.cmd('autocmd vimrc FileType json syntax match Comment +\\/\\/.\\+$+')

-- Less syntax highlight for long XML lines by default
vim.cmd([[
autocmd vimrc FileType xml setlocal wrap synmaxcol=300
autocmd vimrc FileType xml nnoremap <buffer> <Leader>H :setlocal synmaxcol=300<CR>
" Enable if necessary
" autocmd vimrc FileType xml nnoremap <buffer> <Leader>h :setlocal synmaxcol=0<CR>
]])

-------FZF
vim.cmd([[
autocmd vimrc FileType fzf set laststatus=0 noshowmode noruler nonumber
      \| autocmd vimrc BufLeave <buffer> set laststatus=2 showmode ruler
]])

-------NERDTree
-- Close vim if the only window left open is a NERDTree
--autocmd vimrc BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

--vim.cmd('autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

vim.cmd([[
autocmd vimrc FileType sh
      \ autocmd vimrc BufEnter,TextChangedI,TextChanged <buffer> :call DrawColumnIfLineTooLong(100)
]])


vim.cmd('autocmd vimrc FileType dap-repl lua require("dap.ext.autocompl").attach()')

vim.cmd([[
autocmd vimrc FileType java
  \ autocmd vimrc InsertLeave *
    \ if &readonly==0 && filereadable(bufname('%'))
    \ | silent update
    \ | endif

]])

function M.lsp(client, bufnr)
  if client.resolved_capabilities['document_highlight'] then
    vim.cmd(string.format('autocmd vimrc CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
    vim.cmd(string.format('autocmd vimrc CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
    vim.cmd(string.format('autocmd vimrc CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()', bufnr))
  end

  -- vim.cmd('autocmd vimrc DiagnosticChanged redrawstatus!')

  -- if vim.lsp.codelens and client.resolved_capabilities['code_lens'] then
    -- vim.cmd(string.format('au BufEnter,BufModifiedSet,InsertLeave <buffer=%d> lua vim.lsp.codelens.refresh()', bufnr))
  -- end
end

vim.cmd('autocmd vimrc FileType * lua require("lua.my.ls").setup()')


return M
