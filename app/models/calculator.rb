class Calculator < ActiveModelSerializers::Model
    
  attr_accessor :btc, :currency, :symbol, :value, :mode, :country
  
  def self.BUY_MODE
    0
  end
  
  def self.SELL_MODE
    1
  end
    
  # Create the object
  def initialize(attributes)
    @btc = attributes[:btc].to_f if attributes[:btc].present?
    @currency = attributes[:currency]
    @symbol = attributes[:symbol]
    @value = attributes[:value].to_f if attributes[:value].present?
    @mode = attributes[:mode] || Calculator.BUY_MODE
    @country = attributes[:country] || Country.by_locale(I18n.locale)
    if @btc
      calculate_value
    else
      calculate_btc
    end
    
  end
  
  private
  
  def calculate_value
    url = 'https://blockchain.info/ticker'
    response = RestClient.get url
    
    if response.code == 200
      body = JSON.parse(response.body)
      btc_value = body['USD']['last'].to_f
      puts "btc_value #{btc_value}"
      @value = btc_value * @btc
      unless @currency == 'USD'
        response = RestClient.get "http://www.apilayer.net/api/live?access_key=#{ENV['currencylayer_api_key']}"
        body = JSON.parse(response.body)
        if body['success']
          usd_to_currency = body['quotes']["USD#{@currency}"].to_f
          @value = value * usd_to_currency
          puts "value base #{@value}"
          setting = Setting.current(@country)
          percentage = @mode == Calculator.BUY_MODE ? setting.purchase_percentage : setting.sale_percentage
          puts "percentage #{percentage}"
          @value = (@value * (1 + percentage)).to_f
          puts "value edit #{@value}"
        else
          #TODO: raise error
        end
      end
    end
  end
  
  def calculate_btc
    value = @value
    setting = Setting.current(@country)
    percentage = @mode == Calculator.BUY_MODE ? setting.purchase_percentage : setting.sale_percentage
    value = value * (1 - percentage)
    unless @currency == 'USD'
      response = RestClient.get "http://www.apilayer.net/api/live?access_key=#{ENV['currencylayer_api_key']}"
      body = JSON.parse(response.body)
      if body['success']
        usd_to_currency = body['quotes']["USD#{@currency}"].to_f
        value = value/usd_to_currency
      end
    end
    url = "https://blockchain.info/tobtc?currency=USD&value=#{value}"
    response = RestClient.get url
    if response.code == 200
      @btc = response.body.gsub(/[\s,]/ ,"").to_f
    end
    
  end
  
end