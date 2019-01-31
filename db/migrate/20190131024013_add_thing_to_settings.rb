class AddThingToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :market_cap, :decimal, default: 0
    add_column :settings, :daily_transactions, :integer, default: 0
    add_column :settings, :active_accounts, :integer, default: 0
    add_column :settings, :supported_countries, :integer, default: 0
  end
end
