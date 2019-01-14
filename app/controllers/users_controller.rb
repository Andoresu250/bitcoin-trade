class UsersController < ApplicationController
  
  include ActionView::Helpers::NumberHelper

  before_action :verify_token, except: [:create_person]
  before_action :is_admin?, only: [:index, :create, :destroy]
  before_action :set_user, only: [:show, :update, :activate, :deactivate, :destroy]
  before_action :verify_user, only: [:show, :update, :destroy]

  def index
    users = User.filter(params)
    return renderCollection("users", users, MyUserSerializer)
  end
  
  def show    
    return render json: ActiveModelSerializers::SerializableResource.new(@this_user, each_serializer: MyUserSerializer), status: :ok
  end
  
  def create
    user = User.new(user_params)   
    case user.profile_type
    when "Person"
      profile = Person.new(person_params)
    else
      profile = nil
    end
    unless profile.nil?
      return renderJson(:unprocessable, {error: {profile: profile.errors.messages}}) unless profile.save
    end
    user.profile = profile
    if user.save
      return render json: ActiveModelSerializers::SerializableResource.new(user, each_serializer: MyUserSerializer), status: :created
    else
      profile.destroy unless profile.nil?
      return renderJson(:unprocessable, {error: user.errors.messages})
    end
  end
  
  def create_person
    user = User.new(user_params)   
    user.profile_type = "Person"
    profile = Person.new(person_params)
    profile.country = @time_zone_country unless profile.country_id.present?
    unless profile.nil?
      return renderJson(:unprocessable, {error: {profile: profile.errors.messages}}) unless profile.save
    end
    user.profile = profile
    user.deactivate
    if user.save
      WelcomeMailer.new_user(user).deliver
      return renderJson(:created, {notice: "Usuario creado exitosamente, te llegara una confirmacion cuando la cuenta sea validada"})
    else
      profile.destroy unless profile.nil?
      return renderJson(:unprocessable, {error: user.errors.messages})
    end
  end
  
  def update    
    @this_user.assign_attributes(user_params, {override: false})    
    profile = @this_user.profile
    case @this_user.profile_type
    when "Person"
      profile.assign_attributes(person_params, {override: false})
      return renderJson(:unprocessable, {error: {profile: profile.errors.messages}}) unless profile.save
    end
    if @this_user.save
      return render json: ActiveModelSerializers::SerializableResource.new(@this_user, each_serializer: MyUserSerializer), status: :ok
    else
      return renderJson(:unprocessable, {error: @this_user.errors.messages})
    end
  end
  
  def activate
    if @this_user.may_activate?
      @this_user.activate!
      WelcomeMailer.activate_user(@this_user).deliver
      renderJson(:created, { notice: 'La cuenta ha sido activada exitosamente.' })
    else
      renderJson(:unprocessable, {error: 'Esta cuenta ya esta activada.'})
    end
  end
  
  def deactivate
    if @this_user.may_deactivate?
      @this_user.deactivate!
      @this_user.tokens.delete
      WelcomeMailer.deactivate_user(@this_user).deliver
      renderJson(:created, { notice: 'La cuenta ha sido desactivada exitosamente.' })
    else
      renderJson(:unprocessable, {error: 'Esta cuenta ya esta desactivada.'})
    end
  end
  
  def destroy
    if @this_user.destroy
      WelcomeMailer.delete_user(@this_user).deliver
      return renderJson(:no_content)
    else
      return renderJson(:unprocessable, {error: "El usuario no pudo ser borrado"})
    end
  end
  
  def balance
    if @user.profile_type == "Person"
      money = number_to_currency(@user.profile.balance, precision: 2, unit: @user.profile.country.unit)
    else
      money = nil
    end
    return renderJson(:ok, {balance: money})
  end

  private

  def set_user
    return renderJson(:not_found) unless @this_user = User.find_by_hashid(params[:id])
  end

  def user_params        
    params.require(:user).permit(:email, :profile_type, :password, :password_confirmation)
  end
  
  def person_params
    begin
      params.require(:user).require(:profile).permit(:first_names, :last_names, :identification, :phone, :identification_front, :identification_back, :public_receipt, :country_id, :document_type_id)
    rescue
      {}
    end
  end

  def verify_user
    return renderJson(:unauthorized) if !@user.is_admin? && @this_user.id != @user.id
  end
end
