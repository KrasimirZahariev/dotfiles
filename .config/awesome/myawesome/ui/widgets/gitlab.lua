local M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local base  = require("myawesome.ui.widgets.base")
local theme = require("myawesome.ui.theme")
local json  = require("myawesome.json")
local utils = require("myawesome.utils")
local debug = require("myawesome.debug")

local gitlab_icon = base.build_icon_widget("/gitlab.png", 19)
local gitlab_icon_inner = gitlab_icon[1][1]

local gitlab_popup_config = theme.my_gitlab_popup
gitlab_popup_config.widget = wibox.widget.base.empty_widget()

local gitlab_popup = awful.popup(gitlab_popup_config)
gitlab_popup.visible = false


local function hide_popup()
  local children = gitlab_popup.widget:get_all_children()
  for _ in pairs(children) do
    gitlab_popup.widget:remove(1)
  end

  gitlab_popup.visible = false
end

local function download_icon(author_avatar_url, image_path, widget)
  local cmd = string.format("wget '%s' -O %s", author_avatar_url, image_path)
  awful.spawn.easy_async(cmd, function ()
    widget:set_image(gears.surface.load_uncached(image_path))
  end)
end

local function build_avatar_icon(author_id, author_avatar_url)
  local image_path = string.format("%s%s.png",
    os.getenv("XDG_CACHE_HOME").."/awesome/gitlab_avatars/", author_id)

  local widget = wibox.widget{
    image  = image_path,
    widget = wibox.widget.imagebox,
  }

  if not gears.filesystem.file_readable(image_path) then
    download_icon(author_avatar_url, image_path, widget)
  end

  return {
    layout = wibox.container.place(widget, "center", "center"),

    {
      layout = wibox.container.constraint(widget, "exact", 50, 50),
      widget,
    },
  }
end

local function build_merge_request_url_widget(url)
  local widget = base.build_text_widget(theme.font, url)
  widget:connect_signal("mouse::enter", function()
    widget:set_markup(string.format("<span foreground='orange'>%s</span>", url))
  end)

  widget:connect_signal("mouse::leave", function()
    widget:set_text(url)
  end)

  widget:connect_signal("button::press", function(_, _, _, button, _, _)
    if button == 1 then
      hide_popup()
      utils.open_with_browser(url)
    end
  end)

  return widget
end

local function build_merge_request_widget(merge_request)
  local avatar_icon = build_avatar_icon(merge_request.author_id, merge_request.author_avatar_url)

  local author = base.build_text_widget(theme.font, merge_request.author_name)

  local title = base.build_text_widget(theme.font, merge_request.title)

  local source_target_branch = base.build_text_widget(theme.font,
    string.format("%s -> %s", merge_request.source_branch, merge_request.target_branch)
  )

  local status = base.build_text_widget(theme.font, merge_request.merge_status)

  local url = build_merge_request_url_widget(merge_request.web_url)

  return wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,

    avatar_icon,

    {
      layout = wibox.layout.fixed.vertical,
      spacing = 1,

      author,
      title,
      source_target_branch,
      status,
      url,
    },
  })
end

local function add_merge_request_widgets(popup_widget, merge_requests)
  for _, merge_request in ipairs(merge_requests) do
    popup_widget:add(build_merge_request_widget(merge_request))
  end
end

local function build_popup_widget(merge_requests)
  local popup_widget = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = 20,
  })

  add_merge_request_widgets(popup_widget, merge_requests)

  return popup_widget
end

local function show_popup()
  awful.spawn.easy_async("bar-output gitlab", function(stdout)
    local merge_requests = json.parse(stdout)
    if merge_requests == nil then
      return
    end

    gitlab_popup.widget = build_popup_widget(merge_requests)
    gitlab_popup.visible = true
  end)
end

gitlab_icon_inner:connect_signal("button::press", function(_, _, _, button, _, _)
  if button == 1 then
    if gitlab_popup.visible then
      hide_popup()
      return
    end

    show_popup()
  end
end)

function M.get()
  return {
    icon = gitlab_icon,
  }
end

return M
