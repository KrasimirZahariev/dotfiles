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
    String        = '󰉿',
    Text          = '󰉿',
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
    Number        = '󰎠',
    Value         = '󰎠',
    Keyword       = '󰌋',
    Snippet       = '',
    Color         = '󰏘',
    File          = '󰈙',
    Folder        = '󰉋',
    Enum          = 'E',
    EnumMember    = 'E',
    Constant      = '󰏿',
    Event         = '',
    Operator      = '󰆕',
    TypeParameter = '',
    Namespace     = '',
    Package       = '',
    Module        = '',
    Boolean       = '',
    Array         = '',
    Object        = 'O',
    Key           = '',
    Null          = '󰟢',
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
            cmdline         = "📟",
            cmdline_history = "🕒",
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
  local functions = require("my.functions")
  require("lualine").setup {
    sections = {},
    tabline = {},
    extensions = {},

    options = {
      icons_enabled = true,
      theme = lualine_theme.theme,
      component_separators = { left = '', right = '' },
      section_separators   = { left = '', right = '' },
      disabled_filetypes   = {"help", "man", "NvimTree"},
      always_divide_middle = true,
    },

    --+-------------------------------------------------+
    --| A | B | C                             X | Y | Z |
    --+-------------------------------------------------+
    winbar = {
      lualine_a = {
        {
          "filetype",
          colored = true,
          icon_only = true,
          icon = { align = "left" },
        },
        {
          "filename",
          -- 0: Only filename 1: Relative path 2: Absolute path 3: Absolute path, tilde as the home directory
          path = 0,
          shorting_target = 60,
          file_status = true,
          newfile_status = false,
          symbols = {
            modified ="✏️ ",
            readonly = "👁️",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_b = {
        {
          "diagnostics",
          sources = {"nvim_diagnostic"},
          diagnostics_color = lualine_theme.diagnostics_color,
          symbols = {error = "⛔", warn = "⚠️ ", info = "ℹ️ ", hint = "💡"},
        }
      },
      lualine_c = {},

      lualine_x = {{functions.lualine_macro_recording}},
      lualine_y = {
        {
          "diff",
          diff_color = lualine_theme.diff_color,
          source = functions.lualine_diff_source
        },
        {"b:gitsigns_head", icon = "🌾"},
      },
      lualine_z = {{functions.lualine_cursor_column}},
    },

    inactive_winbar = {
      lualine_a = {
        {
          "filetype",
          colored = true,
          icon_only = true,
          icon = { align = "left" },
        },
        {
          "filename",
          -- 0: Only filename 1: Relative path 2: Absolute path 3: Absolute path, tilde as the home directory
          path = 0,
          shorting_target = 60,
          file_status = true,
          newfile_status = false,
          symbols = {
            modified =" ",
            readonly = " ",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_b = {},
      lualine_c = {},

      lualine_x = {},
      lualine_y = {},
      lualine_z = {{"b:gitsigns_head", icon = "🌾"}},
    },

  }

  -- call it here to override lualine
  require("my.settings").lualine()
end
----------------------------------------------------------------------------------------------------
--                                           DEVICONS
----------------------------------------------------------------------------------------------------
function M.devicons()
  require('nvim-web-devicons').setup {
    override = {
      -- java   = {icon = "☕", name = "java"},
      -- sql    = {icon = "🛢️", name = "sql"},
      -- rs     = {icon = "🦀", name = "rs"},
      -- lock   = {icon = "🔒", name = "lock"},
      -- toml   = {icon = "⚙️ ", name = "toml"},
      -- yaml   = {icon = "⚙️ ", name = "yaml"},
      -- yml    = {icon = "⚙️ ", name = "yml"},
      -- gradle = {icon = "🐘", name = "gradle"},
      -- txt    = {icon = "📄", name = "txt"},
      -- bash   = {icon = "⚡", name = "bash"},
      -- sh     = {icon = "⚡", name = "sh"},
      -- lua    = {icon = "🌚", name = "lua"},
    }
  }
end
----------------------------------------------------------------------------------------------------
--                                           NEODEV
----------------------------------------------------------------------------------------------------
function M.neodev()
  require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
  })
end
----------------------------------------------------------------------------------------------------
--                                           DAPUI
----------------------------------------------------------------------------------------------------
function M.dapui()
  local mappings = require("my.mappings")

  local dapui = require("dapui")
  dapui.setup({
    icons = {
      expanded = "",
      collapsed = "",
      current_frame = ""
    },
    mappings = mappings.dapui().mappings,
    element_mappings = mappings.dapui().element_mappings,
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
      mappings = mappings.dapui().floating,
    },
    render = {
      indent = 1,
      max_value_lines = 100,
    },
  })

  mappings.debug()

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
function M.nvim_dap_virtual_text()
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
end
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
  vim.g.cursorhold_updatetime = 100
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
    on_attach = require("my.mappings").gitsigns,
    signcolumn = false,
    numhl      = true,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },
    worktrees = {
      {
        toplevel = HOME,
        gitdir = os.getenv("DOTFILES_DIR")
      }
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-TREE
----------------------------------------------------------------------------------------------------
function M.nvim_tree()
  require("nvim-tree").setup {
    on_attach = require("my.mappings").nvim_tree,

    view = {
      centralize_selection = true,
      signcolumn = "yes",
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
  require("ibl").setup({
    indent = {
      char = "▏",
      highlight = { "NonText" },
    },
    scope = {
      char = "▎",
      highlight = {"Keyword"},
      injected_languages = false,
      show_start = false,
      show_end = false,
      include = {
        node_type = {
          lua = {"return_statement", "table_constructor"}
        },
      },
    },
  })
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
      filename_only = true,
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
----------------------------------------------------------------------------------------------------
--                                         SESSIONS
----------------------------------------------------------------------------------------------------
function M.sessions()
  require("sessions").setup({
    events = { "VimLeavePre" },
    session_filepath = NVIM_DATA_HOME.."/sessions",
    -- treat the default session filepath as an absolute path
    -- if true, all session files will be stored in a single directory
    absolute = true,
  })
end
----------------------------------------------------------------------------------------------------
--                                         WORKSPACES
----------------------------------------------------------------------------------------------------
function M.workspaces()
  require("workspaces").setup({
    path = NVIM_DATA_HOME.."/workspaces",

    -- controls how the directory is changed. valid options are "global", "local", and "tab"
    --   "global" changes directory for the neovim process. same as the :cd command
    --   "local" changes directory for the current window. same as the :lcd command
    --   "tab" changes directory for the current tab. same as the :tcd command
    cd_type = "global",

    -- sort the list of workspaces by name after loading from the workspaces path.
    sort = true,

    -- sort by recent use rather than by name. requires sort to be true
    mru_sort = true,

    -- automatically activate workspace when opening neovim in a workspace directory
    auto_open = false,

    -- enable info-level notifications after adding or removing a workspace
    notify_info = true,

    -- lists of hooks to run after specific actions
    -- hooks can be a lua function or a vim command (string)
    -- lua hooks take a name, a path, and an optional state table
    -- if only one hook is needed, the list may be omitted
    hooks = {
      add = {},
      remove = {},
      rename = {},
      open_pre = {"silent %bd"},
      open = function()
        require("sessions").load(nil, { silent = true })
        -- require("my.settings").cmdheight_zero()
      end,
    },
  })
end
----------------------------------------------------------------------------------------------------
--                                         GIT-CONFLICT
----------------------------------------------------------------------------------------------------
function M.git_conflict()
  require("git-conflict").setup({
    default_mappings = true, -- disable buffer local mapping created by this plugin
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    highlights = { -- They must have background color, otherwise the default color will be used
      incoming = "DiffText",
      current = "DiffAdd",
    }
  })
end
----------------------------------------------------------------------------------------------------
--                                         NOICE
----------------------------------------------------------------------------------------------------
function M.noice()
  require("noice").setup({
    cmdline = {view = "cmdline"},
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      {
        view = "notify",
        filter = {
          event = "msg_showmode",
          find = "recording"
        },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },         -- add any options here
  })
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
