class ChargePointsController < ApplicationController
  
  before_action :verify_token, only: [:create, :update, :delete]
  before_action :is_admin?, only: [:create, :update, :delete]

  def index
    params[:per_page] = 100
    params[:page] = 1
    if params[:locale]
      params[:by_country_id] = nil
      @charge_points = @default_country.charge_points.filter(params)
    else
      @charge_points = ChargePoint.filter(params)
    end
    return render json: @charge_points, status: :ok
  end
  def show
    return render json: @charge_point, status: :ok
  end
  
  def create
    charge_point = ChargePoint.new(charge_point_params)
    if charge_point.save  
      return render json: charge_point, status: :created    
    else
      return renderJson(:unprocessable, {errors: charge_point.errors.messages})
    end
  end
  
  def update
    @charge_point.assign_attributes(charge_point_params)
    if @charge_point.save
      return render json: @charge_point, status: :ok    
    else
      return renderJson(:unprocessable, {errors: @charge_point.errors.messages})
    end
  end
  
  def destroy
    @charge_point.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_charge_point
      return renderJson(:not_found) unless @charge_point = ChargePoint.find_by_hashid(params[:id])
    end
    
    def charge_point_params
      params.require(:charge_point).permit(:owner, :account_type, :number, :owner_identification, :iban, :country_id, :bank)
    end
end
