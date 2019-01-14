class NotificationMailer < ApplicationMailer
    
    def simple_notification(user, msg, subject)
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        @user = user
        @msg = msg
        @subject = subject
        mail to: user.email, subject: subject
    end
    
end
