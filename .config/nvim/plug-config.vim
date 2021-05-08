"---------------------------------------------------------------------------------------------------
"                                           NERDTree
"---------------------------------------------------------------------------------------------------
let g:WebDevIconsUnicodeGlyphDoubleWidth = 0
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
let g:NERDTreeWinSize=50
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI = 1
" let g:NERDTreeDirArrows = 1
" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
" let g:NERDTreePatternMatchHighlightFullName = 1

"---------------------------------------------------------------------------------------------------
"                                           CoC
"---------------------------------------------------------------------------------------------------
let g:coc_global_extensions = [
      \ 'coc-java',
      \ 'coc-java-debug',
      \ 'coc-snippets',
      \ 'coc-db',
      \ 'coc-yaml',
      \ 'coc-lists',
      \ 'coc-json'
      \ ]

"---------------------------------------------------------------------------------------------------
"                                           Airline
"---------------------------------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_inactive_alt_sep=1
let g:airline_focuslost_inactive = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#tabline#ignore_bufadd_pat='nerd_tree|undotree'
let g:airline#extensions#fzf#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#default#layout = [
      \ [ 'a', 'c' ],
      \ [ 'b', 'x', 'y', 'z', 'error', 'warning' ]
      \ ]
let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

call airline#parts#define_accent('branch', 'bold')

"---------------------------------------------------------------------------------------------------
"                                           IndentLine
"---------------------------------------------------------------------------------------------------
let g:indentLine_enabled=0
let g:indentLine_leadingSpaceEnabled=1
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_fileTypeExclude = ["nerdtree"]

"---------------------------------------------------------------------------------------------------
"                                           VimBeGood
"---------------------------------------------------------------------------------------------------
let g:vim_be_good_floating = 0

"---------------------------------------------------------------------------------------------------
"                                           Signify
"---------------------------------------------------------------------------------------------------
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '–'
let g:signify_sign_delete_first_line = '_'
let g:signify_sign_change            = '~'

"---------------------------------------------------------------------------------------------------
"                                           HighlightedYank
"---------------------------------------------------------------------------------------------------
let g:highlightedyank_highlight_duration = 300

"---------------------------------------------------------------------------------------------------
"                                           VimDadbodUI
"---------------------------------------------------------------------------------------------------
let g:db_ui_use_nerd_fonts = 1

"---------------------------------------------------------------------------------------------------
"                                           UndoTree
"---------------------------------------------------------------------------------------------------
let g:undotree_HelpLine = 1
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1

"---------------------------------------------------------------------------------------------------
"                                           VimVista
"---------------------------------------------------------------------------------------------------
let g:vista_default_executive = 'coc'
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = 40
let g:vista_close_on_jump = 1
let g:vista_blink = [1, 500]
let g:vista_fzf_preview = ['right:70%']
let g:vista_ignore_kinds = ['Package']
let g:vista_no_mappings = 1
let g:vista#renderer#icons = {
      \   "class": "",
      \   "field": "",
      \   "constant": "",
      \   "enum": "",
      \   "enumerator": "",
      \   "interface": "",
      \   "method": "",
      \  }

"---------------------------------------------------------------------------------------------------
"                                           VimTest
"---------------------------------------------------------------------------------------------------
let test#strategy = "neovim"
" let test#neovim#term_position = "vert botright 30"
"---------------------------------------------------------------------------------------------------
"                                           CtrlSF
"---------------------------------------------------------------------------------------------------
let g:ctrlsf_auto_focus = {"at": "start"}
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_mapping = {
      \ "next": "n",
      \ "prev": "N"
      \ }
"---------------------------------------------------------------------------------------------------
"                                           FZF
"---------------------------------------------------------------------------------------------------
" Opening up results in splits
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

"---------------------------------------------------------------------------------------------------
"                                           QuickScope
"---------------------------------------------------------------------------------------------------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=250
let g:qs_buftype_blacklist = ['terminal', 'nofile', 'xml']
let g:qs_lazy_highlight = 1

"---------------------------------------------------------------------------------------------------
"                                           VimHardTime
"---------------------------------------------------------------------------------------------------
let g:hardtime_default_on = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 2
let g:hardtime_timeout = 2000
" let g:list_of_disabled_keys = ["j", "k", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "vista.*", "undotree.*"]

"---------------------------------------------------------------------------------------------------
"                                           VimCppModern
"---------------------------------------------------------------------------------------------------
" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" Enable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 1
