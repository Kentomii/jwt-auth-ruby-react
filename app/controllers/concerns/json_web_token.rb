require "jwt"

module JsonWebToken
    
    extend ActiveSupport::Concern

    SECRET_KEY = Rails.application.secrets.secret_key_base
    SECRET_FRESH_KEY = Rails.application.secrets.secret_key_base + "refresh"

    def jwt_encode(payload, exp = 7.days.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    rescue
        1
    end
end