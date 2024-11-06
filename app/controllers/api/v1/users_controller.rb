module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user, only: [:update, :destroy, :image_upload]

      def create
        user = User.new(user_create_params)
        if user.save
          token = create_token(user.id)
          render json: { token: token }, status: :ok
        else
          render json: {}, status: 422
        end
      end

      def show
        user = User.find(params[:id])
        if user.present?
          profile_image_url = user.profile_image.present? ? url_for(user.profile_image) : ""
          user_with_profile_image = user.attributes.merge('url' => profile_image_url)
          render json: { user: user_with_profile_image }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def update
        user = User.find(params[:id])
        current_user = fetch_current_user

        if user.id == current_user.id && user.update(user_update_params)
          render json: {}, status: :ok
        else
          render json: { message: user.errors.full_messages.join(", ") }, status: 422
        end
      end

      def destroy
        user = User.find(params[:id])
        current_user = fetch_current_user
        if user.id == current_user.id && user.destroy
          render json: {}, status: :ok
        else
          render json: { message: user.errors.full_messages.join(", ") }, status: 500
        end
      end

      def crowdedness_list
        user = User.find(params[:id])
        user_crowdednesses = user.crowdednesses.to_a
        if user_crowdednesses.present?
          render json: { user_crowdedness: user_crowdednesses }, status: :ok
        else
          render json: {}, staus: 404
        end
      end

      def formatted_crowdedness_list
        user_crowdedness = Crowdedness.includes(:store).where(user_id: params[:id]).order(created_at: :desc)
        formatted_user_crowdedness = user_crowdedness.map do |crowdedness|
          crowdedness.attributes.merge('store_name' => crowdedness.store.name)
        end
        if formatted_user_crowdedness
          render json: { user_crowdedness: formatted_user_crowdedness }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def favorite_stores
        user = User.find(params[:id])
        favorite_stores = user.favorite_stores
        if favorite_stores
          render json: { favorite_stores: favorite_stores }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def image_upload
        user = User.find(params[:id])
        user.profile_image.attach(params[:profile_image])
        if user.save
          url = url_for(user.profile_image)
          render json: { url: url }, status: :ok
        else
          render json: { message: user.errors.full_messages.join(", ")}, status: 422
        end
      end

      private
      def user_create_params
        params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
      end

      def user_update_params
        params.require(:user).permit(:nickname, :email, :self_introduction)
      end

    end
  end
end
