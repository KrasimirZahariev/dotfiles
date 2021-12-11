local helper = require('lua.my.helper')

local map = helper.map
local nmap = helper.nmap
local nnoremap = helper.nnoremap
local imap = helper.imap
local inoremap = helper.inoremap
local vmap = helper.vmap
local vnoremap = helper.vnoremap
local xmap = helper.xmap
local xnoremap = helper.xnoremap
local cmap = helper.cmap
local cnoremap = helper.cnoremap
local tmap = helper.tmap
local tnoremap = helper.tnoremap

local api = vim.api
local lsp = vim.lsp

local M = {}

vim.g.mapleader=";"

-- unmap s
map('s', '')

-- Don't yank when editing
nnoremap('D', '"_D')
nnoremap('X', '"_X')
nnoremap('x', '"_x')
nnoremap('C', '"_C')
nnoremap('c', '"_c')

--Yank till EOL
nnoremap('Y', 'y$')
--Yank all
nnoremap('ya', ':%y<CR>')
--Delete all
nnoremap('da', ':%d<CR>i')

--Go to EOL
nnoremap('H', '^')
vnoremap('H', '^')

--Go to BOL
nnoremap('L', '$')
vnoremap('L', '$')

--Redo
nnoremap('U', '<C-r>')

--Uppercase word
nnoremap('guiw', 'gUiwe')

--Fast play macro
nnoremap('Q', '@q')

--Remap since ';' is leader
nnoremap('<space>', ';')

--Replace
nnoremap('pl', '"_ddP')
nnoremap('pw', '"_diwP')
nnoremap('pa', '"_diaP')
nnoremap('p(', '"_di(P')
nnoremap('p)', '"_di)P')
nnoremap('p{', '"_di{P')
nnoremap('p}', '"_di}P')
nnoremap('p[', '"_di[P')
nnoremap('p]', '"_di]P')
nnoremap('p<', '"_di<P')
nnoremap('p>', '"_di>P')
nnoremap('p"', '"_di"P')
nnoremap('p\'', '"_di\'P')

--Paste and reyank
xnoremap('<C-v>', 'pgvy')
xnoremap('p', 'pgvy')

nnoremap('<C-y>', '<C-y>5')
nnoremap('<C-e>', '<C-e>5')

--Breaks <c-i>
--nnoremap('<Tab>', '%')

--Open file from path
nnoremap('<leader>o', 'gf', {silent=true})

--Split navigation
nnoremap('<C-h>', '<C-w><C-h>')
nnoremap('<C-j>', '<C-w><C-j>')
nnoremap('<C-k>', '<C-w><C-k>')
nnoremap('<C-l>', '<C-w><C-l>')
--Maximize current split
nnoremap('<C-m>', '<C-w>_<C-w><Bar>')

--Buffer navigation
nnoremap('<leader>q', ':bd<CR>')
nnoremap('<leader>b', ':Buffers<CR>')
nnoremap('<leader><Tab>', ':b#<CR>')
nnoremap('<leader>l', ':bnext<CR>')
nnoremap('<leader>h', ':bprevious<CR>')
nnoremap('<leader>1', ':bfirst<CR>')
nnoremap('<leader>2', ':bfirst<CR>:bn<CR>')
nnoremap('<leader>3', ':bfirst<CR>:2bn<CR>')
nnoremap('<leader>4', ':bfirst<CR>:3bn<CR>')
nnoremap('<leader>5', ':bfirst<CR>:4bn<CR>')
nnoremap('<leader>6', ':bfirst<CR>:5bn<CR>')
nnoremap('<leader>7', ':bfirst<CR>:6bn<CR>')
nnoremap('<leader>8', ':bfirst<CR>:7bn<CR>')
nnoremap('<leader>9', ':bfirst<CR>:8bn<CR>')

--Tabs
nnoremap('<leader>t', ':tabnew<CR>')

--Clear the highlighting of :set hlsearch.
nnoremap('<CR>', ':nohlsearch<CR>', {silent=true})

--Search results in the middle of the screen
nnoremap('n', 'nzz')
nnoremap('N', 'Nzz')

--Make <C-o> and <C-i> work with line movement
-- nnoremap <expr> j (v:count > 4 ? "m'--. v:count : "") . 'j'
-- nnoremap <expr> k (v:count > 4 ? "m'--. v:count : "") . 'k'

--Correct the last spelling mistake and that
inoremap('<C-s>', '<ESC>:set spell<CR>[s1z=<ESC>:set nospell<CR>A')

--Visual selection to the last non-blank char
nnoremap('vv', '^vg_')

--Move lines in visual
vnoremap('J', ':m\'>+1<CR>gv=gv')
vnoremap('K', ':m \'<-2<CR>gv=gv')

--Change the word under cursor and repeat the action
--for the next/previous one with .
nnoremap('c>', '*Ncgn')
nnoremap('c<', '#NcgN')

--Format code
nnoremap('<leader>fc', 'miggvG=`i')
vnoremap('<leader>fc', 'miggvG=`i')

--Check script with shellcheck
nnoremap('<leader>c', ':sp term://shellcheck -xas sh %<CR>')

--Search and replace word
nnoremap('cn', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/g<Left><Left>')
--Search and replace visual selection
vnoremap('cn', 'y:%s/<C-r>0/<C-r>0/g<Left><Left>')

--execute current line as shell command in terminal buffer
-- nnoremap('<leader>e', ':execute \'term \' .. getline(\'.\')<CR>')
--execute visual selection in shell
-- vnoremap('<leader>e', ':w !"$SHELL"<CR>')


inoremap('<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], {silent = true, expr = true})
inoremap('<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], {silent = true, expr = true})
inoremap('<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], {silent = true, expr = true})
inoremap('<CR>', [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]], {silent = true, expr = true})
inoremap('<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], {silent = true, expr = true})
inoremap('<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], {silent = true, expr = true})

function M.set_base_lsp_mappings(client, bufnr)
  local opts = {silent = true}

  local key_mappings = {
    {'goto_definition', 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>'},
    {'type_definition', 'n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>'},
    {'implementation', 'n', 'gi',  '<Cmd>lua vim.lsp.buf.implementation()<CR>'},
    {'find_references', 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>'},
    {'document_symbol', 'n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>'},
    {'workspace_symbol', 'n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>'},
    {'call_hierarchy', 'n', 'gc','<Cmd>lua vim.lsp.buf.incoming_calls()<CR>'},
    {'call_hierarchy', 'n', 'gC','<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>'},
    {'hover', 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>'},
    {'signature_help', 'i', '<C-p>',  '<Cmd>lua vim.lsp.buf.signature_help()<CR>'},
    {'document_formatting', 'n', '<leader>fc', '<Cmd>lua vim.lsp.buf.formatting()<CR>'},
    {'document_range_formatting', 'v', '<leader>fc', '<Esc><Cmd>lua vim.lsp.buf.range_formatting()<CR>'},
    {'rename', 'n', 'cn', '<Cmd>lua vim.lsp.buf.rename(vim.fn.input("New Name: "))<CR>'},
    {'code_action', 'n', '<A-CR>', '<Cmd>lua vim.lsp.buf.code_action()<CR>'},
    {'code_action', 'v', '<A-CR>', '<Esc><Cmd>lua vim.lsp.buf.range_code_action()<CR>'},
    {'code_action', 'n', '<leader>r', '<Cmd>lua vim.lsp.buf.code_action {only = "refactor"}<CR>'},
    {'code_action', 'v', '<leader>r', '<Esc><Cmd>lua vim.lsp.buf.range_code_action {only = "refactor"}<CR>'}
  }

  for _, mappings in pairs(key_mappings) do
    local capability, mode, lhs, rhs = unpack(mappings)
    if client.resolved_capabilities[capability] then
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
  end

  nnoremap('<space>', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts, bufnr)
  nnoremap('ge', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts, bufnr)
  nnoremap('gE', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts, bufnr)

  if lsp.codelens and client.resolved_capabilities['code_lens'] then
    nnoremap('<leader>cr', '<Cmd>lua vim.lsp.codelens.refresh()<CR>', opts, bufnr)
    nnoremap('<leader>z', '<Cmd>lua vim.lsp.codelens.run()<CR>', opts, bufnr)
  end
end

function M.set_jdtls_mappings(bufnr)
  local opts = {silent = true}
  nnoremap('<A-i>', '<Cmd>lua require("jdtls").organize_imports()<CR>', opts, bufnr)
  nnoremap('em', '<Cmd>lua require("jdtls").extract_method()<CR>', opts, bufnr)
  vnoremap('em', '<Cmd>lua require("jdtls").extract_method()<CR>', opts, bufnr)
  nnoremap('ev', '<Cmd>lua require("jdtls").extract_variable()<CR>', opts, bufnr)
  vnoremap('ev', '<Cmd>lua require("jdtls").extract_variable()<CR>', opts, bufnr)
  nnoremap('ec', '<Cmd>lua require("jdtls").extract_constant()<CR>', opts, bufnr)
  vnoremap('ec', '<Cmd>lua require("jdtls").extract_constant()<CR>', opts, bufnr)
end

function M.set_debug_mappings()
  nnoremap('<A-;>', '<Cmd>lua require("dap").continue()<CR>')
  nnoremap('<A-j>', '<Cmd>lua require("dap").step_over()<CR>')
  nnoremap('<A-l>', '<Cmd>lua require("dap").step_into()<CR>')
  nnoremap('<A-h>', '<Cmd>lua require("dap").step_out()<CR>')

  nnoremap('<leader>du', '<Cmd>lua require("dapui").toggle()<CR>')
  nnoremap('<leader>de', '<Cmd>lua require("dapui").eval(<expression>)<CR>')
  nnoremap('<leader>df', '<Cmd>lua require("dapui").float_element("scopes")<CR>')
  nnoremap('<leader>dp', '<Cmd>lua require("dap").toggle_breakpoint()<CR>')
  nnoremap('<leader>dc', '<Cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
  nnoremap('<leader>dl', '<Cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
  nnoremap('<leader>dh', '<Cmd>lua require("dap").set_breakpoint(nil, vim.fn.input("Hit condition: "), nil)<CR>')

  -- nnoremap('<leader>dr', '<Cmd>lua require("dap").repl.open()<CR>')
  -- nnoremap('<leader>dl', '<Cmd>lua require("dap").run_last()<CR>')
  -- nnoremap('<leader>dl', '<Cmd>lua require("dap").set_exception_breakpoints({"raised", "uncaught"})<CR>')

  -- nnoremap("<leader>df", "<Cmd>lua require('lua.my.dap'); require'jdtls'.test_class()<CR>", opts, bufnr)
  -- nnoremap("<leader>dn", "<Cmd>lua require('lua.my.dap'); require'jdtls'.test_nearest_method()<CR>", opts, bufnr)

  -- TODO: function to launch/debug app
  nnoremap('<leader>ra', '<Esc><Cmd>lua require("lua.my.dap").debug_app()<CR>')
end

------Command mode
--Movement
cnoremap('<C-h>', '<left>')
cnoremap('<C-j>', '<down>')
cnoremap('<C-k>', '<up>')
cnoremap('<C-l>', '<right>')
cnoremap('<C-a>', '<home>')
cnoremap('<C-e>', '<end>')
cnoremap('<C-w>', '<s-right>')
cnoremap('<C-b>', '<s-left>')


--Use tab/<s-tab> instead of <C-g>/<C-t>
-- cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<C-g>--: "<C-z>"
-- cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<C-t>--: "<S-Tab>"

------Terminal mode
--Leave terminal mode
tnoremap('<esc><esc>', '<C-\\><C-n>')

------Exchange
nmap('xl', 'cxx')
nmap('xw', 'cxiw')
nmap('xa', 'cxia')
nmap('x(', 'cxi(')
nmap('x)', 'cxi)')
nmap('x{', 'cxi{')
nmap('x}', 'cxi}')
nmap('x[', 'cxi[')
nmap('x]', 'cxi]')
nmap('x<', 'cxi<')
nmap('x>', 'cxi>')
nmap('x"', 'cxi"')
nmap('x\'', 'cxi\'')
nmap('xc', 'cxc')

------Undotree
nnoremap('<Leader>u', ':UndotreeShow<CR>')

------CtrlSF
--Find usages
-- nmap us <Plug>CtrlSFCwordPath<CR>

------NERDTree
-- nnoremap <Leader>nt :call NerdTreeToggleFind()<CR>

------TestVim
-- nnoremap <silent> tn :TestNearest<CR>
-- nnoremap <silent> tf :TestFile<CR>
-- nnoremap <silent> ts :TestSuite<CR>
-- nnoremap <silent> tl :TestLast<CR>
-- nnoremap <silent> tv :TestVisit<CR>

------VistaVim
-- nnoremap <Leader>v :<C-u>call vista#sidebar#Toggle()<CR>
-- autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> q :<C-u>call vista#sidebar#Close()<CR>
-- autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> o :<C-u>call vista#cursor#FoldOrJump()<CR>
-- autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> p :<C-u>call vista#cursor#TogglePreview()<CR>
-- autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> i :<C-u>call vista#cursor#lsp#GetInfo()<CR>
-- autocmd vimrc FileType vista,vista_kind nnoremap <buffer> <silent> / :<C-u>call vista#finder#fzf#Run()<CR>

------FZF
-- nnoremap gf :Files<CR>
--
return M
