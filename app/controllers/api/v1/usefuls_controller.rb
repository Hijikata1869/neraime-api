module Api
  module V1
    class UsefulsController < ApplicationController
      before_action :authenticate_user, only: [:create, :destroy]

      def create
        current_user = fetch_current_user
        useful = current_user.usefuls.build(crowdedness_id: params[:crowdedness_id])
        if useful.save
          render json: {}, status: :ok
        else
          render json: { message: useful.errors.full_messages.join(", ") }, status: 422
        end
      end

      def destroy

      end
    end
  end
end
