class SettingsController < ApplicationController  

  before_action :verify_token, only: [:create]
  before_action :is_admin?, only: [:create]

  def index
    setting = Setting.current    
    return render json: setting, status: :ok, scope: pretty
  end

  def create    
    setting = Setting.current
    if setting.nil?
      setting = Setting.new(setting_params)
    else
      setting.assign_attributes(setting_params)
    end
    if setting.save      
      return render json: setting, status: :created
    else
      return renderJson(:unprocessable, {error: setting.errors.messages})
    end
  end

  private

    def setting_params      
      params.require(:setting).permit(:last_trade_price, :purchase_percentage, :sale_percentage, :hour_volume, :active_traders)
    end
    
    def pretty
      if params[:pretty].present? && params[:pretty] == 'false'
        return nil
      else
        "pretty"
      end
    end
end