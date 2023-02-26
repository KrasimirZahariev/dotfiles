local M = {}

local wibox = require("wibox")
local base = require("myawesome.ui.widgets.base")

local HORIZONTAL = wibox.layout.fixed.horizontal

local bitcoin_icon = base.build_icon_widget("/bitcoin.svg")
local bitcoin_price = base.build_text_widget()

local ethereum_icon = base.build_icon_widget("/ethereum.svg")
local ethereum_price = base.build_text_widget()

local cardano_icon = base.build_icon_widget("/cardano.svg")
local cardano_price = base.build_text_widget()

local tickers_widget = wibox.widget({
  layout = HORIZONTAL,
  spacing = 10,

  {
    layout = HORIZONTAL,
    spacing = 2,

    bitcoin_icon,
    bitcoin_price,
  },
  {
    layout = HORIZONTAL,
    spacing = 2,

    ethereum_icon,
    ethereum_price,
  },
  {
    layout = HORIZONTAL,
    spacing = 2,

    cardano_icon,
    cardano_price,
  },
})

function M.get_widget()
  base.watch("tickers", 120, {bitcoin_price, ethereum_price, cardano_price})
  return tickers_widget
end


return M
