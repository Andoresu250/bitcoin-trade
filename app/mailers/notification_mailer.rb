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
    
    def image_notification(user, msg, subject, img)
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        @user = user
        @msg = msg
        @img = img
        @subject = subject
        mail to: user.email, subject: subject
    end
    
end
