-- No upvalues here !

local function configure(plugin_name, config)
  if not config then
    config = {}
  end

  return vim.tbl_extend("force", { plugin_name }, config)
end

local function lazy()
  return {
    lazy = true
  }
end

local function very_lazy()
  return {
    event = "VeryLazy"
  }
end
----------------------------------------------------------------------------------------------------
--                                           MATCHIT
----------------------------------------------------------------------------------------------------
vim.g.loaded_matchit = 0
----------------------------------------------------------------------------------------------------
--                                           QUICKSCOPE
----------------------------------------------------------------------------------------------------
local function quick_scope()
  return {
    init = function()
      vim.g['qs_highlight_on_keys'] = { 'f', 'F', 't', 'T' }
      vim.g['qs_max_chars'] = 250
      vim.g['qs_buftype_blacklist'] = { 'terminal', 'nofile', 'xml' }
      vim.g['qs_lazy_highlight'] = 1
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                           UNDOTREE
----------------------------------------------------------------------------------------------------
local function undotree()
  return {
    cmd = "UndotreeToggle",
    init = function()
      vim.g['undotree_HelpLine'] = 1
      vim.g['undotree_WindowLayout'] = 2
      vim.g['undotree_ShortIndicators'] = 1
      vim.g['undotree_SetFocusWhenToggle'] = 1
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-CMP
----------------------------------------------------------------------------------------------------
local function nvim_cmp()
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

  local function format_item(entry, vim_item)
    vim_item.kind = (symbols[vim_item.kind] or vim_item.kind or '') .. " "
    vim_item.menu = ({
      nvim_lsp                  = "[LSP]",
      luasnip                   = "[SNIP]",
      nvim_lua                  = "[API]",
      buffer                    = "[BUF]",
      ["vim-dadbod-completion"] = "[DB]",
      cmdline                   = "📟",
      cmdline_history           = "🕒",
    })[entry.source.name]
    local maxwidth = 50
    if #vim_item.abbr > maxwidth then
      vim_item.abbr = vim_item.abbr:sub(1, maxwidth) .. '...'
    end
    return vim_item
  end


  return {
    event = { "InsertEnter", "CmdlineEnter" },

    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
    },

    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer",                 keyword_length = 3 },
          { name = "vim-dadbod-completion" },
        }),

        mapping = require("my.mappings").cmp(),

        sorting = {
          priority_weight = 3,
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.locality,
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
          fields = { 'kind', 'abbr', 'menu' },
          format = format_item
        },
      })

      for _, cmd in ipairs({ ":", "/", "?", "@" }) do
        local sources = { { name = "cmdline_history" } }

        if cmd == ":" then
          table.insert(sources, { name = "cmdline" })
          table.insert(sources, { name = "path" })
        end

        cmp.setup.cmdline(cmd, {
          sources = sources,
          mapping = cmp.mapping.preset.cmdline(),

          formatting = {
            fields = { 'kind', 'abbr', 'menu' },
            format = format_item,
          },
        })
      end
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                           CMP_NVIM_LSP
----------------------------------------------------------------------------------------------------
local function cmp_nvim_lsp()
  return {
    lazy = true, -- required in my.lsp.base
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                           LUALINE
----------------------------------------------------------------------------------------------------
local function lualine()
  return {
    event = "VeryLazy",
    config = function()
      local lualine_theme = require("my.colors").lualine()
      local functions = require("my.functions")
      require("lualine").setup {
        sections = {},
        tabline = {},
        extensions = {},

        options = {
          icons_enabled        = true,
          theme                = lualine_theme.theme,
          component_separators = { left = '', right = '' },
          section_separators   = { left = '', right = '' },
          disabled_filetypes   = { "help", "man", "NvimTree" },
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
                modified = "✏️ ",
                readonly = "👁️",
                unnamed = "[No Name]",
              },
            },
          },
          lualine_b = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              diagnostics_color = lualine_theme.diagnostics_color,
              symbols = { error = "⛔", warn = "⚠️ ", info = "ℹ️ ", hint = "💡" },
            }
          },
          lualine_c = {},

          lualine_x = { { functions.lualine_macro_recording } },
          lualine_y = {
            {
              "diff",
              diff_color = lualine_theme.diff_color,
              source = functions.lualine_diff_source
            },
            { "b:gitsigns_head", icon = "🌾" },
          },
          lualine_z = { { functions.lualine_cursor_column } },
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
                modified = " ",
                readonly = " ",
                unnamed = "[No Name]",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},

          lualine_x = {},
          lualine_y = {},
          lualine_z = { { "b:gitsigns_head", icon = "🌾" } },
        },

      }

      -- call it here to override lualine
      require("my.settings").lualine()
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                           DEVICONS
----------------------------------------------------------------------------------------------------
local function devicons()
  return {
    lazy = true,
    config = function()
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
  }
end
----------------------------------------------------------------------------------------------------
--                                           DAPUI
----------------------------------------------------------------------------------------------------
local function nvim_dap_ui()
  return {
    lazy = true,

    dependencies = {
      "nvim-neotest/nvim-nio", -- install dependency
    },

    config = function()
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
              { id = "scopes",      size = 0.4 },
              { id = "stacks",      size = 0.2 },
              { id = "breakpoints", size = 0.2 },
              -- {id = "repl",        size = 0.2},
              -- {id = "watches", size = 0.1},
            },
            size = 50,
            position = "left",
          },
          {
            elements = { "console" },
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
        dapui.close({ layout = 1 })
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({ layout = 1 })
      end
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                           NVIM-DAP-VIRTUAL-TEXT
----------------------------------------------------------------------------------------------------
local function nvim_dap_virtual_text()
  return {
    lazy = true,

    config = function()
      require("nvim-dap-virtual-text").setup({
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
      })

      local dap = require("dap")

      dap.listeners.before.event_terminated["dapui_config"] = function()
        vim.cmd("silent DapVirtualTextForceRefresh")
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        vim.cmd("silent DapVirtualTextForceRefresh")
      end
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                           TREESITTER
----------------------------------------------------------------------------------------------------
local function treesitter()
  return {
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      local excluded = { "comment" }
      local to_install = vim.iter(ts.get_available())
        :filter(function(lang) return not vim.tbl_contains(excluded, lang) and not vim.tbl_contains(ts.get_installed(), lang) end)
        :totable()

      if #to_install > 0 then ts.install(to_install) end
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                          SATELLITE
----------------------------------------------------------------------------------------------------
local function satellite()
  return {
    event = "VeryLazy",
    config = true,
  }
end
----------------------------------------------------------------------------------------------------
--                                          GITSIGNS
----------------------------------------------------------------------------------------------------
local function gitsigns()
  return {
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup {
        on_attach      = require("my.mappings").gitsigns,
        signcolumn     = true,
        numhl          = false,
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '' },
          topdelete    = { text = '' },
          changedelete = { text = '≋' },
          untracked    = { text = '┆' },
        },
        signs_staged = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        preview_config = {
          border   = "rounded",
          style    = "minimal",
          relative = "cursor",
          row      = 0,
          col      = 1
        },
        worktrees = {
          {
            toplevel = HOME,
            gitdir = os.getenv("DOTFILES_DIR")
          }
        },
      }
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-TREE
----------------------------------------------------------------------------------------------------
local function nvim_tree()
  return {
    cmd = "NvimTreeFindFileToggle",
    config = function()
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
          special_files = { "Cargo.toml", "Makefile", "build.gradle", "pom.xml" },
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
            exclude = { ".git", "bin", "build", "gradle", "out", "generated" },
          },
        },

        filters = {
          dotfiles = false,
          git_ignored = false,
        },
      }

      local api = require("nvim-tree.api")
      local Event = api.events.Event

      api.events.subscribe(Event.TreeOpen, function()
        require("my.colors").nvim_tree()
        require("my.settings").nvim_tree()
      end)
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                          INDENT-BLANKLINE
----------------------------------------------------------------------------------------------------
local function indent_blakline()
  return {
    event = "VeryLazy",
    config = function()
      require("ibl").setup({
        indent = {
          char = "▏",
          highlight = { "NonText" },
        },
        scope = {
          char = "▎",
          highlight = { "Keyword" },
          injected_languages = false,
          show_start = false,
          show_end = false,
          include = {
            node_type = {
              lua = { "return_statement", "table_constructor" }
            },
          },
        },
      })
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                          LIVE-COMMAND
----------------------------------------------------------------------------------------------------
local function live_command()
  return {
    event = "CmdlineEnter",
    config = function()
      require("live-command").setup {
       commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                          NEODIM
----------------------------------------------------------------------------------------------------
local function neodim()
  require("neodim").setup({
    alpha = 0.1,
    blend_color = require("my.colors").gray,
    update_in_insert = { enable = false },
    hide = { signs = false }
  })
end
----------------------------------------------------------------------------------------------------
--                                         NVIM-SURROUND
----------------------------------------------------------------------------------------------------
local function nvim_surround()
  return {
    config = function()
      require("nvim-surround").setup({
        move_cursor = false,
        indent_lines = false,
        highlight = {
          duration = 1000,
        },
      })
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         VIM-DADBOD-UI
----------------------------------------------------------------------------------------------------
local function vim_dadbod_ui()
  return {
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion"
    },
    init = function()
      vim.g.db_ui_save_location = NVIM_DATA_HOME .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_disable_mappings = 1
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_hide_schemas = { "information_schema", "pg_catalog", "pg_toast.*" }
      vim.g.db_ui_auto_execute_table_helpers = 1
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                         FZF
----------------------------------------------------------------------------------------------------
local function fzf()
  -- no lazy loading so register_ui_select works
  return {
    config = function()
      require("fzf-lua").setup({
        winopts = {
          height  = 0.30,
          width   = 0.30,
          row     = 0.35, -- vertical   position (0=top, 1=bottom)
          col     = 0.50, -- horizontal position (0=left, 1=right)
          preview = {
            -- hidden = "hidden",
            vertical   = 'down:85%',  -- up|down:size
            horizontal = 'right:60%', -- right|left:size
            layout     = 'vertical',  -- horizontal|vertical|flex
          },
        },

        files = {
          -- rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!*.jar' -g '!*.class'",
          file_ignore_patterns = { "%.jar$", "%.class$", "%build/", "%.gradle/", "%gradle/" },
          toggle_ignore_flag = "--no-ignore-vcs",
          winopts = {
            height  = 0.50,
            width   = 0.50,
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

      require("fzf-lua").register_ui_select(function(fzf_opts, items)
        local frame_lines = 5 -- borders + prompt + input line + some adjustment
        if fzf_opts.kind == "codeaction" then
          local max_total = math.floor(vim.o.lines * 0.8)
          local preview_h = 15

          -- List gets: items + frame_lines, but cap it so total fits on screen
          local list_h = math.min(#items + frame_lines, max_total - preview_h)
          local total_h = list_h + preview_h

          return {
            winopts = {
              relative = "cursor",
              row = 1,
              col = 0,
              width = 0.6,
              height = total_h,
              preview = {
                layout = "vertical",
                vertical = "down:" .. preview_h .. ",border-top",
              },
            },
          }
        end

        -- fallback for other ui.select uses
        local h = math.min(#items + frame_lines, math.floor(vim.o.lines * 0.8))
        return {
          winopts = {
            relative = "cursor",
            row = 1,
            col = 0,
            width = 0.6,
            height = h,
          },
        }
      end)

    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         PERSISTENT-BREAKPOINTS
----------------------------------------------------------------------------------------------------
local function persistent_breakpoints()
  return {
    lazy = true,
    config = function()
      require('persistent-breakpoints').setup {
        save_dir = NVIM_DATA_HOME .. "/dap",
        -- when to load the breakpoints? "BufReadPost" is recommanded.
        load_breakpoints_event = { "BufReadPost" },
        -- record the performance of different function.
        -- run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
        perf_record = true,
      }
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         SESSIONS
----------------------------------------------------------------------------------------------------
local function sessions()
  return {
    cmd = {"SessionsSave", "SessionsLoad", "SessionsStop"},
    config = function()
      require("sessions").setup({
        events = { "VimLeavePre" },
        session_filepath = NVIM_DATA_HOME .. "/sessions",
        -- treat the default session filepath as an absolute path
        -- if true, all session files will be stored in a single directory
        absolute = true,
      })
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         WORKSPACES
----------------------------------------------------------------------------------------------------
local function workspaces()
  return {
    dependencies = { "natecraddock/sessions.nvim" },
    cmd = {
      "WorkspacesAdd", "WorkspacesAddDir", "WorkspacesList", "WorkspacesListDirs", "WorkspacesOpen",
      "WorkspacesRemove", "WorkspacesRemoveDir", "WorkspacesRename", "WorkspacesSyncDirs",
    },
    config = function()
      require("workspaces").setup({
        path = NVIM_DATA_HOME .. "/workspaces",

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
          open_pre = { "silent %bd" },
          open = function()
            require("sessions").load(nil, { silent = true })
            -- require("my.settings").cmdheight_zero()
          end,
        },
      })
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         GIT-CONFLICT
----------------------------------------------------------------------------------------------------
local function git_conflict()
  return {
    event = "VeryLazy",
    config = function ()
      require("git-conflict").setup({
        default_mappings = true,     -- disable buffer local mapping created by this plugin
        default_commands = true,     -- disable commands created by this plugin
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = 'copen',       -- command or function to open the conflicts list
        highlights = {               -- They must have background color, otherwise the default color will be used
          incoming = 'DiffAdd',
          current = 'DiffText',
        },
        debug = false,
      })
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                         NOICE
----------------------------------------------------------------------------------------------------
local function noice()
  return {
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },

    config = function()
      require("noice").setup({
        cmdline = { view = "cmdline" },
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
          {
            filter = {
               event = "lsp",
               kind = "progress",
               find = "python_ls",
            },
            opts = { skip = true },
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
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },                              -- add any options here
      })
    end
  }
end
----------------------------------------------------------------------------------------------------
--                                         FIRENVIM
----------------------------------------------------------------------------------------------------
local function firenvim()
  return {
    lazy = not vim.g.started_by_firenvim,  -- eager only when browser-launched
    build = ":call firenvim#install(0)",
  }
end
----------------------------------------------------------------------------------------------------
--                                         NVIM_COLORIZER
----------------------------------------------------------------------------------------------------
local function nvim_colorizer()
  return {
    cmd = "ColorizerToggle",
  }
end
----------------------------------------------------------------------------------------------------
--                                         LAZYDEV
----------------------------------------------------------------------------------------------------
local function lazydev()
  return {
    ft = "lua",
    cond = function()
      -- Only load for nvim config files
      local current_dir = vim.fn.expand('%:p:h')
      return current_dir:find(vim.fn.stdpath("config"), 1, true) ~= nil
    end,
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                         NVIM_DAP
----------------------------------------------------------------------------------------------------
local function nvim_dap()
  return {
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      'Weissle/persistent-breakpoints.nvim',
    }
  }
end
----------------------------------------------------------------------------------------------------
--                                         VENN
----------------------------------------------------------------------------------------------------
local function venn()
  return {
    cmd = "VBox",
  }
end
----------------------------------------------------------------------------------------------------
--                                         GRUVBOX_MATERIAL
----------------------------------------------------------------------------------------------------
local function gruvbox_material()
  return {
    priority = 1000,
  }
end
----------------------------------------------------------------------------------------------------
--                                         VIM_SEARCHLIGHT
----------------------------------------------------------------------------------------------------
local function vim_searchlight()
  return {
    event = "VeryLazy",
    priority = 999,
  }
end
----------------------------------------------------------------------------------------------------
--                                         LUASNIP
----------------------------------------------------------------------------------------------------
local function luasnip()
  return {
    lazy = true,
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load custom
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" }
      })
    end,
  }
end
----------------------------------------------------------------------------------------------------
--                                         NVIM_BQF
----------------------------------------------------------------------------------------------------
local function nvim_bqf()
  return {
    ft = "qf",
  }
end
----------------------------------------------------------------------------------------------------
--                                         VIM_FUGITIVE
----------------------------------------------------------------------------------------------------
local function vim_fugitive()
  return {
    cmd = "Git",
  }
end
----------------------------------------------------------------------------------------------------
--                                         VIM_RHUBARB
----------------------------------------------------------------------------------------------------
local function vim_rhubarb()
  return {
    cmd = "GBrowse",
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



  -------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------



return {
  configure("sainnhe/gruvbox-material",             gruvbox_material()),
  configure("PeterRincker/vim-searchlight",         vim_searchlight()),
  configure("L3MON4D3/LuaSnip",                     luasnip()),
  configure("hrsh7th/nvim-cmp",                     nvim_cmp()),
  configure("hrsh7th/cmp-nvim-lsp",                 cmp_nvim_lsp()),
  configure("tpope/vim-fugitive",                   vim_fugitive()),
  configure("tpope/vim-rhubarb",                    vim_rhubarb()),
  configure("lewis6991/gitsigns.nvim",              gitsigns()),
  configure("akinsho/git-conflict.nvim",            git_conflict()),
  configure("tpope/vim-repeat",                     very_lazy()),
  configure("tpope/vim-commentary",                 very_lazy()),
  configure("psliwka/vim-smoothie",                 very_lazy()),
  configure("tommcdo/vim-exchange",                 very_lazy()),
  configure("wellle/targets.vim",                   very_lazy()),
  configure("romainl/vim-cool",                     very_lazy()),
  configure("famiu/bufdelete.nvim",                 very_lazy()),
  configure("junegunn/vim-easy-align",              very_lazy()),
  configure("nvim-lua/plenary.nvim",                lazy()),
  configure("mfussenegger/nvim-jdtls",              lazy()),
  configure("mfussenegger/nvim-dap",                nvim_dap()),
  configure("rcarriga/nvim-dap-ui",                 nvim_dap_ui()),
  configure("theHamsta/nvim-dap-virtual-text",      nvim_dap_virtual_text()),
  configure('Weissle/persistent-breakpoints.nvim',  persistent_breakpoints()),
  configure("jbyuki/venn.nvim",                     venn()),
  configure("ibhagwan/fzf-lua",                     fzf()),
  configure("tpope/vim-dadbod",                     lazy()),
  configure("kristijanhusak/vim-dadbod-ui",         vim_dadbod_ui()),
  configure("kristijanhusak/vim-dadbod-completion", lazy()),
  configure("kyazdani42/nvim-web-devicons",         devicons()),
  configure("norcalli/nvim-colorizer.lua",          nvim_colorizer()),
  configure("mbbill/undotree",                      undotree()),
  configure("unblevable/quick-scope",               quick_scope()),
  configure("nvim-lualine/lualine.nvim",            lualine()),
  configure("kyazdani42/nvim-tree.lua",             nvim_tree()),
  configure("nvim-treesitter/nvim-treesitter",      treesitter()),
  configure("lukas-reineke/indent-blankline.nvim",  indent_blakline()),
  configure("folke/noice.nvim",                     noice()),
  configure("kylechui/nvim-surround",               nvim_surround()),
  configure("glacambre/firenvim",                   firenvim()),
  configure("lewis6991/satellite.nvim",             satellite()),
  configure("natecraddock/sessions.nvim",           sessions()),
  configure("natecraddock/workspaces.nvim",         workspaces()),
  configure("folke/lazydev.nvim",                   lazydev()),
  configure("kevinhwang91/nvim-bqf",                nvim_bqf()),
  configure("smjonas/live-command.nvim",            live_command()),

  --{"zbirenbaum/neodim",                   config = neodim},
}



    -- use "stevearc/dressing.nvim"
    -- use {"gbprod/substitute.nvim"}
    -- use {ja-ford/delaytrain.nvim"}
    -- use "anuvyklack/hydra.nvim"
    -- use "andymass/vim-matchup"
    -- use "nvim-treesitter/nvim-treesitter-textobjects"
    -- use "rmagatti/auto-session"
    -- use "ldelossa/litee.nvim"
    -- use "sindrets/diffview.nvim"
    -- use "ray-x/lsp_signature.nvim"
    -- use "jbyuki/one-small-step-for-vimkind"
    -- use "nanotee/luv-vimdocs"
    -- use "rcarriga/cmp-dap"
    -- use "vim-scripts/dbext.vim"
    -- use "smjonas/inc-rename.nvim"
    -- use "mhinz/vim-grepper
    -- use "ThePrimeagen/refactoring.nvim"

    -- use "dyng/ctrlsf.vim"
    -- use {"liuchengxu/vista.vim", {"for": ["java"]}}
    -- use "junegunn/gv.vim"
    -- use {"puremourning/vimspector", {"for": "java"}}
    -- use {"vim-test/vim-test", {"for": "java"}}
    -- use {"ThePrimeagen/vim-be-good", { "on": "VimBeGood" }
    -- use "takac/vim-hardtime"
    -- use "rstacruz/vim-closer"
    -- use "shumphrey/fugitive-gitlab.vim"
