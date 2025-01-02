local Coin = {}

local awful = require("awful")
local gears = require("gears")
local theme = require("myawesome.ui.theme")
local base  = require("myawesome.ui.widgets.base")
local utils = require("myawesome.utils")
local json  = require("myawesome.json")

local ICONS_DIR = os.getenv("XDG_CACHE_HOME").."/awesome/icons/tickers/"
local BASE_URL = "https://www.coingecko.com/en/coins/"
local IMG_URL = "https://api.coingecko.com/api/v3/coins/%s?"..
  "localization=false&tickers=false&market_data=false&community_data=false&developer_data=false"


local function build_icon_widget(coin_id)
  if not gears.filesystem.dir_readable(ICONS_DIR) then
    gears.filesystem.make_directories(ICONS_DIR)
  end

  local icon_path = ICONS_DIR..coin_id..".png";
  local icon_widget = base.build_icon_widget({icon_path = icon_path})

  if not gears.filesystem.file_readable(icon_path) then
    local cmd = string.format("curl -s '%s'", string.format(IMG_URL, coin_id))
    awful.spawn.easy_async(cmd, function (stdout)
      local response = json.parse(stdout)
      base.download_and_set_image(response.image.large, icon_path, icon_widget[1][1])
    end)
  end

  return icon_widget
end

local function build_popup()
  local config = theme.my_ticker_popup

  local popup = awful.popup(config)
  popup.visible = false

  return popup
end

local function hide_popup(o)
  local children = o.popup.widget:get_all_children()
  for _ in pairs(children) do
    o.popup.widget:remove(1)
  end

  o.popup.visible = false
end

local function show_popup(o)
  local function color_price(price)
    local color = "green"
    if tonumber(price) < 0 then
      color = "red"
    end

    return string.format("<span font_weight='bold' foreground='%s'>%s %%</span>", color, price)
  end

  local price_1D  = color_price(string.format("%.2f", o.price_change_percentage_24h_in_currency))
  local price_7D  = color_price(string.format("%.2f", o.price_change_percentage_7d_in_currency))
  local price_30D = color_price(string.format("%.2f", o.price_change_percentage_30d_in_currency))

  local price_text = string.format([[
      1D             7D            30D
    %s        %s        %s    ]], price_1D, price_7D, price_30D)

  local price_change_widget = base.build_text_widget()
  price_change_widget:set_markup(price_text)

  o.popup.widget = price_change_widget
  o.popup.visible = true
end

function Coin:new(id, price_format)
  local o = {
    id = id,
    price_format = price_format,
    price_widget = base.build_text_widget(),
    icon_widget = build_icon_widget(id),
    popup = build_popup(),
    market_cap = nil,
    circulating_supply = nil,
    max_supply = nil,
    price_change_percentage_24h_in_currency = nil,
    price_change_percentage_7d_in_currency = nil,
    price_change_percentage_30d_in_currency = nil,
  }

  setmetatable(o, {__index = self})

  o.icon_widget[1][1]:connect_signal("mouse::enter", function(_) show_popup(o) end)
  o.icon_widget[1][1]:connect_signal("mouse::leave", function(_) hide_popup(o) end)
  o.icon_widget[1][1]:connect_signal("button::press", function(_, _, _, button, _, _)
    if button == 1 then
      utils.open_with_browser(BASE_URL..o.id)
    end
  end)

  o.price_widget:connect_signal("mouse::enter", function(_) show_popup(o) end)
  o.price_widget:connect_signal("mouse::leave", function(_) hide_popup(o) end)
  o.price_widget:connect_signal("button::press", function(_, _, _, button, _, _)
    if button == 1 then
      utils.open_with_browser(BASE_URL..o.id)
    end
  end)

  return o
end

function Coin:set_price(price)
  self.price_widget:set_text(string.format(self.price_format, price))
end


return Coin
