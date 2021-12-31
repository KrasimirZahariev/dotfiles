local g = vim.g

g['gruvbox_material_background'] = 'medium'
g['gruvbox_material_palette'] = 'material'
g['gruvbox_material_visual'] = 'green background'
g['gruvbox_material_menu_selection_background'] = 'green'
g['gruvbox_material_ui_contrast'] = 'high'
g['gruvbox_material_enable_bold'] = 1
g['gruvbox_material_diagnostic_text_highlight'] = 1
g['gruvbox_material_better_performance'] = 1

-- default colors (dark, medium, material)
-- g['gruvbox_material_palette'] = {
--    ['bg0'] =              {'#282828',   '234'},
--    ['bg1'] =              {'#32302f',   '235'},
--    ['bg2'] =              {'#32302f',   '235'},
--    ['bg3'] =              {'#45403d',   '237'},
--    ['bg4'] =              {'#45403d',   '237'},
--    ['bg5'] =              {'#5a524c',   '239'},
--    ['bg_statusline1'] =   {'#32302f',   '235'},
--    ['bg_statusline2'] =   {'#3a3735',   '235'},
--    ['bg_statusline3'] =   {'#504945',   '239'},
--    ['bg_diff_green'] =    {'#34381b',   '22'},
--    ['bg_visual_green'] =  {'#3b4439',   '22'},
--    ['bg_diff_red'] =      {'#402120',   '52'},
--    ['bg_visual_red'] =    {'#4c3432',   '52'},
--    ['bg_diff_blue'] =     {'#0e363e',   '17'},
--    ['bg_visual_blue'] =   {'#374141',   '17'},
--    ['bg_visual_yellow'] = {'#4f422e',   '94'},
--    ['bg_current_word'] =  {'#3c3836',   '236'},
--    ['fg0'] =              {'#d4be98',   '223'},
--    ['fg1'] =              {'#ddc7a1',   '223'},
--    ['red'] =              {'#ea6962',   '167'},
--    ['orange'] =           {'#e78a4e',   '208'},
--    ['yellow'] =           {'#d8a657',   '214'},
--    ['green'] =            {'#a9b665',   '142'},
--    ['aqua'] =             {'#89b482',   '108'},
--    ['blue'] =             {'#7daea3',   '109'},
--    ['purple'] =           {'#d3869b',   '175'},
--    ['bg_red'] =           {'#ea6962',   '167'},
--    ['bg_green'] =         {'#a9b665',   '142'},
--    ['bg_yellow'] =        {'#d8a657',   '214'},
--    ['grey0'] =            {'#7c6f64',   '243'},
--    ['grey1'] =            {'#928374',   '245'},
--    ['grey2'] =            {'#a89984',   '246'},
--    ['none'] =             {'NONE',      'NONE'}
--  }


vim.cmd([[
autocmd vimrc ColorScheme * highlight QuickScopePrimary guifg=#ffffff gui=underline,bold
autocmd vimrc ColorScheme * highlight QuickScopeSecondary guifg=#5fffff gui=underline,bold
]])

vim.cmd('colorscheme gruvbox-material')
vim.cmd('syntax on')

vim.cmd([[
highlight! link TSConditional Orange
highlight! link TSRepeat Orange
highlight! link TSKeyword Orange
highlight! link TSKeywordFunction Orange
highlight! link TSInclude Orange

highlight! link TSParameter Blue
highlight! link TSParameterReference Blue
highlight! link TSProperty Blue
highlight! link TSVariable Blue
highlight! link TSField Blue
highlight! link TSConstant BlueBold
highlight! link TSConstBuiltin BlueBold


highlight! link TSString Purple

highlight! link TSAttribute Aqua

highlight MyFgBold guifg=#d4be98 gui=bold
highlight! link TSPunctBracket MyFgBold
highlight! link TSPunctDelimiter MyFgBold
highlight! link TSOperator MyFgBold
highlight! link TSConstructor MyFgBold
highlight! link TSSymbol MyFgBold

highlight MyLspReference guifg=#fcdb00 guibg=#305932 gui=bold
highlight! link CurrentWord MyLspReference

highlight! default link LspCodeLens YellowBold
highlight! default link LspSignatureActiveParameter YellowBold

sign define DiagnosticSignError text= texthl= linehl= numhl=RedSign
sign define DiagnosticSignWarn text= texthl= linehl= numhl=YellowSign
sign define DiagnosticSignInfo text= texthl= linehl= numhl=BlueSign
sign define DiagnosticSignHint text= texthl= linehl= numhl=GreenSign
]])
