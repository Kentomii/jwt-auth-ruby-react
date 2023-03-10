class AuthenticationController < ApplicationController

    skip_before_action :auth_req, only: [:login, :register, :getuser]

    #POST /auth/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { token: token }, status: :ok
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    #POST /auth/register
    def register
        @user = User.new(user_params)
        if @user.save
            token = jwt_encode(user_id: @user.id)
            render json: { user: @user, token: token }, status: :ok
        else 
            render json: @user.errors, status: :unprocessable_entity
        end 
    end

    #GET /auth/user
    def getuser
        header = request.headers['Authorization']
        header = header.split(" ").last if header
        decoded = jwt_decode(header)
        if decoded == 1
            render json: { error: "Invalid Token" }, status: :unauthorized
        else
            @user = User.find(decoded[:user_id])
            render json: @user
        end
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password)
        end

end
