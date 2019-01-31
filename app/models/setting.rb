class Setting < ApplicationRecord
    
  validates :last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders, :market_cap, :daily_transactions, :active_accounts, :supported_countries, presence: true,  numericality: { greater_than: 0 }
  
  def self.current
      setting = Setting.last
      setting = new({last_trade_price: 0, purchase_percentage: 0, sale_percentage: 0, hour_volume: 0, active_traders: 0, market_cap: 0, daily_transactions: 0, active_accounts: 0, supported_countries: 0}) if setting.nil?
      return setting
  end
  
end