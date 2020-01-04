class SettingsController < ApplicationController  

  before_action :verify_token, only: [:create]
  before_action :is_admin?, only: [:create]

  def index
    if params[:index]
      settings = Setting.filter(params)
      return renderCollection("settings", settings, SettingSerializer, nil, pretty)
    else
      setting = Setting.current(@default_country)
      return render json: setting, status: :ok, scope: pretty
    end
  end

  def create    
    country = Country.find_by_hashid(setting_params[:country_id])
    if country && country.setting
      if country.setting
        setting = country.setting
      else
        setting = Setting.current(country)
      end
    else
      setting = Setting.current(@default_country)
    end
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
      params.require(:setting).permit(
                            :last_trade_price, :purchase_percentage, :sale_percentage, 
                            :hour_volume, :active_traders, :market_cap, :daily_transactions, 
                            :active_accounts, :supported_countries, :country_id)
    end
    
    def pretty
      if params[:pretty].present? && params[:pretty] == 'false'
        return nil
      else
        "pretty"
      end
    end
end