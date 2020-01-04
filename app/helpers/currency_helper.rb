module CurrencyHelper

    include ActionView::Helpers::NumberHelper
        
    def string_to_money(s, precision = 0)
        number_to_currency(s, precision: precision)
    end
    
    def to_percentage(value, precision, sign)
        s = "#{sign ? get_sign(value) : ''}#{value * 100}%"
        return s
    end
    
    private
    
    def get_sign(value)
        value >= 0 ? "+" : ""
    end

end