local M = {}

local colors = {
  black        = '#282828',
  black1       = "#3c3836",
  white        = '#d4be98',
  red          = '#ea6962',
  green        = '#b8bb26',
  blue         = '#7daea3',
  yellow       = '#fabd2f',
  orange       = '#de7424',
  purple       = "#d3869b",
  aqua         = "#77bd6d",
  lightgray    = '#a89984',
  gray         = '#928374',
  darkgray     = '#7c6f64',
}

local g = vim.g

g['gruvbox_material_background'] = 'medium'
g['gruvbox_material_foreground'] = 'material'
g['gruvbox_material_visual'] = 'green background'
g['gruvbox_material_menu_selection_background'] = 'green'
g['gruvbox_material_ui_contrast'] = 'high'
g['gruvbox_material_enable_bold'] = 0
g['gruvbox_material_diagnostic_text_highlight'] = 0
g['gruvbox_material_better_performance'] = 1

g['gruvbox_material_colors_override'] = {
   ['bg0']              = {colors.black,     '234'},
   ['bg1']              = {'#32302f',        '235'},
   ['bg2']              = {'#32302f',        '235'},
   ['bg3']              = {'#45403d',        '237'},
   ['bg4']              = {'#45403d',        '237'},
   ['bg5']              = {'#5a524c',        '239'},
   ['bg_statusline1']   = {'#32302f',        '235'},
   ['bg_statusline2']   = {'#3a3735',        '235'},
   ['bg_statusline3']   = {'#504945',        '239'},
   ['bg_diff_green']    = {'#34381b',        '22'},
   ['bg_visual_green']  = {'#3b4439',        '22'},
   ['bg_diff_red']      = {'#402120',        '52'},
   ['bg_visual_red']    = {'#4c3432',        '52'},
   ['bg_diff_blue']     = {'#0e363e',        '17'},
   ['bg_visual_blue']   = {'#374141',        '17'},
   ['bg_visual_yellow'] = {'#4f422e',        '94'},
   ['bg_current_word']  = {'#3c3836',        '236'},
   ['fg0']              = {colors.white,     '223'},
   ['fg1']              = {colors.white,     '223'},
   ['red']              = {colors.red,       '167'},
   ['orange']           = {colors.orange,    '208'},
   ['yellow']           = {colors.yellow,    '214'},
   ['green']            = {colors.green,     '142'},
   ['aqua']             = {colors.aqua,      '108'},
   ['blue']             = {colors.blue,      '109'},
   ['purple']           = {colors.purple,    '175'},
   ['bg_red']           = {colors.red,       '167'},
   ['bg_green']         = {colors.green,     '142'},
   ['bg_yellow']        = {colors.yellow,    '214'},
   ['grey0']            = {colors.darkgray,  '243'},
   ['grey1']            = {colors.gray,      '245'},
   ['grey2']            = {colors.lightgray, '246'},
   ['none']             = {'NONE',           'NONE'}
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


----------------------------------------------------------------------------------------------------
--                                         DEFINITIONS
----------------------------------------------------------------------------------------------------
highlight("MyFgBold",            {fg = colors.white,  bold = true})
highlight("MyRedBold",           {fg = colors.red,    bold = true})
highlight("MyGreenBold",         {fg = colors.green,  bold = true})
highlight("MyBlueBold",          {fg = colors.blue,   bold = true})
highlight("MyPurpleBold",        {fg = colors.purple, bold = true})
highlight("MyYellowBold",        {fg = colors.yellow, bold = true})
highlight("MyOrangeBold",        {fg = colors.orange, bold = true})
highlight("MyAquaBold",          {fg = colors.aqua,   bold = true})
highlight("MySearch",            {fg = colors.black,  bold = true, bg = colors.yellow})
highlight("MySearchCurrent",     {fg = colors.black,  bold = true, bg = colors.orange})
highlight("MyLspReference",      {fg = colors.yellow, bold = true, bg = "#3a3735"})
highlight("MyRedSignLineHl",     {bg = "#402120"})
highlight("QuickScopePrimary",   {fg = colors.yellow, bold = true, underline = true, italic = true})
highlight("QuickScopeSecondary", {fg = colors.orange, bold = true, underline = true, italic = true})
----------------------------------------------------------------------------------------------------
--                                          LSP
----------------------------------------------------------------------------------------------------
vim.cmd('sign define DiagnosticSignError text= texthl= linehl=MyRedSignLineHl numhl=MyRedBold')
vim.cmd('sign define DiagnosticSignWarn  text= texthl= linehl= numhl=YellowSign')
vim.cmd('sign define DiagnosticSignInfo  text= texthl= linehl= numhl=BlueSign')
vim.cmd('sign define DiagnosticSignHint  text= texthl= linehl= numhl=GreenSign')
----------------------------------------------------------------------------------------------------
--                                         GENERAL
----------------------------------------------------------------------------------------------------
link("IncSearch",            "MySearch")
link("Search",               "MySearch")
link("Searchlight",          "MySearchCurrent")
link("CursorLineNr",         "MyLspReference")
link("CurrentWord",          "MyLspReference")
link("Visual",               "MyLspReference")
----------------------------------------------------------------------------------------------------
--                                         TREESITTER
----------------------------------------------------------------------------------------------------
link("TSKeyword",            "Orange")
link("TSKeywordFunction",    "Orange")
link("TSConditional",        "Orange")
link("TSRepeat",             "Orange")
link("TSTypeBuiltin",        "Orange")
link("TSVariableBuiltin",    "Orange")
link("TSInclude",            "Orange")
link("TSException",          "Orange")
link("TSParameter",          "Blue")
link("TSParameterReference", "Blue")
link("TSProperty",           "Blue")
link("TSVariable",           "Blue")
link("TSField",              "Blue")
link("TSConstant",           "MyBlueBold")
link("TSConstBuiltin",       "MyBlueBold")
link("TSString",             "Purple")
link("TSCharacter",          "Purple")
link("TSAttribute",          "Aqua")
link("TSPunctBracket",       "MyFgBold")
link("TSPunctDelimiter",     "MyFgBold")
link("TSPunctSpecial",       "MyFgBold")
link("TSOperator",           "MyFgBold")
link("TSConstructor",        "MyFgBold")
link("TSSymbol",             "MyFgBold")
----------------------------------------------------------------------------------------------------
--                                          CMP
----------------------------------------------------------------------------------------------------
link("CmpItemAbbrMatch",         "MyLspReference")
link("CmpItemAbbrMatchFuzzy",    "MyLspReference")
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
  link("NvimTreeFolderIcon", "Orange")
  link("NvimTreeFolderName", "Yellow")
  link("NvimTreeOpenedFolderName", "Yellow")
  link("NvimTreeEmptyFolderName", "Yellow")
  link("NvimTreeRootFolder", "Grey")
  link("NvimTreeSymlink", "Aqua")
  link("NvimTreeExecFile", "MyGreenBold")
  link("NvimTreeOpenedFile", "MyFgBold")
  link("NvimTreeSpecialFile", "Aqua")
  link("NvimTreeImageFile", "Fg")
  link("NvimTreeMarkdownFile", "Fg")
  link("NvimTreeIndentMarker", "Grey")
  link("NvimTreeGitDirty", "Green")
  link("NvimTreeGitStaged", "Green")
  link("NvimTreeGitMerge", "Green")
  link("NvimTreeGitRenamed", "Green")
  link("NvimTreeGitNew", "Green")
  link("NvimTreeGitDeleted", "Green")
  link("NvimTreeLspDiagnosticsError", "RedSign")
  link("NvimTreeLspDiagnosticsWarning", "NONE")
  link("NvimTreeLspDiagnosticsInformation", "NONE")
  link("NvimTreeLspDiagnosticsHint", "NONE")
end
----------------------------------------------------------------------------------------------------
--                                          LUALINE
----------------------------------------------------------------------------------------------------
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
function M.lualine()
  local gray_black1   = {fg = colors.gray,   gui = "bold", bg = colors.black1}
  local black_gray    = {fg = colors.black,  gui = "bold", bg = colors.gray}
  local black_green   = {fg = colors.black,  gui = "bold", bg = colors.green}
  local green_black1  = {fg = colors.green,  gui = "bold", bg = colors.black1}
  local black_yellow  = {fg = colors.black,  gui = "bold", bg = colors.yellow}
  local yellow_black1 = {fg = colors.yellow, gui = "bold", bg = colors.black1}
  local black_red     = {fg = colors.black,  gui = "bold", bg = colors.red}
  local red_black1    = {fg = colors.red,    gui = "bold", bg = colors.black1}
  local black_orange  = {fg = colors.black,  gui = "bold", bg = colors.orange}
  local orange_black1 = {fg = colors.orange, gui = "bold", bg = colors.black1}
  local blue_black1   = {fg = colors.blue,   gui = "bold", bg = colors.black1}

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


return M
