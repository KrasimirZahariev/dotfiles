vim.cmd([[
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" q to quit the help menu
function! g:Help_buffer_mappings()
  if &buftype == 'help'
    nnoremap <buffer> <silent> q :q<CR>
  endif
endfunction

function! DrawColumnIfLineTooLong(maxAllowedLength)
  let longestLineLength = max(map(getline(1,'$'), 'len(v:val)'))

  if longestLineLength > a:maxAllowedLength
    execute "set colorcolumn=" . (a:maxAllowedLength + 1)
  else
    set colorcolumn=0
  endif
endfunction

" Remapping function
function g:Undotree_CustomMap()
  "Select the current state
  map <buffer> o <CR>
endfunction

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

"------CheckoutBranch with fzf
function! g:Changebranch(branch)
  execute 'Git checkout' . a:branch
endfunction

function! CheckoutBranch()
  let dir = expand('%:h')
  let fzf_source = 'git -C '.dir.' branch -r | sed "s/ origin\///"'
  let branch = fzf#run(fzf#wrap({'source':fzf_source, 'sink': function('s:changebranch')}))
endfunction
]])
