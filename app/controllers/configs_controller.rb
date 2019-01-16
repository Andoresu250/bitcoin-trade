class ConfigsController < ApplicationController  

  before_action :verify_token, only: [:create]
  before_action :is_admin?, only: [:create]

  def index
    config = Config.current    
    puts config
    return render json: config, status: :ok
  end

  def create    
    config = Config.current
    config.assign_attributes(config_params)
    if config.save      
      return render json: config, status: :created
    else
      return renderJson(:unprocessable, {error: config.errors.messages})
    end
  end

  private

    def config_params      
      params.require(:config).permit(:last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders)
    end
end
  