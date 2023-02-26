local M = {}

local awful = require("awful")

function M.file_to_table(path)
  local content = {}

  for line in io.lines(path) do
    table.insert(content, line)
  end

  return content
end

function M.split_stdout(stdout)
  local parts = {}
  for part in stdout:gmatch("%S+") do
    table.insert(parts, part)
  end

  return parts
end

function M.open_with_browser(url, callback)
  local cmd = string.format("%s %s", os.getenv("BROWSER"), url)

  callback = callback or function ()
    awful.screen.focused().tags[3]:view_only()
  end

  awful.spawn.easy_async(cmd, callback)
end

return M
