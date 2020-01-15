class ChangeLastTradePriceInSettings < ActiveRecord::Migration[5.2]
  def change
    change_column :settings, :last_trade_price, :string
  end
end
