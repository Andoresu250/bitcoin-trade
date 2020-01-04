class Setting < ApplicationRecord
  
  belongs_to :country
    
  validates :last_trade_price, :hour_volume, :active_traders, :market_cap, :daily_transactions, :active_accounts, :supported_countries, presence: true,  numericality: { greater_than: 0 }
  validates :purchase_percentage, :sale_percentage, numericality: { inclusion: -0.99..0.99 }
  
  scope :by_country_id, -> (country_id) { where(country_id: Country.decode_id(country_id)) }
  
  def self.current(country)
      setting = country.setting
      setting = new({last_trade_price: 0, purchase_percentage: 0, sale_percentage: 0, hour_volume: 0, active_traders: 0, market_cap: 0, daily_transactions: 0, active_accounts: 0, supported_countries: 0, country: country}) if setting.nil?
      return setting
  end
  
  def self.filters
    [:by_country_id]
  end
  
end