local g = vim.g
local lualine = require('lualine')
local bufferline = require('bufferline')
local devicons = require('nvim-web-devicons')
local dapui = require('dapui')
local treesitter_configs = require('nvim-treesitter.configs')

----------------------------------------------------------------------------------------------------
--                                           QuickScope
----------------------------------------------------------------------------------------------------
g['qs_highlight_on_keys'] = {'f', 'F', 't', 'T'}
g['qs_max_chars'] = 250
g['qs_buftype_blacklist'] = {'terminal', 'nofile', 'xml'}
g['qs_lazy_highlight'] = 1

----------------------------------------------------------------------------------------------------
--                                           UndoTree
----------------------------------------------------------------------------------------------------
g['undotree_HelpLine'] = 1
g['undotree_WindowLayout'] = 2
g['undotree_ShortIndicators'] = 1
g['undotree_SetFocusWhenToggle'] = 1

----------------------------------------------------------------------------------------------------
--                                           COQ
----------------------------------------------------------------------------------------------------
g['coq_settings'] = {
  auto_start = 'shut-up',
  xdg = true,
  keymap = {
    recommended = false,
    pre_select = false,
    bigger_preview = '<Nop>',
    jump_to_mark = '<Nop>'
  },
  display = {
    ghost_text = {enabled = false},
    preview = {positions = {east = 1, south = 2, north = 3, west = 4}},
    icons = {mode = 'long'}
  },
  clients = {
    tmux = {
      enabled = false
    },
    buffers = {
      same_filetype = true
    }
  }
}

----------------------------------------------------------------------------------------------------
--                                           LUALINE
----------------------------------------------------------------------------------------------------
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', {'diagnostics', sources={'nvim_diagnostic'}}},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

----------------------------------------------------------------------------------------------------
--                                           BUFFERLINE
----------------------------------------------------------------------------------------------------
bufferline.setup{
  options = {
    max_name_length = 25
  },
  show_buffer_icons = true,

  -- TODO: not working as expected
  name_formatter = function(buf)
    -- buf contains a "name", "path" and "bufnr"
    -- remove file extensions
      return vim.fn.fnamemodify(buf.name, ':t:r')
  end
}

----------------------------------------------------------------------------------------------------
--                                           DEVICONS
----------------------------------------------------------------------------------------------------
devicons.setup {
  override = {
    java = {
      icon = "",
      color = "#b8bb26",
      name = "java"
    }
  };
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
}

----------------------------------------------------------------------------------------------------
--                                           DAPUI
----------------------------------------------------------------------------------------------------
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = {"l", "<CR>", "<2-LeftMouse>"},
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    elements = {
      {id = "repl", size = 0.1},
      {id = "stacks", size = 0.3},
      {id = "scopes", size = 0.3},
      {id = "breakpoints", size = 0.3},
      -- {id = "watches", size = 0.1},
    },
    size = 40,
    position = "right",
  },
  tray = {
    elements = {
    },
    size = 10,
    position = "bottom",
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

----------------------------------------------------------------------------------------------------
--                                           TREESITTER
----------------------------------------------------------------------------------------------------
treesitter_configs.setup {
  highlight = {enable = true},
  playground = {
    enable = true,
    -- additional_vim_regex_highlighting = true,
    -- disable = {},
    -- updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    -- persist_queries = false, -- Whether the query persists across vim sessions
    -- keybindings = {
    --   toggle_query_editor = 'o',
    --   toggle_hl_groups = 'i',
    --   toggle_injected_languages = 't',
    --   toggle_anonymous_nodes = 'a',
    --   toggle_language_display = 'I',
    --   focus_language = 'f',
    --   unfocus_language = 'F',
    --   update = 'R',
    --   goto_node = '<cr>',
    --   show_help = '?',
    -- },
  }
}

-- "---------------------------------------------------------------------------------------------------
-- "                                           NERDTree
-- "---------------------------------------------------------------------------------------------------
-- let g:WebDevIconsUnicodeGlyphDoubleWidth = 0
-- let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
-- let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
-- let g:NERDTreeDirArrowExpandable = "\u00a0"
-- let g:NERDTreeDirArrowCollapsible = "\u00a0"
-- let g:NERDTreeWinSize=50
-- let g:NERDTreeQuitOnOpen=1
-- let g:NERDTreeMinimalUI = 1
-- " let g:NERDTreeDirArrows = 1
-- " let g:NERDTreeFileExtensionHighlightFullName = 1
-- " let g:NERDTreeExactMatchHighlightFullName = 1
-- " let g:NERDTreePatternMatchHighlightFullName = 1

-- "---------------------------------------------------------------------------------------------------
-- "                                           IndentLine
-- "---------------------------------------------------------------------------------------------------
-- let g:indentLine_enabled=0
-- let g:indentLine_leadingSpaceEnabled=1
-- let g:indentLine_leadingSpaceChar = '·'
-- let g:indentLine_fileTypeExclude = ["nerdtree"]

-- "---------------------------------------------------------------------------------------------------
-- "                                           VimBeGood
-- "---------------------------------------------------------------------------------------------------
-- let g:vim_be_good_floating = 0

-- "---------------------------------------------------------------------------------------------------
-- "                                           Signify
-- "---------------------------------------------------------------------------------------------------
-- let g:signify_sign_add               = '+'
-- let g:signify_sign_delete            = '–'
-- let g:signify_sign_delete_first_line = '_'
-- let g:signify_sign_change            = '~'

-- "---------------------------------------------------------------------------------------------------
-- "                                           HighlightedYank
-- "---------------------------------------------------------------------------------------------------
-- let g:highlightedyank_highlight_duration = 300

-- "---------------------------------------------------------------------------------------------------
-- "                                           VimDadbodUI
-- "---------------------------------------------------------------------------------------------------
-- let g:db_ui_use_nerd_fonts = 1

-- "---------------------------------------------------------------------------------------------------
-- "                                           VimVista
-- "---------------------------------------------------------------------------------------------------
-- let g:vista_default_executive = 'coc'
-- let g:vista_sidebar_position = 'vertical topleft'
-- let g:vista_sidebar_width = 40
-- let g:vista_close_on_jump = 1
-- let g:vista_blink = [1, 500]
-- let g:vista_fzf_preview = ['right:70%']
-- let g:vista_ignore_kinds = ['Package']
-- let g:vista_no_mappings = 1
-- let g:vista#renderer#icons = {
--       \   "class": "",
--       \   "field": "",
--       \   "constant": "",
--       \   "enum": "",
--       \   "enumerator": "",
--       \   "interface": "",
--       \   "method": "",
--       \  }

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
-- "                                           FZF
-- "---------------------------------------------------------------------------------------------------
-- " Opening up results in splits
-- let g:fzf_action = {
--       \ 'ctrl-s': 'split',
--       \ 'ctrl-v': 'vsplit' }

-- "---------------------------------------------------------------------------------------------------
-- "                                           VimHardTime
-- "---------------------------------------------------------------------------------------------------
-- let g:hardtime_default_on = 0
-- let g:hardtime_allow_different_key = 1
-- let g:hardtime_maxcount = 2
-- let g:hardtime_timeout = 2000
-- let g:list_of_disabled_keys = ["j", "k", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
-- let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "vista.*", "undotree.*"]

-- "---------------------------------------------------------------------------------------------------
-- "                                           VimCppModern
-- "---------------------------------------------------------------------------------------------------
-- " Put all standard C and C++ keywords under Vim's highlight group 'Statement'
-- " (affects both C and C++ files)
-- let g:cpp_simple_highlight = 1

-- " Enable highlighting of named requirements (C++20 library concepts)
-- let g:cpp_named_requirements_highlight = 1
