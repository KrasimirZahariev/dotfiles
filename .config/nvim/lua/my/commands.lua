-- vim.cmd('command! Ev execute ":e '..os.getenv('MYVIMRC')..'"')

vim.cmd([[
" Save file as sudo
command! W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

command! Gbranch call CheckoutBranch()
cabbrev gb Gbranch
]])
