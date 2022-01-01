local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local M = {}

local function is_scratchpad(c, scratchpad)
  return c and awful.rules.match(c, {class = scratchpad})
end

local function hide(c)
  local current_tag = awful.screen.focused().selected_tag
  local client_tags = {}

  for _, tag in pairs(c:tags()) do
    if tag ~= current_tag then
      table.insert(client_tags, tag)
    end
  end

  c:tags(client_tags)
end

local function show_existing(c)
  local current_tag = awful.screen.focused().selected_tag
  local client_tags = {current_tag}

  for _, tag in pairs(c:tags()) do
    if tag ~= current_tag then
      table.insert(client_tags, tag)
    end
  end

  c:tags(client_tags)
  c:raise()
  client.focus = c
end

local function show(scratchpad)
  local all_clients = client.get()
  local current_client_index  = gears.table.hasitem(all_clients, client.focus) or 1

  local function filter(c)
    return is_scratchpad(c, scratchpad)
  end

  local start  = gears.math.cycle(#all_clients, current_client_index + 1)
  for c in awful.client.iterate(filter, start) do
    show_existing(c)
    return
  end

  awful.spawn.easy_async(string.format("awm-scratchpad %s", scratchpad),
    function(_, stderr, _, exit_code)
      if exit_code ~= 0 then
        naughty.notify({
          title = "ERROR",
          text = stderr,
          preset = naughty.config.presets.critical,
          timeout = 5
        })
      end
    end
  )
end

function M.toggle(scratchpad)
  local current_client = client.focus
  if is_scratchpad(current_client, scratchpad) then
    hide(current_client)
  else
    show(scratchpad)
  end
end


return M
