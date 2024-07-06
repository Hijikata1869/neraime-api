module Api
  module V1
    class CrowdednessesController < ApplicationController
      before_action :authenticate_user, only: [:create, :destroy]

      def create
        crowdedness = Crowdedness.new(crowdedness_create_params)
        if crowdedness.save
          render json: {}, status: :ok
        else
          render json: {}, status: 422
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

      def formatted_latest_crowdednesses_list
        latest_crowdedness = Crowdedness.includes(:user, :store).order(created_at: :desc).limit(3)
        formatted_latest_crowdedness = latest_crowdedness.map do |crowdedness|
          crowdedness.attributes.merge('nickname' => crowdedness.user.nickname, 'store_name' => crowdedness.store.name)
        end
        if formatted_latest_crowdedness
          render json: { latest_crowdedness: formatted_latest_crowdedness }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      private
      def crowdedness_create_params
        params.require(:crowdedness).permit(:user_id, :store_id, :day_of_week, :time, :level, :memo)
      end

    end
  end
end
