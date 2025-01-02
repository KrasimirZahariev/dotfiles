local awful = require("awful")
local gears = require("gears")
local scratchpad = require("myawesome.scratchpad")

local M = {}

local TERMINAL = os.getenv("TERMINAL")
local BROWSER = os.getenv("BROWSER")

local function parse_key_combination(key_combination)
  local modifiers_table = {
    SUPER = "Mod4",
    ALT = "Mod1",
    SHIFT = "Shift",
    CONTROL = "Control"
  }

  local modifiers = {}
  local key
  for _key in string.gmatch(key_combination, '[^ + ]+') do
    if (modifiers_table[string.upper(_key)] ~= nil) then
      table.insert(modifiers, modifiers_table[string.upper(_key)])
    else
      key = _key
    end
  end

  return modifiers, key
end

local function keybind(key_combination, action)
  local modifiers, key = parse_key_combination(key_combination)
  return awful.key(modifiers, key, action)
end

local function run(program, callback)
  callback = callback or function() end
  return function() awful.spawn.easy_async(program, callback) end
end

local function kill_client()
  return function(c) c:kill() end
end

local function focus_client(direction)
  return function() awful.client.focus.bydirection(direction) end
end

local function swap_client(direction)
  return function() awful.client.swap.bydirection(direction) end
end

local function resize_horizontal(factor)
  return function()
    local layout = awful.layout.get(awful.screen.focused())
    if layout == awful.layout.suit.tile then
      awful.tag.incmwfact(-factor)
    elseif layout == awful.layout.suit.tile.left then
      awful.tag.incmwfact(factor)
    elseif layout == awful.layout.suit.tile.top then
      awful.client.incwfact(-factor)
    elseif layout == awful.layout.suit.tile.bottom then
      awful.client.incwfact(-factor)
    end
  end
end

local function resize_vertical(factor)
  return function()
    local layout = awful.layout.get(awful.screen.focused())
    if layout == awful.layout.suit.tile then
      awful.client.incwfact(-factor)
    elseif layout == awful.layout.suit.tile.left then
      awful.client.incwfact(-factor)
    elseif layout == awful.layout.suit.tile.top then
      awful.tag.incmwfact(-factor)
    elseif layout == awful.layout.suit.tile.bottom then
      awful.tag.incmwfact(factor)
    end
  end
end

local function toggle_fullscreen()
  return function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end
end

local shared_actions = {
  vertical_split =    {wm = run(TERMINAL),            tmux = "tmux split-window -h"},
  horizontal_split =  {wm = run(TERMINAL),            tmux = "tmux split-window -v"},
  close_window =      {wm = kill_client(),            tmux = "tmux kill-pane"},
  focus_left =        {wm = focus_client("left"),     tmux = "tmux select-pane -L"},
  focus_down =        {wm = focus_client("down"),     tmux = "tmux select-pane -D"},
  focus_up =          {wm = focus_client("up"),       tmux = "tmux select-pane -U"},
  focus_right =       {wm = focus_client("right"),    tmux = "tmux select-pane -R"},
  swap_left =         {wm = swap_client("left"),      tmux = "tmux swap-pane -s '{left-of}'"},
  swap_down =         {wm = swap_client("down"),      tmux = "tmux swap-pane -s '{down-of}'"},
  swap_up =           {wm = swap_client("up"),        tmux = "tmux swap-pane -s '{up-of}'"},
  swap_right =        {wm = swap_client("right"),     tmux = "tmux swap-pane -s '{right-of}'"},
  resize_left =       {wm = resize_horizontal(0.05),  tmux = "tmux resize-pane -L 5"},
  resize_down =       {wm = resize_vertical(0.05),    tmux = "tmux resize-pane -D 5"},
  resize_up =         {wm = resize_vertical(-0.05),   tmux = "tmux resize-pane -U 5"},
  resize_right =      {wm = resize_horizontal(-0.05), tmux = "tmux resize-pane -R 5"},
  fullscreen_window = {wm = toggle_fullscreen(),      tmux = "tmux resize-pane -Z"},
}

local function handle_tmux_binding(action)
  local cmd = shared_actions[action].tmux
  if cmd ~= nil then
    awful.spawn.easy_async(cmd, function() end)
  end
end

local function handle_wm_binding(action, focused_client)
  local cmd = shared_actions[action].wm
  if cmd ~= nil then
    if focused_client then
      return cmd(focused_client)
    end
    return cmd()
  end
end

local function shared_binding(action)
  return function()
    local focused_client = client.focus
    if focused_client and focused_client.pid then
      awful.spawn.easy_async("pstree " .. focused_client.pid,
        function(stdout)
          if string.find(stdout, "tmux") then
            return handle_tmux_binding(action)
          end

          return handle_wm_binding(action, focused_client)
        end)
    else
      return handle_wm_binding(action)
    end
  end
end

local function cycle_layouts()
  return function() awful.layout.inc(1) end
end

local function toggle_scratchpad(scratchpad_type)
  return function() scratchpad.toggle(scratchpad_type) end
end

local function maximize()
  return function(c)
    c.maximized = not c.maximized
    c:raise()
  end
end

local function maximize_vertically()
   return function(c)
     c.maximized_vertical = not c.maximized_vertical
     c:raise()
   end
end

local function maximize_horizontally()
   return function(c)
     c.maximized_horizontal = not c.maximized_horizontal
     c:raise()
   end
end

local function go_to_tag(tag_number)
  return function()
    local screen = awful.screen.focused()
    local tag = screen.tags[tag_number]
    if tag then
      -- toggle between prev and current if the same keybind is pressed
      if tag.selected then
        awful.tag.history.restore(screen, 1)
      else
        tag:view_only()
      end
    end
  end
end

local function toggle_tag_display(tag_number)
  return function ()
    local screen = awful.screen.focused()
    local tag = screen.tags[tag_number]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end
end

local function move_client_to_tag(tag_number)
  return function()
    if client.focus then
      local tag = client.focus.screen.tags[tag_number]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end
  end
end

local function toggle_tag_focused_display(tag_number)
  return function ()
    if client.focus then
      local tag = client.focus.screen.tags[tag_number]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end
end

local function rearrange_clients()
  for _, c in ipairs(client.get()) do
    awful.rules.apply(c)
  end
end

local function mousebind(key_combination, action)
  local modifiers, key = parse_key_combination(key_combination)
  return awful.button(modifiers, key, action)
end

local function mouse_action(action)
  return function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    if action == "move" then
      awful.mouse.client.move(c)
    elseif action == "resize" then
      awful.mouse.client.resize(c)
    else
      return
    end
  end
end

function M.setup()
  local global_bindings = gears.table.join(
    keybind("SUPER + Tab",           awful.tag.history.restore),
    keybind("SUPER + u",             awful.client.urgent.jumpto),
    keybind("SUPER + SHIFT + r",     awesome.restart),
    keybind("SUPER + SHIFT + e",     run("dmenu-exit")),
    keybind("SUPER + SHIFT + x",     run("xkill")),
    keybind("SUPER + Escape",        cycle_layouts()),
    keybind("SUPER + Return",        toggle_scratchpad("scratchpad-terminal")),
    keybind("SUPER + n",             toggle_scratchpad("scratchpad-notes")),
    keybind("SUPER + t",             toggle_scratchpad("scratchpad-todo")),
    keybind("SUPER + e",             toggle_scratchpad("scratchpad-restclient")),
    keybind("SUPER + v",             shared_binding("vertical_split")),
    keybind("SUPER + s",             shared_binding("horizontal_split")),
    keybind("SUPER + b",             run(BROWSER)),
    keybind("SUPER + d",             run("dmenu_run")),
    keybind("SUPER + g",             run("dmenu-web-search")),
    keybind("SUPER + p",             run("dmenu-pass")),
    -- keybind("SUPER + F10",           run("monitor-toggle", rearrange_clients)),
    keybind("SUPER + F10",           run("monitor-toggle", awesome.restart)),
    keybind("SUPER + F11",           run("touchpad-toggle")),
    keybind("SUPER + F12",           run("lock-screen")),
    keybind("Print",               run("take-screenshot full")),
    keybind("SHIFT + Print",       run("take-screenshot window")),
    keybind("CONTROL + Print",     run("take-screenshot selection")),

    -- used in conjunction with keyd
    keybind("SUPER + SHIFT + ALT + o", run("music-player open", function(_, _, _, exitcode)
      if exitcode == 1 then return end
      awesome.emit_signal("music_player_open")
    end)),
    keybind("SUPER + SHIFT + ALT + q", run("music-player quit", function()
      awesome.emit_signal("music_player_quit")
    end)),
    keybind("SUPER + SHIFT + ALT + p", run("music-player toggle-pause", function()
      awesome.emit_signal("music_player_toggle_paused")
    end)),
    keybind("SUPER + SHIFT + ALT + r", run("music-player loop")),
    keybind("SUPER + SHIFT + ALT + h", run("music-player playlist-prev")),
    keybind("SUPER + SHIFT + ALT + l", run("music-player playlist-next")),
    keybind("SUPER + SHIFT + ALT + j", run("music-player volume-down")),
    keybind("SUPER + SHIFT + ALT + k", run("music-player volume-up"))
  )
  -- Bind all key numbers to tags.
  for i = 1, 10 do
    local keycode = "#" .. tostring(i + 9)
    global_bindings = gears.table.join(global_bindings,
      keybind("SUPER + " .. keycode,                   go_to_tag(i)),
      keybind("SUPER + CONTROL + " .. keycode,         toggle_tag_display(i)),
      keybind("SUPER + SHIFT + " .. keycode,           move_client_to_tag(i)),
      keybind("SUPER + CONTROL + SHIFT + " .. keycode, toggle_tag_focused_display(i))
    )
  end

  -- Set global bindings
  root.keys(global_bindings)

  local client_bindings = gears.table.join(
    keybind("SUPER + h",                shared_binding("focus_left")),
    keybind("SUPER + j",                shared_binding("focus_down")),
    keybind("SUPER + k",                shared_binding("focus_up")),
    keybind("SUPER + l",                shared_binding("focus_right")),
    keybind("SUPER + SHIFT + h",        shared_binding("swap_left")),
    keybind("SUPER + SHIFT + j",        shared_binding("swap_down")),
    keybind("SUPER + SHIFT + k",        shared_binding("swap_up")),
    keybind("SUPER + SHIFT + l",        shared_binding("swap_right")),
    keybind("SUPER + CONTROL + h",      shared_binding("resize_left")),
    keybind("SUPER + CONTROL + j",      shared_binding("resize_down")),
    keybind("SUPER + CONTROL + k",      shared_binding("resize_up")),
    keybind("SUPER + CONTROL + l",      shared_binding("resize_right")),
    keybind("SUPER + q",                shared_binding("close_window")),
    keybind("SUPER + f",                shared_binding("fullscreen_window")),
    keybind("SUPER + m",                maximize()),
    keybind("SUPER + SHIFT + m",        maximize_vertically()),
    keybind("SUPER + CONTROL + m",      maximize_horizontally()),
    keybind("SUPER + CONTROL + Return", awful.client.floating.toggle)
  )

  local mouse_bindings = gears.table.join(
    mousebind("1", mouse_action()),
    mousebind("SUPER + 1", mouse_action("move")),
    mousebind("SUPER + 3", mouse_action("resize"))
  )

  -- Will be used in rules.lua
  return {
    client_bindings = client_bindings,
    mouse_bindings = mouse_bindings
  }
end

return M
