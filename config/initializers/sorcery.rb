# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external
Rails.application.config.sorcery.submodules = [:reset_password]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  
  # --- user config ---
  config.user_config do |user|    
    
    user.username_attribute_names = [:email]

    user.downcase_username_before_authenticating = true    

    user.reset_password_expiration_period = 5 * 60
    
    user.reset_password_mailer = UserMailer

  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = 'User'
end
