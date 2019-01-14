class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  
  @@logo_white = 'http://i.imgur.com/LwOI4G9.png'
  @@logo_black = 'http://i.imgur.com/YNJFdYsg.png'
  @@bitcoin_email = 'http://i.imgur.com/5yL4ASLg.jpg'
  
  @@url = 'https://bitcoinworldesp.es'
end
