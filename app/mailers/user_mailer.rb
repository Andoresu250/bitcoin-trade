class UserMailer < ApplicationMailer

  def reset_password_email(user)
    @user, @url = user, "#{@@url}/recover/#{user.reset_password_token}"
    mail to: user.email, subject: "Restaurar contraseña"
  end

end
