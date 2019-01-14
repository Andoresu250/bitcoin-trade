class ApplicationController < ActionController::Base
    
    include ActionController::Serialization
    protect_from_forgery with: :null_session
    around_action :with_time_zone
    
    def renderJson(type, opts = {})
        case type
        when :created
            render json: camelize(opts), root: false, status: type
        when :unprocessable
            render json: camelize(opts), status: :unprocessable_entity
        when :no_content
            head type
        when :unauthorized
            if opts[:error].nil?
                opts[:error] = "Acceso Denegado"
            end
            render json: camelize(opts), status: type
        when :not_found
            if opts[:error].nil?
                opts[:error] = "No se encontró"
            end
            render json: camelize(opts), status: type
        else
            render json: camelize(opts), status: type
        end
    end
    
    def renderCollection(root, collection, serializer)
        json = {}
        json[root.to_s.camelize(:lower)] = ActiveModelSerializers::SerializableResource.new(collection, each_serializer: serializer)
        json["totalCount"] = collection.count
        render json: json, status: :ok
    end
    
    def with_time_zone
        locale = params[:locale] || I18n.locale
        @time_zone_country = Country.by_locale(locale)
        @default_country = @time_zone_country
        Time.use_zone(@time_zone_country.time_zone) { yield }
    end
    
    def camelize(hash)
        hash.keys.each do |k|
            if hash[k].is_a? Hash
                camelize(hash[k])
            else
                hash[k.to_s.camelize(:lower)] = hash.delete(k)
            end
        end
        return hash
    end
    
    def verify_token
        if my_current_user
            return @user
        else
            return renderJson(:unauthorized)
        end
    end
    
    def my_current_user
        if request.headers.key?(:Authorization)
            @token = Token.find_by(token: request.headers['Authorization'])
            if @token.nil?
                return nil
            elsif not @token.is_valid?
                return nil
            else
                return @user = @token.user
            end
        else
            return nil
        end
    end
    
    def is_admin?
        @user.is_admin? ? @user : renderJson(:unauthorized)
    end
    
    def is_investor?
        @user.is_investor? ? @user : renderJson(:unauthorized)
    end
    
    def is_person?
        @user.is_person? ? @user : renderJson(:unauthorized)
    end
    
end
