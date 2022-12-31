local M = {}

M.black      = '#282828'
M.black1     = "#3c3836"
M.white      = '#d4be98'
M.red        = '#ea6962'
M.green      = '#b8bb26'
M.blue       = '#7daea3'
M.yellow     = '#fabd2f'
M.orange     = '#de7424'
M.purple     = "#d3869b"
M.aqua       = "#8ec07c"
M.lightgray  = '#a89984'
M.gray       = '#928374'
M.darkgray   = '#7c6f64'
M.diff_green = '#2f591d'
M.diff_red   = '#910404'

local g = vim.g

g['gruvbox_material_background'] = 'medium'
g['gruvbox_material_foreground'] = 'material'
g['gruvbox_material_visual'] = 'green background'
g['gruvbox_material_menu_selection_background'] = 'green'
g['gruvbox_material_ui_contrast'] = 'high'
g['gruvbox_material_enable_bold'] = 0
g['gruvbox_material_diagnostic_text_highlight'] = 0
g['gruvbox_material_better_performance'] = 1
g['gruvbox_material_dim_inactive_windows'] = 1
g['gruvbox_material_show_eob'] = 0

g['gruvbox_material_colors_override'] = {
   ['bg0']              = {M.black,     '234'},
   ['bg1']              = {'#32302f',   '235'},
   ['bg2']              = {'#32302f',   '235'},
   ['bg3']              = {'#45403d',   '237'},
   ['bg4']              = {'#45403d',   '237'},
   ['bg5']              = {'#5a524c',   '239'},
   ['bg_dim']           = {'#212121',   '239'},
   ['bg_statusline1']   = {'#32302f',   '235'},
   ['bg_statusline2']   = {'#3a3735',   '235'},
   ['bg_statusline3']   = {'#504945',   '239'},
   ['bg_diff_green']    = {M.diff_green,'22'},
   ['bg_visual_green']  = {M.diff_green,'22'},
   ['bg_diff_red']      = {M.diff_red,  '52'},
   ['bg_visual_red']    = {M.diff_red,  '52'},
   ['bg_diff_blue']     = {M.diff_green,'17'},
   ['bg_visual_blue']   = {'#295575',   '17'},
   ['bg_visual_yellow'] = {'#4f422e',   '94'},
   ['bg_current_word']  = {'#3c3836',   '236'},
   ['fg0']              = {M.white,     '223'},
   ['fg1']              = {M.white,     '223'},
   ['red']              = {M.red,       '167'},
   ['orange']           = {M.orange,    '208'},
   ['yellow']           = {M.yellow,    '214'},
   ['green']            = {M.green,     '142'},
   ['aqua']             = {M.aqua,      '108'},
   ['blue']             = {M.blue,      '109'},
   ['purple']           = {M.purple,    '175'},
   ['bg_red']           = {M.red,       '167'},
   ['bg_green']         = {M.green,     '142'},
   ['bg_yellow']        = {M.yellow,    '214'},
   ['grey0']            = {M.darkgray,  '243'},
   ['grey1']            = {M.gray,      '245'},
   ['grey2']            = {M.lightgray, '246'},
   ['none']             = {'NONE',      'NONE'}
}

vim.cmd('colorscheme gruvbox-material')
vim.cmd('syntax on')


local GLOBAL_NAMESPACE = 0

local function highlight(group_name, definition)
  vim.api.nvim_set_hl(GLOBAL_NAMESPACE, group_name, definition)
end

local function link(group_name, to_group_name)
  vim.api.nvim_set_hl(GLOBAL_NAMESPACE, group_name, {link = to_group_name})
end

local function sign_define(sign_definition)
  vim.cmd("sign define "..sign_definition)
end


----------------------------------------------------------------------------------------------------
--                                         DEFINITIONS
----------------------------------------------------------------------------------------------------
highlight("MyFgBold",            {fg = M.white,  bold = true})
highlight("MyRedBold",           {fg = M.red,    bold = true})
highlight("MyGreenBold",         {fg = M.green,  bold = true})
highlight("MyBlueBold",          {fg = M.blue,   bold = true})
highlight("MyPurpleBold",        {fg = M.purple, bold = true})
highlight("MyYellowBold",        {fg = M.yellow, bold = true})
highlight("MyOrangeBold",        {fg = M.orange, bold = true})
highlight("MyAquaBold",          {fg = M.aqua,   bold = true})
highlight("MySearch",            {fg = M.black,  bold = true, bg = M.yellow})
highlight("MySearchCurrent",     {fg = M.black,  bold = true, bg = M.orange})
highlight("MySelection",         {fg = M.yellow, bold = true, bg = "#3a3735"})
highlight("MyFgAndBg",           {fg = M.white,  bg = M.black})
highlight("MyInvisible",         {fg = M.black,  bg = M.black})
highlight("MyRedSignLineHl",     {bg = "#402120"})
highlight("QuickScopePrimary",   {fg = M.yellow, bold = true, underline = true, italic = true})
highlight("QuickScopeSecondary", {fg = M.orange, bold = true, underline = true, italic = true})
----------------------------------------------------------------------------------------------------
--                                          LSP
----------------------------------------------------------------------------------------------------
sign_define("DiagnosticSignError text= texthl= linehl=MyRedSignLineHl numhl=MyRedBold")
sign_define("DiagnosticSignWarn  text= texthl= linehl= numhl=YellowSign")
sign_define("DiagnosticSignInfo  text= texthl= linehl= numhl=BlueSign")
sign_define("DiagnosticSignHint  text= texthl= linehl= numhl=GreenSign")
link("LspInlayHint", "VirtualTextHint")
----------------------------------------------------------------------------------------------------
--                                         GENERAL
----------------------------------------------------------------------------------------------------
link("IncSearch",    "MySearch")
link("Search",       "MySearch")
link("MatchParen",   "MySearch")
link("Searchlight",  "MySearchCurrent")
link("CursorLineNr", "MySelection")
link("CurrentWord",  "MySelection")
link("Visual",       "MySelection")
link("EndOfBuffer",  "MyInvisible")
link("QuickFixLine", "MySelection")
link("NormalFloat",  "MyFgAndBg")
link("FloatBorder",  "MyFgAndBg")

link("Keyword",      "Orange")
link("Structure",    "Yellow")
link("Macro",        "Green")
link("Delimiter",    "MyFgBold")
link("Constant",     "MyBlueBold")
link("String",       "Purple")
----------------------------------------------------------------------------------------------------
--                                         TREESITTER
----------------------------------------------------------------------------------------------------
link("@keyword",               "Keyword")
link("@keyword.function",      "Keyword")
link("@keyword.return",        "Keyword")
link("@conditional",           "Keyword")
link("@repeat",                "Keyword")
link("@type.builtin",          "Keyword")
link("@variable.builtin",      "Keyword")
link("@constant.builtin",      "Keyword")
link("@include",               "Keyword")
link("@exception",             "Keyword")
link("@modifier",              "Keyword")
link("@parameter",             "Identifier")
link("@parameter.reference",   "Identifier")
link("@property",              "Identifier")
link("@variable",              "Identifier")
link("@field",                 "Identifier")
link("@namespace",             "Identifier")
link("@constant",              "Constant")
link("@string",                "String")
link("@character",             "String")
link("@interface",             "String")
link("@punctuation.bracket",   "Delimiter")
link("@punctuation.delimiter", "Delimiter")
link("@punctuation.special",   "Delimiter")
link("@operator",              "Delimiter")
link("@constructor",           "Structure")
link("@constructor.lua",       "Delimiter")
link("@symbol",                "Delimiter")
link("@attribute",             "Aqua")
link("@annotation",            "Aqua")
----------------------------------------------------------------------------------------------------
--                                          CMP
----------------------------------------------------------------------------------------------------
link("CmpItemAbbrMatch",         "MySelection")
link("CmpItemAbbrMatchFuzzy",    "MySelection")
link("CmpItemAbbr",              "Fg")
link("CmpItemMenu",              "Fg")
link("CmpItemKindText",          "MyFgBold")
link("CmpItemKindMethod",        "MyGreenBold")
link("CmpItemKindFunction",      "MyGreenBold")
link("CmpItemKindVariable",      "MyBlueBold")
link("CmpItemKindInterface",     "MyPurpleBold")
link("CmpItemKindClass",         "MyYellowBold")
link("CmpItemKindStruct",        "MyYellowBold")
link("CmpItemKindKeyword",       "MyOrangeBold")
link("CmpItemKindEnum",          "MyAquaBold")
link("CmpItemKindEnumMember",    "MyAquaBold")
link("CmpItemKindProperty",      "MyBlueBold")
link("CmpItemKindField",         "MyBlueBold")
link("CmpItemKindModule",        "MyYellowBold")
link("CmpItemKindSnippet",       "MyAquaBold")
link("CmpItemKindTypeParameter", "MyPurpleBold")
link("CmpItemKindOperator",      "MyOrangeBold")
link("CmpItemKindEvent",         "MyYellowBold")
link("CmpItemKindConstructor",   "MyGreenBold")
link("CmpItemKindConstant",      "MyBlueBold")
link("CmpItemKindColor",         "MyAquaBold")
link("CmpItemKindFile",          "MyFgBold")
link("CmpItemKindFolder",        "MyBlueBold")
link("CmpItemKindReference",     "MyAquaBold")
link("CmpItemKindValue",         "MyPurpleBold")
link("CmpItemKind",              "MyYellowBold")
link("CmpItemKindUnit",          "MyYellowBold")
----------------------------------------------------------------------------------------------------
--                                          NVIM-TREE
----------------------------------------------------------------------------------------------------
function M.nvim_tree()
  link("NvimTreeNormal",                    "MyFgAndBg")
  link("NvimTreeEndOfBuffer",               "MyInvisible")
  link("NvimTreeCursorLine",                "CursorLine")

  link("NvimTreeFolderIcon",                "Orange")
  link("NvimTreeFolderName",                "Yellow")
  link("NvimTreeOpenedFolderName",          "Yellow")
  link("NvimTreeEmptyFolderName",           "Yellow")
  link("NvimTreeRootFolder",                "Grey")

  link("NvimTreeSymlink",                   "Aqua")
  link("NvimTreeExecFile",                  "MyGreenBold")
  link("NvimTreeOpenedFile",                "MyFgBold")
  link("NvimTreeSpecialFile",               "Aqua")
  link("NvimTreeImageFile",                 "Fg")

  link("NvimTreeIndentMarker",              "Grey")

  link("NvimTreeGitDirty",                  "Green")
  link("NvimTreeGitStaged",                 "Green")
  link("NvimTreeGitMerge",                  "Green")
  link("NvimTreeGitRenamed",                "Green")
  link("NvimTreeGitNew",                    "Green")
  link("NvimTreeGitDeleted",                "Green")

  link("NvimTreeLspDiagnosticsError",       "RedSign")
  link("NvimTreeLspDiagnosticsWarning",     "NONE")
  link("NvimTreeLspDiagnosticsInformation", "NONE")
  link("NvimTreeLspDiagnosticsHint",        "NONE")
end
----------------------------------------------------------------------------------------------------
--                                          LUALINE
----------------------------------------------------------------------------------------------------
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
function M.lualine()
  local gray_black1   = {fg = M.gray,   gui = "bold", bg = M.black1}
  local black_gray    = {fg = M.black,  gui = "bold", bg = M.gray}
  local black_green   = {fg = M.black,  gui = "bold", bg = M.green}
  local green_black1  = {fg = M.green,  gui = "bold", bg = M.black1}
  local black_yellow  = {fg = M.black,  gui = "bold", bg = M.yellow}
  local yellow_black1 = {fg = M.yellow, gui = "bold", bg = M.black1}
  local black_red     = {fg = M.black,  gui = "bold", bg = M.red}
  local red_black1    = {fg = M.red,    gui = "bold", bg = M.black1}
  local black_orange  = {fg = M.black,  gui = "bold", bg = M.orange}
  local orange_black1 = {fg = M.orange, gui = "bold", bg = M.black1}
  local blue_black1   = {fg = M.blue,   gui = "bold", bg = M.black1}

  return {
    theme = {
      normal = {
        a = black_gray,   b = gray_black1,   c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = black_gray,
      },

      insert = {
        a = black_green,  b = green_black1,  c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = black_green,
      },

      visual = {
        a = black_yellow, b = yellow_black1, c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = black_yellow,
      },

      replace = {
        a = black_red,    b = red_black1,    c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = black_red,
      },

      command = {
        a = black_orange, b = orange_black1, c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = black_orange,
      },

      inactive = {
        a = gray_black1,  b = gray_black1,   c = gray_black1,
        x = gray_black1,  y = gray_black1,   z = gray_black1,
      }
    },

    diagnostics_color = {
      error = red_black1,
      warn  = yellow_black1,
      info  = blue_black1,
      hint  = green_black1,
    },

    diff_color = {
      added    = green_black1,
      modified = blue_black1,
      removed  = red_black1,
    },
  }
end
----------------------------------------------------------------------------------------------------
--                                          NVIM-CODE-ACTION-MENU
----------------------------------------------------------------------------------------------------
link("CodeActionMenuMenuKind",              "Normal")
link("CodeActionMenuDetailsCreatedFile",    "Normal")
link("CodeActionMenuDetailsChangedFile",    "Normal")
link("CodeActionMenuDetailsRenamedFile",    "Normal")
link("CodeActionMenuDetailsDeletedFile",    "Normal")
link("CodeActionMenuDetailsNeutralSquares", "Normal")
link("CodeActionMenuDetailsAddedSquares",   "Green")
link("CodeActionMenuDetailsDeletedSquares", "Red")


return M
