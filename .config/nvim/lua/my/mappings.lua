---@class my.mappings
local M = {}

local helpers   = require("my.helpers")
local functions = require("my.functions")

---@diagnostic disable-next-line: unused-local
local map       = helpers.map
local nmap      = helpers.nmap
local nnoremap  = helpers.nnoremap
---@diagnostic disable-next-line: unused-local
local imap      = helpers.imap
local inoremap  = helpers.inoremap
local vmap      = helpers.vmap
local vnoremap  = helpers.vnoremap
local xmap      = helpers.xmap
local xnoremap  = helpers.xnoremap
---@diagnostic disable-next-line: unused-local
local cmap      = helpers.cmap
local cnoremap  = helpers.cnoremap
---@diagnostic disable-next-line: unused-local
local tmap      = helpers.tmap
local tnoremap  = helpers.tnoremap

local SILENT = {silent = true}
local EXPR = {expr = true}
local BUFFER = {buffer = true}

vim.g.mapleader = ";"

-- Don't yank when editing
nnoremap('D', '"_D')
nnoremap('X', '"_X')
nnoremap('x', '"_x')
nnoremap('C', '"_C')
nnoremap('c', '"_c')

-- Yank and save cursor position (restored by autocmd)
nnoremap("y", function() vim.w.yank_cursor_pos = vim.fn.getpos("."); return "y" end, EXPR)
vnoremap("y", function() vim.w.yank_cursor_pos = vim.fn.getpos("."); return "y" end, EXPR)

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

-- Substitute
-- Inner object (e.g., 'piw', 'pi(', 'pi"')
nnoremap('pi', function()
  require('substitute').operator() -- trigger the operator
  vim.api.nvim_feedkeys("i", "m", false) -- feed 'i' back into nvim so we dont type it twice
end)
-- Line
nnoremap('pl', require('substitute').line)
-- to EOL
nnoremap("pe", require('substitute').eol)
-- In visual
vnoremap("p", require('substitute').visual)

-- Exchange
-- Inner object (e.g., 'xiw', 'xi(', 'xi"')
nnoremap('xi', function()
  require('substitute.exchange').operator() -- trigger the operator
  vim.api.nvim_feedkeys("i", "m", false) -- feed 'i' back into nvim so we dont type it twice
end)
-- Line
nnoremap('xl', require('substitute.exchange').line)
-- Cancel
nnoremap('xc', require('substitute.exchange').cancel)
-- In visual
vnoremap("x", require('substitute.exchange').visual)

-- Scroll 5 lines
nnoremap('<C-y>', '<C-y>5')
nnoremap('<C-e>', '<C-e>5')

-- Back and forth matching pairs
nnoremap('<Tab>', '%')
vnoremap('<Tab>', '%')
nnoremap('<C-i>', '<C-i>')

--Open file from path
nnoremap('<leader>o', 'gf', SILENT)

nnoremap("gf",         functions.files,          SILENT)
nnoremap("<leader>f", ":FzfLua live_grep<CR>",   SILENT)
vnoremap("<leader>f", ":FzfLua grep_visual<CR>", SILENT)

--Split navigation
nnoremap('<C-h>', '<C-w><C-h>')
nnoremap('<C-j>', '<C-w><C-j>')
nnoremap('<C-k>', '<C-w><C-k>')
nnoremap('<C-l>', '<C-w><C-l>')
--Maximize current split
nnoremap('<C-m>', '<C-w>_<C-w><Bar>')

--Buffer navigation
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
nnoremap('cn', [[:%s/\V<C-r>=escape(expand('<cword>'), '/\')<CR>//g<Left><Left>]])
vnoremap('cn', [[y:%s/\V<C-r>=escape(@", '/\')<CR>//g<Left><Left>]])

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
  local severity = vim.diagnostic.severity
  local opts = {buffer = bufnr, silent = true}
  local refactor_only = {context = {only = {"refactor"}}}

  nnoremap("<leader>r",  function() vim.lsp.buf.code_action(refactor_only) end,               opts)
  vnoremap("<leader>r",  function() vim.lsp.buf.range_code_action(refactor_only) end,         opts)
  nnoremap("<leader>fc", function() vim.lsp.buf.format({async = true}) end,                   opts)
  vnoremap("<leader>fc", vim.lsp.buf.format,                                                  opts)
  nnoremap("<A-CR>",     vim.lsp.buf.code_action,                                             opts)
  vnoremap("<A-CR>",     vim.lsp.buf.code_action,                                             opts)
  nnoremap("cn",         vim.lsp.buf.rename,                                                  opts)
  nnoremap("gd",         vim.lsp.buf.definition,                                              opts)
  nnoremap("gs",         vim.lsp.buf.document_symbol,                                         opts)
  nnoremap("gi",         vim.lsp.buf.implementation,                                          opts)
  nnoremap("gt",         vim.lsp.buf.type_definition,                                         opts)
  nnoremap("gr",         vim.lsp.buf.references,                                              opts)
  nnoremap("gS",         vim.lsp.buf.workspace_symbol,                                        opts)
  nnoremap("gc",         vim.lsp.buf.incoming_calls,                                          opts)
  nnoremap("gC",         vim.lsp.buf.outgoing_calls,                                          opts)
  nnoremap("K",          vim.lsp.buf.hover,                                                   opts)
  nnoremap("<leader>d",  vim.diagnostic.open_float,                                           opts)
  nnoremap("]w", function() vim.diagnostic.jump({count = 1, severity = severity.WARN}) end,   opts)
  nnoremap("[w", function() vim.diagnostic.jump({count = -1, severity = severity.WARN}) end,  opts)
  nnoremap("]e", function() vim.diagnostic.jump({count = 1, severity = severity.ERROR}) end,  opts)
  nnoremap("[e", function() vim.diagnostic.jump({count = -1, severity = severity.ERROR}) end, opts)
  inoremap("<C-p>",      vim.lsp.buf.signature_help,                                          opts)
  nnoremap("<leader>f",  functions.strings,                                                   opts)
  vnoremap("<leader>f",  functions.strings_visual,                                            opts)
  nnoremap("<leader>d", function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local current_line_diagnostics = vim.diagnostic.get(0, { lnum = current_line })

    if #current_line_diagnostics > 0 then
      vim.diagnostic.open_float()
    else
      vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
    end
  end, opts)
end

function M.jdtls(bufnr)
  local jdtls = require("jdtls")
  local opts = {buffer = bufnr}

  nnoremap("<A-i>", jdtls.organize_imports, opts)
  nnoremap("em",    jdtls.extract_method,   opts)
  vnoremap("em",    jdtls.extract_method,   opts)
  nnoremap("ev",    jdtls.extract_variable, opts)
  vnoremap("ev",    jdtls.extract_variable, opts)
  nnoremap("ec",    jdtls.extract_constant, opts)
  vnoremap("ec",    jdtls.extract_constant, opts)
  nnoremap("el", function()
    vim.lsp.buf.code_action({
      context = {only = {"refactor"}},
      filter = function(action) return action.kind == "refactor.inline" end,
      apply = true,
    })
    end,
  opts)

  nnoremap("<leader>ra", "<Cmd>lua require('my.private').run()<CR>")
end

function M.debug()
  local dap = require("dap")
  local dapui = require("dapui")
  local persistent_breakpoints = require("persistent-breakpoints.api")

  nnoremap("<A-;>",      dap.continue)
  nnoremap("<A-j>",      dap.step_over)
  nnoremap("<A-l>",      dap.step_into)
  nnoremap("<A-h>",      dap.step_out)
  nnoremap("<leader>du", dapui.toggle)
  nnoremap("<leader>de", dapui.eval)
  vnoremap("<leader>de", dapui.eval)
  nnoremap("<leader>df", function() dapui.float_element("scopes") end)
  nnoremap("<leader>dp", persistent_breakpoints.toggle_breakpoint)
  nnoremap("<leader>dc", persistent_breakpoints.set_conditional_breakpoint)
  nnoremap("<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
  nnoremap("<leader>dh", function() dap.set_breakpoint(nil, vim.fn.input("Hit condition: "), nil) end)
  nnoremap("<leader>dd", persistent_breakpoints.clear_all_breakpoints)

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

  -- until implemented https://github.com/hrsh7th/nvim-cmp/issues/1716
  local confirm = function(entry)
    local behavior = cmp.ConfirmBehavior.Replace
    if entry then
      local completion_item = entry.completion_item
      local newText = ''
      if completion_item.textEdit then
        newText = completion_item.textEdit.newText
      elseif type(completion_item.insertText) == 'string' and completion_item.insertText ~= '' then
        newText = completion_item.insertText
      else
        newText = completion_item.word or completion_item.label or ''
      end

      local diff_after = math.max(0, entry.replace_range['end'].character + 1) - entry.context.cursor.col

      if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
        behavior = cmp.ConfirmBehavior.Insert
      end
    end

    cmp.confirm({ select = true, behavior = behavior })
  end

  return cmp.mapping.preset.insert {
    -- ["<CR>"]      = cmp.mapping.confirm {select = true},
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        confirm(cmp.get_selected_entry())
      else
        fallback()
      end
    end, { 'i', 's' }),
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

function M.nvim_tree(bufnr)
  local api = require('nvim-tree.api')
  local opts = {buffer = bufnr, silent = true, nowait = true}

  nnoremap('O',     api.node.open.edit,                 opts)
  nnoremap('<CR>',  api.node.open.no_window_picker,     opts)
  nnoremap('o',     api.node.open.no_window_picker,     opts)
  nnoremap('<C-v>', api.node.open.vertical,             opts)
  nnoremap('<C-s>', api.node.open.horizontal,           opts)
  nnoremap('<C-t>', api.node.open.tab,                  opts)
  nnoremap('cd',    api.tree.change_root_to_node,       opts)
  nnoremap('<BS>',  api.tree.change_root_to_parent,     opts)
  nnoremap('P',     api.node.navigate.parent,           opts)
  nnoremap('a',     api.fs.create,                      opts)
  nnoremap('dd',    api.fs.cut,                         opts)
  nnoremap('D',     api.fs.remove,                      opts)
  nnoremap('yy',    api.fs.copy.node,                   opts)
  nnoremap('yiw',   api.fs.copy.filename,               opts)
  nnoremap('Y',     api.fs.copy.absolute_path,          opts)
  nnoremap('p',     api.fs.paste,                       opts)
  nnoremap('r',     api.tree.reload,                    opts)
  nnoremap('cn',    api.fs.rename,                      opts)
  nnoremap('<C-r>', api.fs.rename_sub,                  opts)
  nnoremap('so',    api.node.run.system,                opts)
  nnoremap('C',     api.tree.collapse_all,              opts)
  nnoremap('E',     api.tree.expand_all,                opts)
  nnoremap('f',     api.live_filter.start,              opts)
  nnoremap('F',     api.live_filter.clear,              opts)
  nnoremap('K',     api.node.show_info_popup,           opts)
  nnoremap('H',     api.tree.toggle_hidden_filter,      opts)
  nnoremap('U',     api.tree.toggle_custom_filter,      opts)
  nnoremap('I',     api.tree.toggle_gitignore_filter,   opts)
  nnoremap('[c',    api.node.navigate.git.prev,         opts)
  nnoremap(']c',    api.node.navigate.git.next,         opts)
  nnoremap('[e',    api.node.navigate.diagnostics.prev, opts)
  nnoremap(']e',    api.node.navigate.diagnostics.next, opts)
  nnoremap('.',     api.node.run.cmd,                   opts)
  nnoremap('q',     api.tree.close,                     opts)
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
    vim.schedule(function() gitsigns.nav_hunk("prev", {preview = true}) end)
    return "doesn't matter"
  end, opts)

  nnoremap("]c", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gitsigns.nav_hunk("next", {preview = true}) end)
    return "doesn't matter"
  end, opts)
end

function M.sql()
  local opts = {buffer = true}
  nnoremap("<C-CR>",    functions.execute_query,           opts)
  vnoremap("<C-CR>",    functions.execute_query,           opts)
  nnoremap("<leader>e", "<Plug>(DBUI_EditBindParameters)", opts)
end

function M.dbui()
  local opts = {buffer = true}
  nnoremap("<CR>",      "<Plug>(DBUI_SelectLine)",         opts)
  nnoremap("o",         "<Plug>(DBUI_SelectLine)",         opts)
  nnoremap("<C-v>",     "<Plug>(DBUI_SelectLineVsplit)",   opts)
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
        ["<M-q>"]   = actions.file_sel_to_qf,
      }
    },
  }
end

function M.markdown()
  nnoremap("gd", "<cmd>Obsidian follow_link<cr>", BUFFER)
  nnoremap("<space>", "<cmd>Obsidian toggle_checkbox<cr>", BUFFER)
  -- Extract markdown link from the url under the cursor: [title](url)
  nnoremap("el", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local col = cursor[2]
    local line = vim.api.nvim_get_current_line()

    for url in line:gmatch("https?://[%w%.%-%_/%?%&%=%+#%%]+") do
      local start_pos = line:find(url, 1, true)
      local end_pos = start_pos + #url - 1

      -- Check if cursor is on or immediately next to the URL
      if col >= start_pos - 1 and col <= end_pos then
        -- Extract last path component as default title
        local title = url:match(".*/([^/]+)/?$") or url
        title = title:gsub("%.git$", "")

        local new_link = string.format("[%s](%s)", title, url)

        -- Reconstruct line: before_url .. new_link .. after_url
        local new_line = line:sub(1, start_pos - 1) .. new_link .. line:sub(end_pos + 1)
        vim.api.nvim_set_current_line(new_line)

        -- Place cursor on the title
        vim.api.nvim_win_set_cursor(0, { row, start_pos })
        return
      end
    end
  end, BUFFER)

end

return M
