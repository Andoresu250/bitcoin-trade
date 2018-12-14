class CountriesController < ApplicationController
  
  before_action :verify_token, only: [:create, :update, :destroy]
  before_action :is_admin?, only: [:create, :update, :destroy]
  before_action :set_country, only: [:show, :update, :destroy]

  def index
    countries = Country.all
    return render json: countries, scope: "index", status: :ok
  end

  def show
    return render json: @country, status: :ok
  end

  def create
    country = Country.new(country_params)
    if country.save
      return render json: country, status: :created    
    else
      return renderJson(:unprocessable, {error: country.errors.messages})
    end
  end

  def update
    country.assign_attributes(country_params)
    if country.save
      return render json: country, status: :ok    
    else
      return renderJson(:unprocessable, {error: country.errors.messages})
    end
  end

  def destroy
    @country.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_country
      return renderJson(:not_found) unless @country = Country.find_by_hashid(params[:id])
    end

    def country_params
      params.require(:country).permit(
        :name, 
        :code,
        document_types_attributes: [
          :id,
          :name,
          :abbreviation,
          :_destroy
        ]
      )
    end
end
