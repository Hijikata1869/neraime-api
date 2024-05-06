module Api
  module V1
    class AuthController < ApplicationController
      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = create_token(user.id)
          render json: { token: token }, status: :ok
        else
          render json: {}, status: 400
        end
      end

      def current_user
        token = request.headers['Authorization']
        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
          current_user = User.find(decoded_token[0]['user_id'])
          render json: { current_user: current_user }, stauts: :ok
        rescue
          render json: {}, status: 401
        end
      end
    end
  end
end