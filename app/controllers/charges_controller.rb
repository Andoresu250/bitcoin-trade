class ChargesController < ApplicationController

  include ActionView::Helpers::NumberHelper

  before_action :verify_token
  before_action :set_charge, only: [:show, :destroy, :approve, :deny]
  before_action :verify_user, only: [:show, :destroy]
  before_action :is_admin?, only: [:approve, :deny]

  def index
    charges = @user.is_person? ? @user.profile.charges.super_filter(params) : Charge.super_filter(params)
    return renderCollection("charges", charges, ChargeSerializer, ['person.document_type', 'country', 'charge_point'])
  end

  def show
    return render json: @charge, status: :ok, include: ['person.document_type', 'country', 'charge_point']
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
      @charge.approve
      person = @charge.person
      user = person.user
      person.balance += @charge.amount
      if person.valid? && @charge.valid?
        person.save
        @charge.save
        money = number_to_currency(@charge.amount, precision: 2, unit: @charge.country.unit)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu recarga por #{money} ha sido aprobada exitosamente"
        sbj = "Recarga exitosa"
        NotificationMailer.simple_notification(user, msg, sbj).deliver
        return renderJson(:created, { notice: 'La recarga fue aprobada exitosamente' })
      else
        unless person.valid?
          puts person.errors.full_messages
        end
        unless @charge.valid?
          puts @charge.errors.full_messages
        end
      end

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

  private

    def set_charge
      return renderJson(:not_found) unless @charge = Charge.find_by_hashid(params[:id])
    end

    def charge_params
      params.require(:charge).permit(:amount, :evidence, :charge_point_id)
    end

    def verify_user
      return renderJson(:unauthorized) if not ((@user.profile_type == "Person" && @user.profile_id == @charge.person_id) || (@user.is_admin?))
    end
end
