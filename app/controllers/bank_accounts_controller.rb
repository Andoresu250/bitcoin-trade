class BankAccountsController < ApplicationController
  
  before_action :verify_token, only: [:create, :update, :destroy]
  before_action :set_bank_account, only: [:show, :update, :destroy]
  before_action :verify_user, only: [:show, :update, :delete]

  def index
    bank_accounts = @user.is_person? ? @user.profile.bank_accounts.filter(params) : BankAccount.filter(params)
    return renderCollection("bank_accounts", bank_accounts, BankAccountSerializer)
  end
  
  def show
    return render json: @bank_account, status: :ok
  end
  
  def create
    return renderJson(:unauthorized) unless @user.profile_type == "Person"
    bank_account = BankAccount.new(bank_account_params)
    bank_account.person = @user.profile
    if bank_account.save
      return render json: bank_account, status: :created
    else
      return renderJson(:unprocessable, {error: bank_account.errors.messages})
    end
  end
  
  def update
    @bank_account.assign_attributes(bank_account_params)
    if @bank_account.save
      return render json: @bank_account, status: :ok
    else
      return renderJson(:unprocessable, {error: @bank_account.errors.messages})
    end
  end
  
  def destroy
    @bank_account.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_bank_account
      return renderJson(:not_found) unless @bank_account = BankAccount.find_by_hashid(params[:id])
    end
    
    def bank_account_params
      params.require(:bank_account).permit(:bank, :number, :identification, :document_type_id, :identification_front, :identification_back, :account_certificate, :person_id)
    end
    
    def verify_user
      return renderJson(:unauthorized) if not ((@user.profile_type == "Person" && @user.profile_id == @bank_account.person_id) || (@user.is_admin?))
    end
end
