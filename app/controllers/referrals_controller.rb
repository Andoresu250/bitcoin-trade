class ReferralsController < ApplicationController

  before_action :verify_token
  before_action :is_admin?, only: [:commissions]

  def index
    params[:by_referred_user_id] = @user.id if @user.is_person?
    users = User.with_referred_user.filter(params)
    renderCollection("users", users, MyUserSerializer)
  end

  def commissions
    result =  Person.group(:country).sum(:bonus)
    result = result.map { |r| {country: r[0], commission: r[1]} }
    render json: result
  end

end
