module Api
  module V1
    class CrowdednessesController < ApplicationController
      before_action :authenticate_user, only: [:create, :destroy]

      def create
        crowdedness = Crowdedness.new(crowdedness_create_params)
        if crowdedness.save
          render json: {}, status: :ok
        else
          render json: {}, stauts: 422
        end
      end

      def destroy
        crowdedness = Crowdedness.find(params[:id])
        if crowdedness.destroy
          render json: {}, status: :ok
        else
          render json: {}, status: 500
        end
      end

      private
      def crowdedness_create_params
        params.require(:crowdedness).permit(:user_id, :store_id, :day_of_week, :time, :level, :memo)
      end

    end
  end
end
