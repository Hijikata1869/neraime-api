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
        if logged_in?
          current_user = fetch_current_user
        end
        formatted_latest_crowdedness = latest_crowdedness.map do |crowdedness|
          profile_image_url = crowdedness.user.profile_image.present? ? url_for(crowdedness.user.profile_image) : ""
          number_of_usefuls = crowdedness.count_usefuls
          is_useful = current_user ? crowdedness.is_useful_by?(current_user) : false
          crowdedness.attributes.merge('nickname' => crowdedness.user.nickname, 'store_name' => crowdedness.store.name, 'url' =>profile_image_url, 'number_of_usefuls' => number_of_usefuls, 'is_useful' => is_useful)
        end
        if formatted_latest_crowdedness
          render json: { latest_crowdedness: formatted_latest_crowdedness }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def formatted_all_crowdedness_list
        all_crowdedness = Crowdedness.includes(:user, :store).order(created_at: :desc)
        if logged_in?
          current_user = fetch_current_user
        end
        formatted_all_crowdedness = all_crowdedness.map do |crowdedness|
          is_useful = current_user ? crowdedness.is_useful_by?(current_user) : false
          profile_image_url = crowdedness.user.profile_image.present? ? url_for(crowdedness.user.profile_image) : ""
          crowdedness.attributes.merge('store_name' => crowdedness.store.name, 'nickname' => crowdedness.user.nickname, 'url' => profile_image_url, 'number_of_usefuls' => crowdedness.count_usefuls, 'is_useful' => is_useful)
        end
        if formatted_all_crowdedness
          render json: { all_crowdedness: formatted_all_crowdedness }, status: :ok
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
