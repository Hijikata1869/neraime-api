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
    end
  end
end