class Setting < ApplicationRecord
    
  validates :last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders, presence: true
  
  def self.current
      setting = Setting.last
      setting = new({last_trade_price: 0, purchase_percentage: 0, sale_percentage: 0, hour_volume: 0, active_traders: 0}) if setting.nil?
      return setting
  end
  
end