module Api
  module V1
    class FavoritesController < ApplicationController
      before_action :authenticate_user, only: [:create, :destroy, :current_user_favorite_stores]
      def create
        current_user = fetch_current_user
        favorite = current_user.favorites.build(store_id: params[:store_id])
        if favorite.save
          recent_favorite_stoers = current_user.favorite_stores
          render json: { favorite_stores: recent_favorite_stoers }, status: :ok
        else
          render json: {}, status: 422
        end
      end

      def destroy
        current_user = fetch_current_user
        favorite = Favorite.find_by(user_id: current_user.id, store_id: params[:store_id])
        if favorite.destroy
          recent_favorite_stoers = current_user.favorite_stores
          render json: { favorite_stores: recent_favorite_stoers }, status: :ok
        else
          render json: {}, status: 500
        end
      end

      def current_user_favorite_stores
        current_user = fetch_current_user
        favorite_stores = current_user.favorite_stores
        if favorite_stores
          render json: { favorite_stores: favorite_stores }, stauts: :ok
        else
          render json: {}, status: 404
        end
      end
    end
  end
end
