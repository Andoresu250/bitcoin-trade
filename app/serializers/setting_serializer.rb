class SettingSerializer < ApplicationSerializer
    
    include CurrencyHelper
    
    attributes :last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders, :market_cap, :daily_transactions, :active_accounts, :supported_countries
  
    def last_trade_price
        return pretty? ? "#{string_to_money(object.last_trade_price, 0)} USD" : object.last_trade_price
    end
    def purchase_percentage
        return pretty? ? "#{to_percentage(object.purchase_percentage, 2, true)}" : object.purchase_percentage
    end
    def sale_percentage
        return pretty? ? "#{to_percentage(object.sale_percentage, 2, true)}" : object.sale_percentage
    end
    def hour_volume
        return pretty? ? "#{object.hour_volume.to_i} BTC" : object.hour_volume
    end
    def active_traders
        return pretty? ? "#{object.active_traders}" : object.active_traders
    end
    def market_cap
        return pretty? ? "#{string_to_money(object.market_cap, 0)}" : object.market_cap
    end
    def daily_transactions
        return pretty? ? "#{object.daily_transactions}" : object.daily_transactions
    end
    def active_accounts
        return pretty? ? "#{object.active_accounts}" : object.active_accounts
    end
    def supported_countries
        return pretty? ? "#{object.supported_countries}" : object.supported_countries
    end
    
    def pretty?
        return scope == "pretty"
    end
end
