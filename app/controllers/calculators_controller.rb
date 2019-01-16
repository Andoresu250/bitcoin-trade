class CalculatorsController < ApplicationController
  
  before_action :set_country, only: [:create]
    
  def create
    
    calculator = Calculator.new(calculator_params)
    return render json: calculator, status: :ok
  end
    
  private
  
  def calculator_params
    attribues = params.require(:calculator).permit(:btc, :value, :currency)
    if attribues[:currency].present?
      attribues[:symbol] = "$"
    else
      attribues[:currency] = @country.money_code
      attribues[:symbol] = @country.symbol
    end
    return attribues
  end
  
  def set_country
    @country = Country.find_by_hashid(params[:calculator][:country_id])
    @country = @default_country if @country.nil?
  end
    
end
