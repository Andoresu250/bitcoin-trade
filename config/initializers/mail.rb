ActionMailer::Base.smtp_settings = {    
    :user_name              => ENV['SENGRID_USERNAME'],
    :password               => ENV['SENGRID_PASSWORD'],
    :domain                 => 'http://muver.bitballoon.com/',    
    :address                => 'smtp.sendgrid.net',
    :port                   => 2525,
    :authentication         => :plain,
    :enable_starttls_auto   => true,
    :ssl                     =>false
  }

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default charset: "utf-8"