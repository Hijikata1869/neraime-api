module Api
  module V1
    class FavoritesController < ApplicationController
      before_action :authenticate_user, only: [:create, :destroy]
      def create
        current_user = fetch_current_user
        favorite = current_user.favorites.build(store_id: params[:store_id])
        if favorite.save
          render json: {}, status: :ok
        else
          render json: {}, status: 422
        end
      end

      def destroy
        current_user = fetch_current_user
        favorite = Favorite.find_by(user_id: current_user.id, store_id: params[:store_id])
        if favorite.destroy
          render json: {}, status: :ok
        else
          render json: {}, status: 500
        end
      end
    end
  end
end
