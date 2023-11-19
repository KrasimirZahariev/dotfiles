local M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local base  = require("myawesome.ui.widgets.base")
local theme = require("myawesome.ui.theme")
local json  = require("myawesome.json")
local utils = require("myawesome.utils")
local debug = require("myawesome.debug")

local gitlab_icon = base.build_icon_widget({icon = "/gitlab.png", size = 19})
local gitlab_icon_inner = gitlab_icon[1][1]

local gitlab_popup = awful.popup(theme.my_top_right_popup)
gitlab_popup.visible = false

local function hide_popup()
  local children = gitlab_popup.widget:get_all_children()
  for _ in pairs(children) do
    gitlab_popup.widget:remove(1)
  end

  gitlab_popup.visible = false
end

local function build_avatar_icon(author_id, author_avatar_url)
  local image_path = string.format("%s%s.png",
    os.getenv("XDG_CACHE_HOME").."/awesome/gitlab_avatars/", author_id)

  local icon_widget = base.build_icon_widget({icon_path = image_path, size = 50})

  if not gears.filesystem.file_readable(image_path) then
    base.download_and_set_image(author_avatar_url, image_path, icon_widget[1][1])
  end

  return icon_widget
end

local function build_merge_request_url_widget(url)
  local widget = base.build_text_widget(url)
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

  local author = base.build_text_widget(merge_request.author_name)

  local title = base.build_text_widget(merge_request.title)

  local source_target_branch = base.build_text_widget(
    string.format("%s -> %s", merge_request.source_branch, merge_request.target_branch)
  )

  local status = base.build_text_widget(merge_request.merge_status)

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
