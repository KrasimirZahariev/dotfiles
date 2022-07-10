local M = {}

local set = require("my.helper").set
local setlocal = require("my.helper").setlocal

set("termguicolors")
set("guifont", "Fira Code Regular Nerd Font Complete:h13")
set("encoding", "utf-8")
set("selection", "old")
set("autoread")
set("history", 5000)
set("backspace", "indent,eol,start")
set("complete", "-i")
set("mouse", "a")
set("hidden")
set("timeout")
set("timeoutlen", 220)
set("cursorline")
set("ruler")
set("number")
set("relativenumber")
set("nrformats", "+alpha")
set("incsearch")
set("ignorecase")
set("smartcase")
set("wildmenu")
set("wildmode", "longest:full,full")
set("wildcharm", 26) -- <C-z>
set("autoindent")
set("tabstop", 2)
set("shiftwidth", 2)
set("expandtab")
set("clipboard", "+unnamedplus")
set("lazyredraw")
set("splitbelow")
set("splitright")
set("sessionoptions", "-options")
set("viewoptions", "-options")
set("undofile")
set("undodir", XDG_DATA_HOME.."/nvim/undodir")
set("swapfile", false)
set("backup", false)
set("writebackup", false)
set("inccommand", "nosplit")
set("cmdheight", 1)
set("shortmess", "+c")
set("signcolumn", "yes")
set("wrapscan")
set("wrap", false)
set("display", "+lastline")
set("scrolloff", 5)
set("sidescrolloff", 5)
set("list")
set("listchars", "tab:>>,extends:⟩,precedes:⟨")
set("pumheight", 10)
-- set("spell")
-- set("foldmethod", "syntax")
-- set("foldenable")
-- vim.cmd("syn region foldImports start="import" end=/import.*\\n^$/ fold keepend")


function M.set_formatoptions()
  set("formatoptions", "-c")
  set("formatoptions", "-r")
  set("formatoptions", "-o")
end

function M.set_xml_options()
  setlocal("wrap")
  setlocal("synmaxcol", 300)
end

function M.set_packer_options()
  setlocal("wrap")
end


return M
