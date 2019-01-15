class SalesController < ApplicationController

  include ActionView::Helpers::NumberHelper

  before_action :verify_token
  before_action :set_sale, only: [:show, :destroy, :approve, :deny]
  before_action :verify_user, only: [:show, :delete]
  before_action :is_admin?, only: [:approve, :deny]

  def index
    sales = @user.is_person? ? @user.profile.sales.filter(params) : Sale.filter(params)
    return renderCollection("sales", sales, SaleSerializer)
  end
  
  def show
    return render json: @sale, status: :ok
  end

  def create
    return renderJson(:unauthorized) unless @user.profile_type == "Person"
    sale = Sale.new(sale_params)    
    person = @user.profile
    sale.person = person
    sale.country = person.country
    sale.set_btc
    if sale.valid?
      person.balance -= sale.value
      return renderJson(:unprocessable, {error: 'No tienes el saldo suficiente para esta compra'}) unless person.save
    end
    if sale.save
      money = number_to_currency(sale.value, unit: sale.country.unit)
      btc = sale.btc
      msg = "El usuario #{@user.full_name} ha realizado una compra por #{btc}"
      sbj = "Nueva compra de #{@user.full_name}"
      User.by_admins.each {|admin| NotificationMailer.simple_notification(admin, msg, sbj).deliver }
      msg = "Hola #{@user.full_name}, gracias por confiar en nosotros has una compra de #{btc} bitcoins por valor de #{money}, validaremos tu dinero tan pronto como sea posible, y si todo esta en orden aprobaremos tu compra y se te sera transferido la cantidad de btc aquirido a tu billetera"
      sbj = "Nueva Compra"
      NotificationMailer.simple_notification(@user, msg, sbj).deliver
      return render json: sale, status: :created
    else
      return renderJson(:unprocessable, {error: sale.errors.messages})
    end
  end

  def approve
    if @sale.may_approve?
      @sale.approve
      @sale.assign_attributes(sale_params)
      if @sale.save
        user = @sale.person.user      
        money = number_to_currency(@sale.value, unit: @sale.country.unit)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu compra de #{@sale.btc} bitcoins por valor #{money} de ha sido aprobada exitosamente, revisa tu billetera y valida que todo este en orden."
        sbj = "Compra exitosa"
        NotificationMailer.simple_notification(user, msg, sbj).deliver
        return renderJson(:created, { notice: 'La Compra fue aprobada exitosamente' })
      end
    end
    return renderJson(:unprocessable, {error: 'La compra no se pudo aprobar'})
  end

  def deny
    if @sale.may_deny?
      @sale.deny!
      person = @sale.person
      person.balance += @sale.value
      user = person.user
      money = number_to_currency(@sale.value, unit: @sale.country.unit)
      msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu compra de #{@sale.btc} bitcoins por valor #{money} de ha sido rechazada, hemos regresado tu saldo, lamentamos las molestias"
      sbj = "Compra fallida"
      NotificationMailer.simple_notification(user, msg, sbj).deliver
      return renderJson(:created, { notice: 'La compra fue rechazada exitosamente' }) if person.save
    end
    return renderJson(:unprocessable, {error: 'La compra no se pudo rechazar'})
  end
  
  # TODO: add evidence

  private

    def set_sale
      return renderJson(:not_found) unless @sale = Sale.find_by_hashid(params[:id])
    end


    def sale_params
      params.require(:sale).permit(:value, :wallet_url, :evidence)
    end
end
  