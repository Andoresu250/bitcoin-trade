class SettingSerializer < ApplicationSerializer
  attributes :last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders
end
