class SalesController < ApplicationController

    include ActionView::Helpers::NumberHelper

    before_action :verify_token
    before_action :set_sale, only: [:show, :destroy, :approve, :deny]
    before_action :verify_user, only: [:show, :destroy]
    before_action :is_admin?, only: [:approve, :deny]

    def index
      sales = @user.is_person? ? @user.profile.sales.super_filter(params) : Sale.super_filter(params)
      return renderCollection("sales", sales, SaleSerializer, ['person.document_type', 'country', 'bank_account.document_type'])
    end

    def show
      return render json: @sale, status: :ok, include: ['person.document_type', 'country', 'bank_account.document_type']
    end

    def create
      return renderJson(:unauthorized) unless @user.profile_type == "Person"
      sale = Sale.new(sale_params)
      person = @user.profile
      sale.person = person
      sale.country = person.country
      sale.set_value
      if sale.valid?
        person.btc -= sale.btc
        return renderJson(:unprocessable, {error: 'No tienes los bitcoins suficientes para esta venta'}) unless person.save
      end
      if sale.save
        money = number_to_currency(sale.value, unit: sale.country.unit)
        btc = sale.btc
        msg = "El usuario #{@user.full_name} ha realizado una venta de Ƀ#{btc}"
        sbj = "Nueva venta de #{@user.full_name}"
        User.by_admins.each {|admin| NotificationMailer.simple_notification(admin, msg, sbj).deliver }
        msg = "Hola #{@user.full_name}, gracias por confiar en nosotros has realizado una venta de Ƀ#{btc} por valor de #{money}, procesaremos tu venta tan pronto como sea posible y si esta es exitosa recibiras el dinero en la cuenta bancaria seleccionada"
        sbj = "Nueva Compra"
        NotificationMailer.simple_notification(@user, msg, sbj).deliver
        return render json: sale, status: :created, include: ['person.document_type', 'country', 'bank_account.document_type']
      else
        return renderJson(:unprocessable, {error: sale.errors.messages})
      end
    end

    def approve
      if @sale.may_approve?
        bank_account = @sale.bank_account
        @sale.approve
        @sale.assign_attributes(sale_params)
        if @sale.save(context: :approve)
          user = @sale.person.user
          money = number_to_currency(@sale.value, unit: @sale.country.unit)
          msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu venta de Ƀ#{@sale.btc} por valor #{money} de ha sido aprobada exitosamente, revisa tu cuenta de #{bank_account.bank} numero #{bank_account.number} y valida que todo este en orden."
          sbj = "Compra exitosa"
          NotificationMailer.simple_notification(user, msg, sbj).deliver
          # return renderJson(:created, { notice: 'La Compra fue aprobada exitosamente' })
          return render json: @sale, status: :ok, include: ['person.document_type', 'country', 'bank_account.document_type']
        else
          puts @sale.errors.full_messages
        end
      end
      return renderJson(:unprocessable, {error: 'La venta no se pudo aprobar'})
    end

    def deny
      if @sale.may_deny?
        @sale.deny
        person = @sale.person
        person.btc += @sale.btc
        user = person.user
        money = number_to_currency(@sale.value, unit: @sale.country.unit)
        msg = "Hola #{user.full_name}, gracias por confiar en nosotros tu venta de #{@sale.btc} bitcoins por valor #{money} de ha sido rechazada, hemos regresado tu saldo, lamentamos las molestias"
        sbj = "Compra fallida"
        if person.valid? && @sale.valid?
            person.save
            @sale.save
            NotificationMailer.simple_notification(user, msg, sbj).deliver
            return renderJson(:created, { notice: 'La venta fue rechazada exitosamente' })
        end
      end
      return renderJson(:unprocessable, {error: 'La venta no se pudo rechazar'})
    end

    private

      def set_sale
        return renderJson(:not_found) unless @sale = Sale.find_by_hashid(params[:id])
      end

      def sale_params
        begin
          params.require(:sale).permit(:btc, :bank_account_id, :deposit_evidence)
        rescue
          {}
        end
      end

      def verify_user
        return renderJson(:unauthorized) if not ((@user.profile_type == "Person" && @user.profile_id == @sale.person_id) || (@user.is_admin?))
      end
  end
