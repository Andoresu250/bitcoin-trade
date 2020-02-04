class WelcomeMailer < ApplicationMailer

    default from: " info@bitcoinworldesp.es"

    def new_user(user)
        @person = user.profile
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        mail to: user.email, subject: 'Bienvenido a Bitcoin World'
    end

    def activate_user(user)
        @person = user.profile
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        @url = "#{@@url}/login"
        mail to: user.email, subject: 'Cuenta de Bitcoin World'
    end

    def deactivate_user(user)
        @person = user.profile
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        mail to: user.email, subject: 'Cuenta de Bitcoin World'
    end

    def delete_user(user)
        @person = user.profile
        @logo_white = @@logo_white
        @logo_black = @@logo_black
        @bitcoin_email = @@bitcoin_email
        mail to: user.email, subject: 'Cuenta de Bitcoin World'
    end

end
