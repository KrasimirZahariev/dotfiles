local M = {}

-- No upvalues here !

----------------------------------------------------------------------------------------------------
--                                           MATCHIT
----------------------------------------------------------------------------------------------------
vim.g.loaded_matchit = 0
----------------------------------------------------------------------------------------------------
--                                           QUICKSCOPE
----------------------------------------------------------------------------------------------------
function M.quick_scope()
  vim.g['qs_highlight_on_keys'] = {'f', 'F', 't', 'T'}
  vim.g['qs_max_chars'] = 250
  vim.g['qs_buftype_blacklist'] = {'terminal', 'nofile', 'xml'}
  vim.g['qs_lazy_highlight'] = 1
end
----------------------------------------------------------------------------------------------------
--                                           UNDOTREE
----------------------------------------------------------------------------------------------------
function M.undotree()
  vim.g['undotree_HelpLine'] = 1
  vim.g['undotree_WindowLayout'] = 2
  vim.g['undotree_ShortIndicators'] = 1
  vim.g['undotree_SetFocusWhenToggle'] = 1
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-CMP
----------------------------------------------------------------------------------------------------
function M.cmp()
  local symbols = {
    String        = '',
    Text          = '',
    Method        = 'M',
    Function      = 'F',
    Constructor   = '',
    Variable      = 'V',
    Class         = 'C',
    Struct        = 'S',
    Interface     = 'I',
    Property      = 'P',
    Field         = 'P',
    Reference     = '&',
    Unit          = '',
    Number        = '',
    Value         = '',
    Keyword       = '',
    Snippet       = '',
    Color         = '',
    File          = '',
    Folder        = '',
    Enum          = 'E',
    EnumMember    = 'E',
    Constant      = '',
    Event         = '',
    Operator      = '',
    TypeParameter = '',
    Namespace     = '',
    Package       = '',
    Module        = '',
    Boolean       = '',
    Array         = '',
    Object        = 'O',
    Key           = '',
    Null          = 'ﳠ',
  }

  local cmp = require("cmp")
  cmp.setup({
    sources = cmp.config.sources({
      {name = "nvim_lsp"},
      {name = "nvim_lsp_signature_help"},
      {name = "nvim_lua"},
      {name = "luasnip"},
      {name = "path"},
      {name = "buffer", keyword_length = 3},
      {name = "vim-dadbod-completion"},
    }),

    mapping = require("my.mappings").cmp(),

    sorting = {
      comparators = {
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.score,
        cmp.config.compare.offset,
        -- cmp.config.compare.kind,
        -- cmp.config.compare.sort_text,
        -- cmp.config.compare.length,
        -- cmp.config.compare.order,
      },
    },

    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },

    formatting = {
      fields = {'kind', 'abbr', 'menu'},
      format = function(entry, vim_item)
        vim_item.kind = symbols[vim_item.kind].." "
        -- Source
        vim_item.menu = ({
          nvim_lsp                  = "[LSP]",
          luasnip                   = "[SNIP]",
          nvim_lua                  = "[API]",
          buffer                    = "[BUF]",
          ["vim-dadbod-completion"] = "[DB]",
        })[entry.source.name]

        local maxwidth = 50
        if #vim_item.abbr > maxwidth then
          vim_item.abbr = vim_item.abbr:sub(1, maxwidth)..'...'
        end
        return vim_item
      end
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    }
  })

  for _, cmd in ipairs({":", "/", "?", "@"}) do
    local sources = {{name = "cmdline_history"}}

    if cmd == ":" then
      table.insert(sources, {name = "cmdline"})
      table.insert(sources, {name = "path"})
    end

    cmp.setup.cmdline(cmd, {
      sources = sources,
      mapping = cmp.mapping.preset.cmdline(),

      formatting = {
        fields = {'kind', 'abbr', 'menu'},
        format = function(entry, vim_item)
          vim_item.kind = symbols[vim_item.kind].." "
          -- Source
          vim_item.menu = ({
            cmdline         = "CMD",
            cmdline_history = "  ",
          })[entry.source.name]

          local maxwidth = 50
          if #vim_item.abbr > maxwidth then
            vim_item.abbr = vim_item.abbr:sub(1, maxwidth)..'...'
          end
          return vim_item
        end
      },
      })
  end
end
----------------------------------------------------------------------------------------------------
--                                           LUALINE
----------------------------------------------------------------------------------------------------
function M.lualine()
  local lualine_theme = require("my.colors").lualine()
  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = lualine_theme.theme,
      component_separators = {left = '', right = '|'},
      section_separators   = {left = '', right = '|'},
      disabled_filetypes   = {},
      always_divide_middle = true,
    },

    --+-------------------------------------------------+
    --| A | B | C                             X | Y | Z |
    --+-------------------------------------------------+
    sections = {
      lualine_a = {'mode'},
      lualine_b = {{'filename', path = 3}, "location"},
      lualine_c = {},

      lualine_x = {{'diagnostics',
        sources = {'nvim_diagnostic'},
        diagnostics_color = lualine_theme.diagnostics_color,
      }},
      lualine_y = {'branch', {"diff", diff_color = lualine_theme.diff_color}},
      lualine_z = {}
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {'filename'},
      lualine_c = {},

      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },

    tabline = {},
    extensions = {}
  }
end
----------------------------------------------------------------------------------------------------
--                                           BUFFERLINE
----------------------------------------------------------------------------------------------------
function M.bufferline()
  require('bufferline').setup {
    options = {
      max_name_length = 25,
      show_buffer_icons = true,
      show_close_icon = false,
      name_formatter = function(buf)
        -- buf contains a "name", "path" and "bufnr"
        -- remove file extensions
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end,
      diagnostics = "nvim_lsp",
      ---@diagnostic disable-next-line: unused-local
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        if not context.buffer:current() and level:match("error") then
          return " "
        end
        return ""
      end,
      offsets = {{filetype = "NvimTree", text = "NVIM TREE"}},
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                           DEVICONS
----------------------------------------------------------------------------------------------------
function M.devicons()
  require('nvim-web-devicons').setup {
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
  }
end
----------------------------------------------------------------------------------------------------
--                                           DAPUI
----------------------------------------------------------------------------------------------------
function M.dapui()
  local dapui = require("dapui")
  dapui.setup({
    icons = {
      expanded = "",
      collapsed = "",
      current_frame = ""
    },
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
    expand_lines = true,
    layouts = {
      {
        elements = {
          {id = "scopes",      size = 0.4},
          {id = "stacks",      size = 0.2},
          {id = "breakpoints", size = 0.2},
          -- {id = "repl",        size = 0.2},
          -- {id = "watches", size = 0.1},
        },
        size = 50,
        position = "left",
      },
      {
        elements = {"console"},
        size = 17,
        position = "bottom",
      }
    },
    controls = {
      -- Requires Neovim nightly (or 0.8 when released)
      enabled = false,
      -- Display controls in this element
      element = "console",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "",
        terminate = "",
      },
    },
    floating = {
      max_height = 0.3,
      max_width = 0.23,
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
  })

  require("my.mappings").debug()

  local dap = require("dap")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({layout = 1})
    vim.cmd("silent DapVirtualTextForceRefresh")
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({layout = 1})
    vim.cmd("silent DapVirtualTextForceRefresh")
  end
end

----------------------------------------------------------------------------------------------------
--                                           NVIM-DAP-VIRTUAL-TEXT
----------------------------------------------------------------------------------------------------
require("nvim-dap-virtual-text").setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = '',

  -- experimental features:
  virt_text_pos = 'eol',
  all_frames = true,
  virt_lines = false,
  virt_text_win_col = nil
}
----------------------------------------------------------------------------------------------------
--                                           TREESITTER
----------------------------------------------------------------------------------------------------
function M.treesitter()
  local mappings = require("my.mappings").treesitter()
  require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    ensure_installed = "all",
    ignore_install = { "comment" },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = mappings.playground,
    },
    incremental_selection = {
      enable = true,
      keymaps = mappings.incremental_selection,
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                          FIXCURSORHOLD
----------------------------------------------------------------------------------------------------
function M.fix_cursor_hold()
  -- in millisecond, used for both CursorHold and CursorHoldI, use updatetime instead if not defined
  vim.g['cursorhold_updatetime'] = 100
end
----------------------------------------------------------------------------------------------------
--                                          SATELLITE
----------------------------------------------------------------------------------------------------
function M.satellite()
  require("satellite").setup()
end
----------------------------------------------------------------------------------------------------
--                                          GITSIGNS
----------------------------------------------------------------------------------------------------
function M.gitsigns()
  require("gitsigns").setup {
    signs = {
      add          = {hl = "GitSignsAdd"   , text = "+", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn"},
      change       = {hl = "GitSignsChange", text = "~", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn"},
      delete       = {hl = "GitSignsDelete", text = "-", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn"},
      topdelete    = {hl = "GitSignsDelete", text = "-", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn"},
      changedelete = {hl = "GitSignsChange", text = "-", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn"},
    },

    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },

    on_attach = require("my.mappings").gitsigns
  }
end
----------------------------------------------------------------------------------------------------
--                                          FIDGET
----------------------------------------------------------------------------------------------------
function M.fidget()
  require("fidget").setup {
    text = {spinner = "meter"}
  }
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-TREE
----------------------------------------------------------------------------------------------------
function M.nvim_tree()
  require("nvim-tree").setup {
    view = {
      centralize_selection = true,
      signcolumn = "yes",
      mappings = {
        custom_only = true,
        list = require("my.mappings").nvim_tree(),
      },
    },

    renderer = {
      highlight_git = true,
      highlight_opened_files = "name",
      group_empty = true,
      icons = {
        show = {
          git = false,
        },
      },
      indent_markers = {
        enable = true,
      },
      special_files = {"Cargo.toml", "Makefile", "build.gradle", "pom.xml"},
    },

    diagnostics = {
      enable = true,
      show_on_dirs = true,
      severity = {
        min = vim.diagnostic.severity.ERROR,
        max = vim.diagnostic.severity.ERROR,
      },
    },

    actions = {
      open_file = {
        quit_on_open = true,
      },
      expand_all = {
        exclude = {".git", "bin", "build", "gradle", "out", "generated"},
      },
    },

    filters = {
      dotfiles = false,
    },
  }

  local api = require("nvim-tree.api")
  local Event = api.events.Event

  api.events.subscribe(Event.TreeOpen, function()
    require("my.colors").nvim_tree()
    require("my.settings").nvim_tree()
  end)

end
----------------------------------------------------------------------------------------------------
--                                          INDENT-BLANKLINE
----------------------------------------------------------------------------------------------------
function M.indent_blakline()
  require("indent_blankline").setup {
    char = "│",
    char_list = {"│", "", "", "", "", "", "", "", "", ""},
    disable_with_nolist = true,
    show_current_context = true,
    context_highlight_list = {"Orange"},
    use_treesitter_scope = true,
    viewport_buffer = 100,
  }
end
----------------------------------------------------------------------------------------------------
--                                          LEAP
----------------------------------------------------------------------------------------------------
function M.leap()
  require("leap").set_default_keymaps()
end
----------------------------------------------------------------------------------------------------
--                                          LIVE-COMMANDS
----------------------------------------------------------------------------------------------------
function M.live_command()
  require("live-command").setup {
    commands = {
    Norm = {cmd = "norm"},
    G = {cmd = "g"},
    D = {cmd = "d"},
    Reg = {
      cmd = "norm",
      args = function(opts)
        return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
      end,
      range = "",
    },
    }
  }
end
----------------------------------------------------------------------------------------------------
--                                          NEODIM
----------------------------------------------------------------------------------------------------
function M.neodim()
  require("neodim").setup({
    alpha = 0.1,
    blend_color = require("my.colors").gray,
    update_in_insert = {enable = false},
    hide = {signs = false}
  })
end
----------------------------------------------------------------------------------------------------
--                                         LSP-INLAYHINTS
----------------------------------------------------------------------------------------------------
function M.lsp_inlayhints()
  require("lsp-inlayhints").setup({
    inlay_hints = {
      parameter_hints = {
        show = true,
        prefix = "<- ",
        separator = ", ",
        remove_colon_start = false,
        remove_colon_end = true,
      },
      type_hints = {
        -- type and other hints
        show = true,
        prefix = "",
        separator = ", ",
        remove_colon_start = false,
        remove_colon_end = false,
      },
      only_current_line = false,
      -- separator between types and parameter hints. Note that type hints are
      -- shown before parameter
      labels_separator = "  ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- highlight group
      highlight = "LspInlayHint",
      -- virt_text priority
      priority = 0,
    },
    enabled_at_startup = true,
    debug_mode = false,
  })
end
----------------------------------------------------------------------------------------------------
--                                         NVIM-SURROUND
----------------------------------------------------------------------------------------------------
function M.nvim_surround()
  require("nvim-surround").setup({
    move_cursor = false,
    indent_lines = false,
    highlight = {
      duration = 1000,
    },
    keymaps = {
      insert = false,
      insert_line = false,
    }
  })
end
----------------------------------------------------------------------------------------------------
--                                         NVIM-CODE-ACTION-MENU
----------------------------------------------------------------------------------------------------
function M.nvim_code_action_menu()
  vim.g.code_action_menu_window_border = "rounded"
  vim.g.code_action_menu_show_details = false
  vim.g.code_action_menu_show_action_kind = false
end
----------------------------------------------------------------------------------------------------
--                                         VIM-DADBOD-UI
----------------------------------------------------------------------------------------------------
function M.dadbod_ui()
  vim.g.db_ui_save_location = NVIM_DATA_HOME.."/db_ui"
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_execute_on_save = 0
  vim.g.db_ui_disable_mappings = 1
  vim.g.db_ui_show_help = 0
  vim.g.db_ui_hide_schemas = {"information_schema", "pg_catalog", "pg_toast.*"}
  vim.g.db_ui_auto_execute_table_helpers = 1
end
----------------------------------------------------------------------------------------------------
--                                         FZF
----------------------------------------------------------------------------------------------------
function M.fzf()
  require("fzf-lua").setup({
    winopts = {
      height = 0.30,
      width  = 0.30,
      row    = 0.35, -- vertical   position (0=top, 1=bottom)
      col    = 0.50, -- horizontal position (0=left, 1=right)
      preview = {
        -- hidden = "hidden",
        vertical   = 'down:85%',  -- up|down:size
        horizontal = 'right:60%', -- right|left:size
        layout     = 'vertical',  -- horizontal|vertical|flex
      },
    },

    files = {
      rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!*.jar'",
      winopts = {
        height = 0.50,
        width  = 0.50,
        preview = {
          hidden = "hidden",
        },
      },
    },

    buffers = {
      winopts = {
        preview = {
          hidden = "hidden",
        },
      },
    },

    lsp = {
      jump_to_single_result = true,
    },

    keymap = require("my.mappings").fzf(),
    file_icon_colors = require("my.colors").fzf_file_icons(),
    file_icon_padding = ' ',
  })

  vim.cmd("silent FzfLua register_ui_select")
end
----------------------------------------------------------------------------------------------------
--                                         PERSISTENT-BREAKPOINTS
----------------------------------------------------------------------------------------------------
function M.persistent_breakpoints()
  require('persistent-breakpoints').setup{
    save_dir = NVIM_DATA_HOME.."/dap",
    -- when to load the breakpoints? "BufReadPost" is recommanded.
    load_breakpoints_event = { "BufReadPost" },
    -- record the performance of different function.
    -- run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
    perf_record = true,
  }
end





-- "---------------------------------------------------------------------------------------------------
-- "                                           VimBeGood
-- "---------------------------------------------------------------------------------------------------
-- let g:vim_be_good_floating = 0



-- "---------------------------------------------------------------------------------------------------
-- "                                           VimTest
-- "---------------------------------------------------------------------------------------------------
-- let test#strategy = "neovim"
-- " let test#neovim#term_position = "vert botright 30"
-- "---------------------------------------------------------------------------------------------------
-- "                                           CtrlSF
-- "---------------------------------------------------------------------------------------------------
-- let g:ctrlsf_auto_focus = {"at": "start"}
-- let g:ctrlsf_default_view_mode = 'compact'
-- let g:ctrlsf_mapping = {
--       \ "next": "n",
--       \ "prev": "N"
--       \ }
-- "---------------------------------------------------------------------------------------------------
-- "                                           VimHardTime
-- "---------------------------------------------------------------------------------------------------
-- let g:hardtime_default_on = 0
-- let g:hardtime_allow_different_key = 1
-- let g:hardtime_maxcount = 2
-- let g:hardtime_timeout = 2000
-- let g:list_of_disabled_keys = ["j", "k", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
-- let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "vista.*", "undotree.*"]

return M
