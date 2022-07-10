local M = {}

local setlocal = require("my.helper").setlocal

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
  local current = 0
  local should_force = false

  if pcall(vim.api.nvim_win_close, current, {force = should_force}) then
    return
  end

  if vim.bo.buftype == "terminal" then
    should_force = true
  end

  vim.api.nvim_buf_delete(current, {force = should_force})
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


return M
