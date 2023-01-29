local M = {}

local setlocal = require("my.helper").setlocal

function M.esc(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- execute sys command and get the output
function M.sys_exec(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()

  if raw then
    return s
  end

  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')

  return s
end

function M.toggle_venn()
  if vim.b.venn_enabled == nil then
    vim.b.venn_enabled = true
    setlocal("virtualedit", "all")
    require("mappings").venn()
  else
    vim.b.venn_enabled = nil
    setlocal("virtualedit", "")
    vim.cmd("mapclear <buffer>")
  end
    vim.notify("Venn toggled")
end

function M.close()
  local should_force = false
  if vim.bo.buftype == "terminal" or vim.bo.filetype == "help" then
    should_force = true
  end

  require('bufdelete').bufdelete(0, should_force)

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    vim.api.nvim_buf_delete(0, {})
  end
end

function M.draw_column_line(max_line_length)
  local last_line = vim.fn.line("$")
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, last_line, false)

  for _, line in ipairs(buf_lines) do
    if #line > max_line_length then
      setlocal("colorcolumn", tostring(max_line_length))
      return
    end
  end

  setlocal("colorcolumn", "0")
end

function M.delete_trailing_ws_nl()
  local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(0))

  vim.cmd([[silent %s/\s\+$//e]])
  vim.cmd([[silent %s/\n\+\%$//e]])

  local last_line = vim.fn.line("$")
  if current_line > last_line then
      current_line = last_line
  end

  vim.api.nvim_win_set_cursor(0, {current_line, current_col})
end

function M.jump_to_last_position()
  local last_pre_save_position = vim.fn.line("'\"")
  local last_line = vim.fn.line("$")
  if last_pre_save_position > 0 and last_pre_save_position <= last_line then
    vim.cmd([[normal! g'"]])
  end
end

function M.reload_config(file)
  local reload_config = {
    [XDG_CONFIG_HOME.."/i3/config"] = function() vim.cmd("silent! !i3-msg restart") end,
    [XDG_CONFIG_HOME.."/polybar/config"] = function() vim.cmd("silent! !i3-msg restart") end,
    [XDG_CONFIG_HOME.."/tmux/tmux.conf"] = function()
      vim.cmd("silent! !tmux source "..file.." && tmux display 'CONFIG RELOADED'")
    end,
  }

  reload_config[file]()
end

function M.set_visual_selection(start_row, start_col, end_row, end_col)
  vim.fn.setpos(".", {0, start_row + 1, start_col + 1, 0})
  vim.cmd("normal! v")
  vim.fn.setpos(".", {0, end_row + 1, end_col, 0})
end

function M.get_visual_selection_content()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    vim.cmd("normal! gv")
  end

  local original_content = vim.fn.getreg("z")
  vim.cmd('normal! "zygv')
  local visual_selection_content = vim.fn.getreg("z")
  vim.fn.setreg("z", original_content)

  return visual_selection_content
end

function M.select_statement()
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  cursor_row = cursor_row -1

  local node = vim.treesitter.get_node_at_pos(0, cursor_row, cursor_col, {})
  while node:parent():parent() ~= nil do
    node = node:parent()
  end

  M.set_visual_selection(node:range())
end

function M.execute_query()
  M.select_statement()
  vim.api.nvim_feedkeys(M.esc("<Plug>(DBUI_ExecuteQuery)<CR>"), 'm', false)
end

function M.lualine_diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end


return M
