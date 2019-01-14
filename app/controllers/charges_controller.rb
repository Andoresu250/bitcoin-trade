class ChargesController < ApplicationController
  
  include ActionView::Helpers::NumberHelper

  before_action :verify_token
  before_action :set_charge, only: [:show, :destroy, :approve, :deny, :denied]
  before_action :verify_user, only: [:show, :delete]
  before_action :is_admin?, only: [:approve, :deny]

  def index
    charges = @user.is_person? ? @user.profile.charges.filter(params) : Charge.filter(params)
    return renderCollection("charges", charges, ChargeSerializer)
  end
  
  def show
    return render json: @charge, status: :ok
  end
  
  def create
    return renderJson(:unauthorized) unless @user.profile_type == "Person"
    charge = Charge.new(charge_params)
    charge.person = @user.profile
    if charge.save
      money = number_to_currency(charge.amount, precision: 2, unit: charge.country.unit)
      msg = "El usuario #{@user.full_name} ha realizado una recarga por #{money}"
      sbj = "Nueva Recarga de #{@user.full_name}"
      User.by_admins.each {|admin| NotificationMailer.simple_notification(admin, msg, sbj).deliver }
      msg = "Hola #{@user.full_name}, gracias por confiar en nosotros has realizado una recarga por #{money}, validaremos tu dinero tan pronto como sea posible, y si todo esta en orden aprobaremos tu recarga"
      sbj = "Nueva Recarga"
      NotificationMailer.simple_notification(@user, msg, sbj).deliver
      return render json: charge, status: :created
    else
      return renderJson(:unprocessable, {error: charge.errors.messages})
    end
  end
  
  def approve
    if @charge.may_approve?
      @charge.approve!
      person = @charge.person
      user = person.user
      person.balance += @charge.amount
      money = number_to_currency(@charge.amount, precision: 2, unit: @charge.country.unit)
      msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu recarga por #{money} ha sido aprobada exitosamente"
      sbj = "Recarga exitosa"
      NotificationMailer.simple_notification(user, msg, sbj).deliver
      return renderJson(:created, { notice: 'La recarga fue aprobada exitosamente' }) if person.save
    end
    return renderJson(:unprocessable, {error: 'La recarga no se pudo aprobar'})
  end
  
  def deny
    if @charge.may_deny?
      @charge.deny!
      person = @charge.person
      user = person.user
      money = number_to_currency(@charge.amount, precision: 2, unit: @charge.country.unit)
      msg = "Hola #{user.full_name}, lastimosamente tu recarga por #{money} ha sido rechazada dado que no se pudo comprobar la procedencia del dinero, de ser necesario vuelve a intentar el procesonuevamente, las evidencia deben ser lo mas clara posibles para evitar confusiones"
      sbj = "Recarga fallida"
      NotificationMailer.simple_notification(user, msg, sbj).deliver
      return renderJson(:created, { notice: 'La recarga fue rechazada exitosamente' }) if person.save
    end
    return renderJson(:unprocessable, {error: 'La recarga no se pudo rechazar'})
  end
  
  
  
#   def update
#     @charge.assign_attributes(charge_params)
#     if @charge.save
#       return render json: @charge, status: :ok
#     else
#       return renderJson(:unprocessable, {error: @charge.errors.messages})
#     end
#   end
  
#   def destroy
#     @charge.destroy
#     return renderJson(:no_content)
#   end

  private

    def set_charge
      return renderJson(:not_found) unless @charge = Charge.find_by_hashid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.require(:charge).permit(:amount, :evidence)
    end
end
