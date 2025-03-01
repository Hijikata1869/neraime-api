module Api
  module V1
    class StoresController < ApplicationController
      before_action :authenticate_user, only: [:create]
      before_action :convert_prefecture_name_to_id, only: [:create, :update]
      before_action :change_prefecture_name_to_id, only: [:show_by_prefecture_name]
      before_action :find_store, only: [:show, :update, :destroy, :crowdedness_list]

      def index
        stores = Store.all
        updated_stores = convert_prefecture_id_to_name(stores)
        render json: { stores: updated_stores }, status: :ok
      end

      def create
        store = Store.new(store_create_params)
        if store.save
          render json: { store: store }, status: :ok
        else
          render json: {}, status: 422
        end
      end

      def show
        render json: { store: @store }, status: :ok
      end

      def update
        if @store.update(store_update_params)
          render json: {}, status: :ok
        else
          render json: { error: @store.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @store.destroy
          render json: {}, status: :ok
        else
          render json: { error: "削除できませんでした" }, status: 500
        end
      end

      def crowdedness_list
        store_crowdedness_list = @store.crowdednesses.to_a
        render json: { store_crowdedness_list: store_crowdedness_list }, status: :ok
      end

      def dayly_crowdedness_list
        dayly_store_crowdednesses = Crowdedness.where(store_id: params[:id], day_of_week: params[:day_of_week])
        counted_dayly_store_crowdedness = dayly_store_crowdednesses.group(:time, :level).count

        result = Hash.new { |hash, key| hash[key] = {"空いてる" => 0, "普通" => 0, "混雑" => 0, "空き無し" => 0} }
        counted_dayly_store_crowdedness.each do |key, value|
          time, level = key
          result[time][level] = value
        end
        result = result.map { |time, levels| levels.merge("time" => time) }

        if result.present?
          render json: { dayly_store_crowdedness_list: result}, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def latest_store_reviews
        store_crowdedness_with_memo = Crowdedness.where(store_id: params[:id]).where.not(memo: "").includes(:user).order(created_at: :desc).limit(3)
        result = format_crowdedness(store_crowdedness_with_memo)
          if result.present?
            render json: {latest_store_reviews: result}, status: :ok
          else
            render json: {}, status: 404
          end
      end

      def all_store_reviews
        store_crowdedness_with_memo = Crowdedness.where(store_id: params[:id]).where.not(memo: "").includes(:user).order(created_at: :desc)
        result = format_crowdedness(store_crowdedness_with_memo)
        if result.present?
          render json: { store_reviews: result }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def show_by_name
        store = Store.find_by(name: params[:name])
        if store
          render json: { store: store }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def show_by_address
        store = Store.find_by(address: params[:address])
        if store
          render json: { store: store }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      def show_by_prefecture_name
        stores = Store.where(prefecture_id: params[:prefecture_id]);
        if stores.any?
          render json: { stores: stores }, status: :ok
        else
          render json: {}, status: 404
        end
      end

      private
      def store_create_params
        params.require(:store).permit(:name, :address, :prefecture_id)
      end

      def store_update_params
        params.require(:store).permit(:name, :address, :prefecture_id)
      end

      def convert_prefecture_name_to_id
        prefecture_name = params[:store][:prefecture]
        prefecture = Prefecture.find_by(name: prefecture_name)
        if prefecture
          params[:store][:prefecture_id] = prefecture.id
        else
          render json: {}, status: 422
        end
      end

      def change_prefecture_name_to_id
        prefecture_name = params[:prefecture]
        prefecture = Prefecture.find_by(name: prefecture_name)
        if prefecture
          params[:prefecture_id] = prefecture.id
        else
          render json: {}, status: 422
        end
      end

      def convert_prefecture_id_to_name(stores)
        stores.map do |store|
          prefecture_id = store.prefecture_id
          prefecture = Prefecture.find(prefecture_id)
          {
            id: store.id,
            name: store.name,
            address: store.address,
            prefecture: prefecture.name,
            created_at: store.created_at,
            updated_at: store.updated_at
          }
        end
      end

      def find_store
        @store = Store.find_by(id: params[:id])
        render json: { error: "店舗が見つかりませんでした" }, status: :not_found unless @store
      end

      def format_crowdedness(crowdednesses)
        if logged_in?
          current_user = fetch_current_user
        end
        crowdednesses.map do |crowdedness|
          profile_image_url = crowdedness.user.profile_image.present? ? url_for(crowdedness.user.profile_image) : ""
          is_useful = current_user ? crowdedness.is_useful_by?(current_user) : false
          crowdedness.as_json.merge(nickname: crowdedness.user.nickname, url: profile_image_url, number_of_usefuls: crowdedness.count_usefuls, is_useful: is_useful)
        end
      end

    end
  end
end
