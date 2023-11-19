local M = {}

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local base  = require("myawesome.ui.widgets.base")
local theme = require("myawesome.ui.theme")
local json  = require("myawesome.json")
local utils = require("myawesome.utils")
local debug = require("myawesome.debug")

local JIRA_HOST = os.getenv("JIRA_HOST")

local jira_icon = base.build_icon_widget({icon = "/jira.png"})
local jira_icon_inner = jira_icon[1][1]

local jira_popup = awful.popup(theme.my_top_right_popup)
jira_popup.visible = false

local function hide_popup()
  local children = jira_popup.widget:get_all_children()
  for _ in pairs(children) do
    jira_popup.widget:remove(1)
  end

  jira_popup.visible = false
end

local function build_clickable_title_widget(issue)
  local title = issue.key.." | "..issue.summary
  local widget = base.build_text_widget(title, theme.font)

  widget:connect_signal("mouse::enter", function()
    widget:set_markup(string.format("<span foreground='orange'>%s</span>", title))
  end)

  widget:connect_signal("mouse::leave", function()
    widget:set_text(title)
  end)

  local url = JIRA_HOST.."/browse/"..issue.key
  widget:connect_signal("button::press", function(_, _, _, button, _, _)
    if button == 1 then
      hide_popup()
      utils.open_with_browser(url)
    end
  end)

  return widget
end

local function build_issue_icon_widget(issue_type)
  issue_type = string.lower(issue_type)
  local issue_icon_url = JIRA_HOST.."/images/icons/issuetypes/"..issue_type..".svg"
  local image_path = string.format("%s%s.svg",
    os.getenv("XDG_CACHE_HOME").."/awesome/jira/issue_icons/", issue_type)

  local widget = wibox.widget{
    image  = image_path,
    widget = wibox.widget.imagebox,
  }

  if not gears.filesystem.file_readable(image_path) then
    base.download_and_set_image(issue_icon_url, image_path, widget)
  end

  return {
    layout = wibox.container.place(widget, "center", "center"),

    {
      layout = wibox.container.constraint(widget, "exact", 12, 12),
      widget,
    },
  }
end

local function build_creator_widget(creator)
  if type(creator) == "string" then
    creator = creator
  else
    creator = "unknown"
  end

  return base.build_text_widget(creator, theme.font)
end

local function build_issue_widget(issue)
  local id = base.build_text_widget(issue.id, theme.font)
  local title = build_clickable_title_widget(issue)
  local issue_icon = build_issue_icon_widget(issue.issue_type)
  local creator = build_creator_widget(issue.creator)

  return wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = 1,

    {
      layout = wibox.layout.fixed.horizontal,
      spacing = 3,

      issue_icon,
      title,
    },
    creator,
  })
end

local function add_issue_widgets(popup_widget, issues)
  for _, issue in ipairs(issues) do
    popup_widget:add(build_issue_widget(issue))
  end

end

local function build_popup_widget(issues)
  local popup_widget = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = 20,
  })

  add_issue_widgets(popup_widget, issues)

  return popup_widget
end

local function show_popup()
  awful.spawn.easy_async("bar-output jira", function(stdout)
    local issues = json.parse(stdout)
    if issues == nil then
      return
    end

    jira_popup.widget = build_popup_widget(issues)
    jira_popup.visible = true
  end)
end

jira_icon_inner:connect_signal("button::press", function(_, _, _, button, _, _)
  if button == 1 then
    if jira_popup.visible then
      hide_popup()
      return
    end

    show_popup()
  end
end)


function M.get()
  return {
    icon = jira_icon,
  }
end

return M
