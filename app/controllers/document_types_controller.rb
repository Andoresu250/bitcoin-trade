class DocumentTypesController < ApplicationController
  before_action :verify_token, only: [:create, :update, :destroy]
  before_action :is_admin?, only: [:create, :update, :destroy]
  before_action :set_document_type, only: [:show, :update, :destroy]

  def index
    document_types = params[:by_country_id].present? ? DocumentType.super_filter(params) : @time_zone_country.document_types.super_filter(params)
    return render json: document_types, scope: "index", status: :ok
  end

  def show
    return render json: @document_type, status: :ok
  end

  def create
    document_type = DocumentType.new(document_type_params)
    if document_type.save
      return render json: document_type, status: :created
    else
      return renderJson(:unprocessable, {error: document_type.errors.messages})
    end
  end

  def update
    @document_type.assign_attributes(document_type_params)
    if @document_type.save
      return render json: @document_type, status: :ok
    else
      return renderJson(:unprocessable, {error: @document_type.errors.messages})
    end
  end

  def destroy
    @document_type.destroy
    return renderJson(:no_content)
  end

  private

    def set_document_type
      return renderJson(:not_found) unless @document_type = DocumentType.find_by_hashid(params[:id])
    end

    def document_type_params
      params.require(:document_type).permit(:name, :abbreviation, :country_id)
    end
end
