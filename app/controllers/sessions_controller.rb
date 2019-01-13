class SessionsController < ApplicationController
    
    before_action :verify_token, only: [:destroy, :check]
    
    def create
        email = session_params[:email]
        pass = session_params[:password]
        user = login(email, pass)
        if user
            return renderJson(:unauthorized, {error: "Su cuenta esta desactivada"}) unless user.activated?
            token = Token.create(user: user)
            user.token = token.token
            return render json: ActiveModelSerializers::SerializableResource.new(user, each_serializer: SessionSerializer), status: :created
        else
            return renderJson(:unauthorized, {error: "Credenciales incorrectas"})
        end
    end
    
    def check
        @user.token = @token.token
        return render json: ActiveModelSerializers::SerializableResource.new(@user, each_serializer: SessionSerializer), status: :ok
    end
    
    def destroy
        @token.destroy
        renderJson(:no_content)
    end
    
    private
    
    def session_params
        params.require(:user).permit(:email, :password)
    end
    
end
