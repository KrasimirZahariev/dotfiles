local M = {}

local helper    = require("my.helper")
local functions = require("my.functions")

---@diagnostic disable-next-line: unused-local
local map       = helper.map
local nmap      = helper.nmap
local nnoremap  = helper.nnoremap
---@diagnostic disable-next-line: unused-local
local imap      = helper.imap
local inoremap  = helper.inoremap
local vmap      = helper.vmap
local vnoremap  = helper.vnoremap
local xmap      = helper.xmap
local xnoremap  = helper.xnoremap
---@diagnostic disable-next-line: unused-local
local cmap      = helper.cmap
local cnoremap  = helper.cnoremap
---@diagnostic disable-next-line: unused-local
local tmap      = helper.tmap
local tnoremap  = helper.tnoremap

local SILENT = {silent = true}

vim.g.mapleader = ";"

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

-- Save
nnoremap('<leader>w', ':update<CR>')

--Uppercase word
nnoremap('guiw', 'gUiwe')

--Fast play macro
nnoremap('Q', '@q')

--Remap since ';' is leader
nnoremap('<space>', ';')

--Replace
nnoremap('pl',  '"_ddP')
nnoremap('pw',  '"_diwP')
nnoremap('pa',  '"_diaP')
nnoremap('p(',  '"_di(P')
nnoremap('p)',  '"_di)P')
nnoremap('p{',  '"_di{P')
nnoremap('p}',  '"_di}P')
nnoremap('p[',  '"_di[P')
nnoremap('p]',  '"_di]P')
nnoremap('p<',  '"_di<P')
nnoremap('p>',  '"_di>P')
nnoremap('p"',  '"_di"P')
nnoremap('p\'', '"_di\'P')

--Paste and reyank
xnoremap('<C-v>', 'pgvy')
xnoremap('p',     'pgvy')

nnoremap('<C-y>', '<C-y>5')
nnoremap('<C-e>', '<C-e>5')

-- Back and forth matching pairs
nnoremap('<Tab>', '%')
vnoremap('<Tab>', '%')
nnoremap('<C-i>', '<C-i>')

--Open file from path
nnoremap('<leader>o', 'gf', SILENT)

-- Open file
nnoremap('gf', ':FzfLua files<CR>', SILENT)

--Split navigation
nnoremap('<C-h>', '<C-w><C-h>')
nnoremap('<C-j>', '<C-w><C-j>')
nnoremap('<C-k>', '<C-w><C-k>')
nnoremap('<C-l>', '<C-w><C-l>')
--Maximize current split
nnoremap('<C-m>', '<C-w>_<C-w><Bar>')

--Buffer navigation
nnoremap('<leader>b',     ':BufferLinePick<CR>',      SILENT)
nnoremap('<leader>x',     ':BufferLinePickClose<CR>', SILENT)
nnoremap('<leader>q',     functions.close,            SILENT)
nnoremap('<leader><Tab>', ':FzfLua buffers<CR>',      SILENT)
nnoremap('[b',            ':bprevious<CR>')
nnoremap(']b',            ':bnext<CR>')
nnoremap('<leader>1',     ':bfirst<CR>')
nnoremap('<leader>2',     ':bfirst<CR>:bn<CR>')
nnoremap('<leader>3',     ':bfirst<CR>:2bn<CR>')
nnoremap('<leader>4',     ':bfirst<CR>:3bn<CR>')
nnoremap('<leader>5',     ':bfirst<CR>:4bn<CR>')
nnoremap('<leader>6',     ':bfirst<CR>:5bn<CR>')
nnoremap('<leader>7',     ':bfirst<CR>:6bn<CR>')
nnoremap('<leader>8',     ':bfirst<CR>:7bn<CR>')
nnoremap('<leader>9',     ':bfirst<CR>:8bn<CR>')

--Tabs
nnoremap('<leader>t', ':tabnew<CR>')

--Clear the highlighting of :set hlsearch and messages
nnoremap('<CR>', ':nohlsearch<CR>:echo<CR>')

--Search results in the middle of the screen
nnoremap('n', 'nzz')
nnoremap('N', 'Nzz')

--Make <C-o> and <C-i> work with line movement
-- nnoremap <expr> j (v:count > 4 ? "m'--. v:count : "") . 'j'
-- nnoremap <expr> k (v:count > 4 ? "m'--. v:count : "") . 'k'

--Correct the last spelling mistake
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
nnoremap('cn', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>')
--Search and replace visual selection
vnoremap('cn', 'y:%s/<C-r>0//g<Left><Left>')

--execute current line as shell command in terminal buffer
-- nnoremap('<leader>e', ':execute \'term \' .. getline(\'.\')<CR>')
--execute visual selection in shell
-- vnoremap('<leader>e', ':w !"$SHELL"<CR>')

-- Command mode navigation
cnoremap('<C-h>', '<left>')
cnoremap('<C-j>', '<down>')
cnoremap('<C-k>', '<up>')
cnoremap('<C-l>', '<right>')
cnoremap('<C-a>', '<home>')
cnoremap('<C-e>', '<end>')
cnoremap('<C-w>', '<s-right>')
cnoremap('<C-b>', '<s-left>')

-- Leave terminal mode
tnoremap('<esc><esc>', '<C-\\><C-n>')

------Exchange
nmap('xl',  'cxx')
nmap('xw',  'cxiw')
nmap('xa',  'cxia')
nmap('x(',  'cxi(')
nmap('x)',  'cxi)')
nmap('x{',  'cxi{')
nmap('x}',  'cxi}')
nmap('x[',  'cxi[')
nmap('x]',  'cxi]')
nmap('x<',  'cxi<')
nmap('x>',  'cxi>')
nmap('x"',  'cxi"')
nmap('x\'', 'cxi\'')
nmap('xc',  'cxc')

-- Toggle Undotree
nnoremap('<Leader>u', ':UndotreeToggle<CR>', SILENT)

-- Toggle NvimTree
nnoremap("<leader>lf", ":NvimTreeFindFileToggle<CR>", SILENT)

-- Interactive EasyAlign
xmap('ga', '<Plug>(EasyAlign)')
vmap('ga', '<Plug>(EasyAlign)')

-- Toggle DBUI
nnoremap("<A-0>", ":DBUIToggle<CR>", SILENT)

function M.lsp(bufnr)
  local code_action_menu = require("code_action_menu")
  local opts = {buffer = bufnr, silent = true}
  local refactor_only = {context = {only = {"refactor"}}}

  nnoremap("<leader>r",  function() vim.lsp.buf.code_action(refactor_only) end,                opts)
  vnoremap("<leader>r",  function() vim.lsp.buf.range_code_action(refactor_only) end,          opts)
  nnoremap('<leader>fc', function() vim.lsp.buf.format({async = true}) end,                    opts)
  vnoremap('<leader>fc', vim.lsp.buf.format,                                                   opts)
  nnoremap('<A-CR>',     code_action_menu.open_code_action_menu,                               opts)
  vnoremap('<A-CR>',     code_action_menu.open_code_action_menu,                               opts)
  nnoremap('cn',         vim.lsp.buf.rename,                                                   opts)
  nnoremap('gd',         vim.lsp.buf.definition,                                               opts)
  nnoremap('gs',         vim.lsp.buf.document_symbol,                                          opts)
  nnoremap('gi',         vim.lsp.buf.implementation,                                           opts)
  nnoremap('gt',         vim.lsp.buf.type_definition,                                          opts)
  nnoremap('gr',         vim.lsp.buf.references,                                               opts)
  nnoremap('gS',         vim.lsp.buf.workspace_symbol,                                         opts)
  nnoremap('gc',         vim.lsp.buf.incoming_calls,                                           opts)
  nnoremap('gC',         vim.lsp.buf.outgoing_calls,                                           opts)
  nnoremap('K',          vim.lsp.buf.hover,                                                    opts)
  nnoremap('<leader>d',  vim.diagnostic.open_float,                                            opts)
  nnoremap(']w',         function() vim.diagnostic.goto_next({severity = {max = "warn"}}) end, opts)
  nnoremap('[w',         function() vim.diagnostic.goto_prev({severity = {max = "warn"}}) end, opts)
  nnoremap(']e',         function() vim.diagnostic.goto_next({severity = "error"}) end,        opts)
  nnoremap('[e',         function() vim.diagnostic.goto_prev({severity = "error"}) end,        opts)
  inoremap('<C-p>',      vim.lsp.buf.signature_help,                                           opts)
  nnoremap('<leader>cr', vim.lsp.codelens.refresh,                                             opts)
  nnoremap('<leader>z',  vim.lsp.codelens.run,                                                 opts)
end

function M.jdtls(bufnr)
  local jdtls = require("jdtls")
  local opts = {buffer = bufnr}

  nnoremap('<A-i>', jdtls.organize_imports, opts)
  nnoremap('em',    jdtls.extract_method,   opts)
  vnoremap('em',    jdtls.extract_method,   opts)
  nnoremap('ev',    jdtls.extract_variable, opts)
  vnoremap('ev',    jdtls.extract_variable, opts)
  nnoremap('ec',    jdtls.extract_constant, opts)
  vnoremap('ec',    jdtls.extract_constant, opts)
  nnoremap("<leader>ra", "<Cmd>lua require('my.private').run()<CR>")
end

function M.debug()
  local dap = require("dap")
  local dapui = require("dapui")
  local persistent_breakpoints = require("persistent-breakpoints.api")

  nnoremap('<A-;>',      dap.continue)
  nnoremap('<A-j>',      dap.step_over)
  nnoremap('<A-l>',      dap.step_into)
  nnoremap('<A-h>',      dap.step_out)
  nnoremap('<leader>du', dapui.toggle)
  nnoremap('<leader>de', dapui.eval)
  vnoremap('<leader>de', dapui.eval)
  nnoremap('<leader>df', function() dapui.float_element("scopes") end)
  nnoremap('<leader>dp', persistent_breakpoints.toggle_breakpoint)
  nnoremap('<leader>dc', persistent_breakpoints.set_conditional_breakpoint)
  nnoremap('<leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
  nnoremap('<leader>dh', function() dap.set_breakpoint(nil, vim.fn.input("Hit condition: "), nil) end)
  nnoremap('<leader>dd', persistent_breakpoints.clear_all_breakpoints)

  -- nnoremap('<leader>dr', '<Cmd>lua require("dap").repl.open()<CR>')
  -- nnoremap('<leader>dl', '<Cmd>lua require("dap").run_last()<CR>')
  -- nnoremap('<leader>dl', '<Cmd>lua require("dap").set_exception_breakpoints({"raised", "uncaught"})<CR>')

  -- nnoremap("<leader>df", "<Cmd>lua require('my.dap'); require'jdtls'.test_class()<CR>", opts, bufnr)
  -- nnoremap("<leader>dn", "<Cmd>lua require('my.dap'); require'jdtls'.test_nearest_method()<CR>", opts, bufnr)
end

function M.dapui()
  return {
    mappings = {
      -- Use a table to apply multiple mappings
      expand = "o",
      open = "o",
      remove = "dd",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    -- Use this to override mappings for specific elements
    element_mappings = {
      scopes = {
        expand = "o",
      },
      stacks = {
        open = "<CR>",
        expand = "o",
      }
    },
    floating = {
      close = {"q", "<Esc>"}
    },
  }
end

function M.venn()
  local opts = {buffer = true}

  -- draw lines
  nnoremap("H", "<C-v>h:VBox<CR>", opts)
  nnoremap("J", "<C-v>j:VBox<CR>", opts)
  nnoremap("K", "<C-v>k:VBox<CR>", opts)
  nnoremap("L", "<C-v>l:VBox<CR>", opts)

  -- draw box
  vnoremap("<CR>", ":VBox<CR>", opts)
end

function M.undotree()
  local opts = {buffer = true}
  -- open state
  nmap("o", "<CR>", opts)
end

function M.cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  return cmp.mapping.preset.insert {
    ["<CR>"]      = cmp.mapping.confirm {select = true},
    ["<C-c>"]     = cmp.mapping.close(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
    ["<C-j>"]     = cmp.mapping.select_next_item {behavior = cmp.SelectBehavior.Insert},
    ["<C-k>"]     = cmp.mapping.select_prev_item {behavior = cmp.SelectBehavior.Insert},

    ["<C-l>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-h>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }
end

function M.nvim_tree()
  return {
    {key = "O",           action = "edit"},
    {key = {"<CR>", "o"}, action = "edit_no_picker"},
    {key = "<C-v>",       action = "vsplit"},
    {key = "<C-s>",       action = "split"},
    {key = "<C-t>",       action = "tabnew"},
    {key = "cd",          action = "cd"},
    {key = "<BS>",        action = "dir_up"},
    {key = "P",           action = "parent_node"},
    {key = "a",           action = "create"},
    {key = "dd",          action = "cut"},
    {key = "D",           action = "remove"},
    {key = "yy",          action = "copy"},
    {key = "yiw",         action = "copy_name"},
    {key = "Y",           action = "copy_absolute_path"},
    {key = "p",           action = "paste"},
    {key = "r",           action = "refresh"},
    {key = "cn",          action = "rename"},
    {key = "<C-r>",       action = "full_rename"},
    {key = "so",          action = "system_open"},
    {key = "C",           action = "collapse_all"},
    {key = "E",           action = "expand_all"},
    {key = "f",           action = "live_filter"},
    {key = "F",           action = "clear_live_filter"},
    {key = "K",           action = "toggle_file_info"},
    {key = "H",           action = "toggle_dotfiles"},
    {key = "U",           action = "toggle_custom"},
    {key = "I",           action = "toggle_git_ignored"},
    {key = "[c",          action = "prev_git_item"},
    {key = "]c",          action = "next_git_item"},
    {key = "[e",          action = "prev_diag_item"},
    {key = "]e",          action = "next_diag_item"},
    {key = ".",           action = "run_file_command"},
    {key = "q",           action = "close"},
  }
end

function M.gitsigns(bufnr)
  local gitsigns = require("gitsigns")
  local opts = {buffer = bufnr}

  nnoremap("<leader>hr", gitsigns.reset_hunk,          opts)
  vnoremap("<leader>hr", gitsigns.reset_hunk,          opts)
  nnoremap("<leader>hR", gitsigns.reset_buffer,        opts)
  nnoremap("<leader>hp", gitsigns.preview_hunk,        opts)
  nnoremap("<leader>hi", gitsigns.preview_hunk_inline, opts)
  nnoremap("<leader>hb", gitsigns.blame_line,          opts)
  nnoremap("<leader>hh", gitsigns.show,                opts)
  nnoremap("<leader>hd", gitsigns.diffthis,            opts)

  opts.expr = true

  nnoremap("[c", function()
    if vim.wo.diff then return "[c" end
    vim.schedule(function() gitsigns.prev_hunk({preview = true}) end)
    return "doesn't matter"
  end, opts)

  nnoremap("]c", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gitsigns.next_hunk({preview = true}) end)
    return "doesn't matter"
  end, opts)
end

function M.nvim_code_action_menu()
  local opts = {buffer = true}
  nnoremap("<C-j>", "j", opts)
  nnoremap("<C-k>", "k", opts)
end

function M.sql()
  local opts = {buffer = true}
  nnoremap("<C-CR>",    functions.execute_query,           opts)
  vnoremap("<C-CR>",    "<Plug>(DBUI_ExecuteQuery)",       opts)
  nnoremap("s",         "<Plug>(DBUI_SaveQuery)",          opts)
  nnoremap("<leader>e", "<Plug>(DBUI_EditBindParameters)", opts)
end

function M.dbui()
  local opts = {buffer = true}
  nnoremap("<CR>",      "<Plug>(DBUI_SelectLine)",         opts)
  nnoremap("o",         "<Plug>(DBUI_SelectLine)",         opts)
  nnoremap("<C-v>",      "<Plug>(DBUI_SelectLineVsplit)",  opts)
  nnoremap("dd",        "<Plug>(DBUI_DeleteLine)",         opts)
  nnoremap("cn",        "<Plug>(DBUI_RenameLine)",         opts)
  nnoremap("r",         "<Plug>(DBUI_Redraw)",             opts)
  nnoremap("q",         "<Plug>(DBUI_Quit)",               opts)
end

function M.dbout()
  local opts = {buffer = true}
  nnoremap("gf",        "<Plug>(DBUI_JumpToForeignKey)",   opts)
  nnoremap("t",         "<Plug>(DBUI_ToggleResultLayout)", opts)
end

function M.treesitter()
  return {
    playground = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
    incremental_selection = {
      -- set to `false` to disable one of the mappings
      init_selection = "<leader>v",
      node_incremental = "]",
      scope_incremental = "gns",
      node_decremental = "[",
    },
  }
end

function M.fzf()
  local actions = require("fzf-lua.actions")
  return {
    builtin = {
      ["<C-f>"] = "toggle-fullscreen",
      ["<C-p>"] = "toggle-preview",
      ["<C-r>"] = "toggle-preview-ccw", -- Rotate preview counter-clockwise
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
      ["<C-h>"] = "preview-page-reset",
    },

    -- These override the default tables completely
    -- no need to set to `false` to disable an action
    -- delete or modify is sufficient
    actions = {
      -- providers that inherit these actions:
      --   files, git_files, git_status, grep, lsp
      --   oldfiles, quickfix, loclist, tags, btags
      --   args
      files = {
        ["default"] = actions.file_edit_or_qf, -- opens a single selection or sends multiple to quickfix
        ["<C-s>"]   = actions.file_split,
        ["<C-v>"]   = actions.file_vsplit,
        ["<M-q>"]   = actions.file_sel_to_qf,
        ["<M-l>"]   = actions.file_sel_to_ll,
      },
      -- providers that inherit these actions:
      --   buffers, tabs, lines, blines
      buffers       = {
        ["default"] = actions.buf_edit,
        ["<C-s>"]   = actions.buf_split,
        ["<C-v>"]   = actions.buf_vsplit,
      }
    },
  }
end

return M
