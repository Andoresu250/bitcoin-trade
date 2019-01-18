class PurchasesController < ApplicationController

  include ActionView::Helpers::NumberHelper

  before_action :verify_token
  before_action :set_purchase, only: [:show, :destroy, :approve, :deny]
  before_action :verify_user, only: [:show, :delete]
  before_action :is_admin?, only: [:approve, :deny]

  def index
    purchases = @user.is_person? ? @user.profile.purchases.filter(params) : Purchase.filter(params)
    return renderCollection("purchases", purchases, PurchaseSerializer, ['person.document_type', 'country'])
  end
  
  def show
    return render json: @purchase, status: :ok, include: ['person.document_type', 'country']
  end

  def create
    return renderJson(:unauthorized) unless @user.profile_type == "Person"
    purchase = Purchase.new(purchase_params)    
    person = @user.profile
    purchase.person = person
    purchase.country = person.country
    purchase.set_btc
    if purchase.valid?
      person.balance -= purchase.value
      return renderJson(:unprocessable, {error: 'No tienes el saldo suficiente para esta compra'}) unless person.save
    end
    if purchase.save
      money = number_to_currency(purchase.value, unit: purchase.country.unit)
      btc = purchase.btc
      msg = "El usuario #{@user.full_name} ha realizado una compra por #{btc}"
      sbj = "Nueva compra de #{@user.full_name}"
      User.by_admins.each {|admin| NotificationMailer.simple_notification(admin, msg, sbj).deliver }
      msg = "Hola #{@user.full_name}, gracias por confiar en nosotros has una compra de #{btc} bitcoins por valor de #{money}, validaremos tu dinero tan pronto como sea posible, y si todo esta en orden aprobaremos tu compra y se te sera transferido la cantidad de btc aquirido a tu billetera"
      sbj = "Nueva Compra"
      NotificationMailer.simple_notification(@user, msg, sbj).deliver
      return render json: purchase, status: :created, include: ['person.document_type', 'country']
    else
      return renderJson(:unprocessable, {error: purchase.errors.messages})
    end
  end

  def approve
    if @purchase.may_approve?
      @purchase.approve
      @purchase.assign_attributes(purchase_params)
      if @purchase.save(context: :approve)
        user = @purchase.person.user      
        money = number_to_currency(@purchase.value, unit: @purchase.country.unit)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu compra de #{@purchase.btc} bitcoins por valor #{money} de ha sido aprobada exitosamente, revisa tu billetera y valida que todo este en orden."
        sbj = "Compra exitosa"
        NotificationMailer.simple_notification(user, msg, sbj).deliver
        # return renderJson(:created, { notice: 'La Compra fue aprobada exitosamente' })
        return render json: @purchase, status: :created, include: ['person.document_type', 'country']
      end
    end
    return renderJson(:unprocessable, {error: 'La compra no se pudo aprobar'})
  end

  def deny
    if @purchase.may_deny?
      @purchase.deny!
      person = @purchase.person
      person.balance += @purchase.value
      user = person.user
      money = number_to_currency(@purchase.value, unit: @purchase.country.unit)
      msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu compra de #{@purchase.btc} bitcoins por valor #{money} de ha sido rechazada, hemos regresado tu saldo, lamentamos las molestias"
      sbj = "Compra fallida"
      NotificationMailer.simple_notification(user, msg, sbj).deliver
      return renderJson(:created, { notice: 'La compra fue rechazada exitosamente' }) if person.save
    end
    return renderJson(:unprocessable, {error: 'La compra no se pudo rechazar'})
  end
  
  # TODO: add evidence

  private

    def set_purchase
      return renderJson(:not_found) unless @purchase = Purchase.find_by_hashid(params[:id])
    end


    def purchase_params
      params.require(:purchase).permit(:value, :wallet_url, :evidence)
    end
end
  