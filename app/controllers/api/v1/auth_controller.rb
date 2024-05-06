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
        current_user = fetch_current_user
        if current_user
          render json: { current_user: current_user }, stauts: :ok
        else
          render json: {}, status: 401
        end
      end
    end
  end
end
