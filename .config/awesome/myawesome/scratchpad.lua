local awful = require("awful")
local naughty = require("naughty")

local M = {}

local function is_scratchpad(client)
  return awful.rules.match(client, { class = "scratchpad.*" })
end

local function get_scratchpad_clients()
  local scratchpads = {}
  for c in awful.client.iterate(is_scratchpad, nil) do
    table.insert(scratchpads, c)
  end
  return scratchpads
end

local function is_already_vissible(scratchpad_clients, scratchpad_class)
  for _, c in ipairs(scratchpad_clients) do
    if awful.rules.match(c, { class = scratchpad_class }) then
      for _, tag in ipairs(c:tags()) do
        -- if the scratchpad is currently on the selected tag, it is visible
        if tag == awful.screen.focused().selected_tag then
          return true
        end
      end
    end
  end

  return false
end

local function hide_all(scratchpad_clients)
  for _, c in ipairs(scratchpad_clients) do
    c:tags({})
  end
end

local function show_existing(scratchpad_clients, scratchpad_class)
  for _, c in ipairs(scratchpad_clients) do
    if awful.rules.match(c, { class = scratchpad_class }) then
      c:tags({ awful.screen.focused().selected_tag })
      c:raise()
      client.focus = c
      return true
    end
  end

  return false
end

local function spawn_new(scratchpad_class)
  awful.spawn.easy_async(string.format("awm-scratchpad %s", scratchpad_class),
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

function M.toggle(scratchpad_class)
  local scratchpad_clients = get_scratchpad_clients()
  local already_visible = is_already_vissible(scratchpad_clients, scratchpad_class)

  hide_all(scratchpad_clients)

  -- if the scratchpad was already visible, we're done (toggling it off)
  if already_visible then return end

  local showed_existing = show_existing(scratchpad_clients, scratchpad_class)
  if showed_existing then return end

  spawn_new(scratchpad_class)
end


return M
