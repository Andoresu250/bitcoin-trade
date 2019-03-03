class BtcChargesController < ApplicationController
  
  include ActionView::Helpers::NumberHelper

  before_action :verify_token
  before_action :set_charge, only: [:show, :destroy, :approve, :deny, :check, :successful]
  before_action :verify_user, only: [:show, :delete, :check]
  before_action :is_admin?, only: [:approve, :deny, :successful]

  def index
    charges = @user.is_person? ? @user.profile.charges.filter(params) : BtcCharge.filter(params)
    return renderCollection("charges", charges, BtcChargeSerializer, ['person.document_type', 'country'])
  end
  
  def show
    return render json: @charge, status: :ok, include: ['person.document_type', 'country']
  end
  
  def create
    return renderJson(:unauthorized) unless @user.profile_type == "Person"
    charge = BtcCharge.new(charge_params)
    charge.person = @user.profile
    if charge.save
      money = number_to_currency(charge.btc, unit: "Ƀ", precision: nil)
      msg = "El usuario #{@user.full_name} ha realizado una recarga por #{money}"
      sbj = "Nueva Recarga de #{@user.full_name}"
      User.by_admins.each {|admin| NotificationMailer.simple_notification(admin, msg, sbj).deliver }
      msg = "Hola #{@user.full_name}, gracias por confiar en nosotros has realizado una recarga por #{money}, validaremos tus bitcoins tan pronto como sea posible, y si todo esta en orden aprobaremos tu recarga y enviaremos el codigo QR para que realices la transferencia"
      sbj = "Nueva Recarga"
      NotificationMailer.simple_notification(@user, msg, sbj).deliver
      return render json: charge, status: :created
    else
      return renderJson(:unprocessable, {error: charge.errors.messages})
    end
  end
  
  def approve
    if @charge.may_approve?
      @charge.assign_attributes(charge_params)
      @charge.approve
      person = @charge.person
      user = person.user      
      if @charge.valid?(:approve)        
        @charge.save
        money = number_to_currency(@charge.btc, unit: "Ƀ", precision: nil)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu recarga por #{money} ha sido aprobada exitosamente, usa este codigo QR para realizar la transferencia"
        sbj = "Recarga aceptada"
        NotificationMailer.image_notification(user, msg, sbj, @charge.qr.url).deliver
        return renderJson(:created, { notice: 'La recarga fue aprobada exitosamente' })
      else
        unless @charge.valid?(:approve) 
          puts @charge.errors.full_messages
          return renderJson(:unprocessable, {error: @charge.errors.messages})
        end
      end
      puts "asd"
    end
    return renderJson(:unprocessable, {error: 'La recarga no se pudo aprobar'})
  end

  def check
    if @charge.may_check?
      @charge.assign_attributes(charge_params)
      @charge.check
      person = @charge.person
      user = person.user      
      if @charge.valid?(:check)        
        @charge.save
        money = number_to_currency(@charge.btc, unit: "Ƀ", precision: nil)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu recarga por #{money} ha sido aprobada exitosamente, usa este codigo QR para realizar la transferencia"
        sbj = "Recarga aceptada"
        NotificationMailer.simple_notification(user, msg, sbj).deliver
        return renderJson(:created, { notice: 'La recarga fue aprobada exitosamente' })
      else
        unless @charge.valid?(:check)
          puts @charge.errors.full_messages
          return renderJson(:unprocessable, {error: @charge.errors.messages})
        end        
      end
      
    end
    return renderJson(:unprocessable, {error: 'La recarga no se pudo validar'})
  end

  def successful
    if @charge.may_successful?      
      @charge.successful
      person = @charge.person
      person.btc += @charge.btc
      user = person.user      
      if person.valid? && @charge.valid?(:successful)        
        @charge.save
        person.save
        money = number_to_currency(@charge.btc, unit: "Ƀ", precision: nil)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu recarga por #{money} ha sido efectuada exitosamente, ahora podras hacer uso de tus BTC para venderlos"
        sbj = "Recarga aceptada"
        NotificationMailer.simple_notification(user, msg, sbj).deliver
        return renderJson(:created, { notice: 'La recarga fue aprobada exitosamente' })
      else
        unless @charge.valid?(:successful)  
          puts @charge.errors.full_messages
          return renderJson(:unprocessable, {error: @charge.errors.messages})
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
      money = number_to_currency(charge.btc, unit: "Ƀ", precision: nil)
      msg = "Hola #{user.full_name}, lastimosamente tu recarga por #{money} ha sido rechazada, de ser necesario vuelve a intentar el proceso nuevamente"
      sbj = "Recarga fallida"
      NotificationMailer.simple_notification(user, msg, sbj).deliver
      return renderJson(:created, { notice: 'La recarga fue rechazada exitosamente' }) if person.save
    end
    return renderJson(:unprocessable, {error: 'La recarga no se pudo rechazar'})
  end

  private

    def set_charge
      return renderJson(:not_found) unless @charge = BtcCharge.find_by_hashid(params[:id])
    end
    
    def charge_params
      params.require(:charge).permit(:btc, :evidence, :qr)
    end
    
    def verify_user
      return renderJson(:unauthorized) if not ((@user.profile_type == "Person" && @user.profile_id == @charge.person_id) || (@user.is_admin?))
    end
end
