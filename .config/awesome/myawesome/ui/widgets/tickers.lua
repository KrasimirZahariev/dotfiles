local M = {}

local wibox = require("wibox")
local awful = require("awful")
local json = require("myawesome.json")
local debug = require("myawesome.debug")
local Coin = require("myawesome.ui.widgets.Coin")

local HORIZONTAL = wibox.layout.fixed.horizontal

local widget = {
  layout = HORIZONTAL,
  spacing = 10,
}

local coins = {
  Coin:new("bitcoin",            "%.0f"),
  Coin:new("ethereum",           "%.0f"),
  Coin:new("solana",             "%.0f"),
  Coin:new("kaspa",              "%.3f"),
  Coin:new("injective-protocol", "%.1f"),
  Coin:new("internet-computer",  "%.1f"),
  Coin:new("arweave",            "%.1f"),
  Coin:new("near",               "%.2f"),
  Coin:new("bittensor",          "%.0f"),
  Coin:new("sui",                "%.2f"),
  Coin:new("solidus-aitech",     "%.2f"),
  Coin:new("delysium",           "%.2f"),
  Coin:new("taraxa",             "%.3f"),
  Coin:new("tectum",             "%.1f"),
  Coin:new("trias-token",        "%.1f"),
  Coin:new("trac",               "%.1f"),
  Coin:new("nakamoto-games",     "%.2f"),
  Coin:new("airtor-protocol",    "%.2f"),
  Coin:new("zeus-network",       "%.3f"),
  -- Coin:new("aleph-zero",         "%.2f"),
  -- Coin:new("polyhedra-network",  "%.2f"),
  -- Coin:new("pups-ordinals",      "%.0f"),
  -- Coin:new("foxy",               "%.4f"),
  -- Coin:new("planet-mojo",        "%.3f"),
}

local coin_ids = ""
for _, coin in pairs(coins) do
  coin_ids = coin_ids..coin.id..'%2C'

  local ticker_widget = {
    layout = HORIZONTAL,
    spacing = 2,
    coin.icon_widget,
    coin.price_widget,
  }

  table.insert(widget, ticker_widget)
end
coin_ids = string.sub(coin_ids, 1, -4)

local cmd = string.format("curl 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=%s"..
  "&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=%s&locale=en'",
  coin_ids, "24h%2C7d%2C30d")

local update_widget_callback = function(_, stdout)
  local response = json.parse(stdout)
  for _, response_coin in ipairs(response) do
    for _, coin in ipairs(coins) do
      if response_coin.id == coin.id then
        coin:set_price(response_coin.current_price)
        coin.market_cap = response_coin.market_cap
        coin.circulating_supply = response_coin.circulating_supply
        coin.max_supply = response_coin.max_supply
        coin.price_change_percentage_24h_in_currency = response_coin.price_change_percentage_24h_in_currency
        coin.price_change_percentage_7d_in_currency = response_coin.price_change_percentage_7d_in_currency
        coin.price_change_percentage_30d_in_currency = response_coin.price_change_percentage_30d_in_currency
      end
    end
  end
end

function M.get_widget()
  awful.widget.watch(cmd, 120, update_widget_callback)
  return widget
end


return M
