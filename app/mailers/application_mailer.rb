class ApplicationMailer < ActionMailer::Base
  default from: 'info@bitcoinworldesp.es'
  layout 'mailer'

  @@logo_white = 'https://i.imgur.com/WQC2Vol.png'
  @@logo_black = 'https://i.imgur.com/McY7KbF.png'
  @@bitcoin_email = 'https://i.imgur.com/rxUFWx8.jpg'

  @@url = ENV['BASE_URL_DASHBOARD']

end
