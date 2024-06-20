module Api
  module V1
    class StoresController < ApplicationController
      before_action :convert_prefecture_name_to_id, only: [:create, :update]

      def index
        stores = Store.all
        updated_stores = convert_prefecture_id_to_name(stores)
        render json: { stores: updated_stores }, status: :ok
      end

      def create
        store = Store.new(store_create_params)
        if store.save
          render json: {}, stauts: :ok
        else
          render json: {}, status: 422
        end
      end

      def show
        store = Store.find(params[:id])
        if store.present?
          render json: { store: store }, stauts: :ok
        else
          render json: {}, stauts: 404
        end
      end

      def update
        store = Store.find(params[:id])
        if store.update(store_update_params)
          render json: {}, status: :ok
        else
          render json: {}, status: 422
        end
      end

      def destroy
        store = Store.find(params[:id])
        if store.destroy
          render json: {}, status: :ok
        else
          render json: {}, stauts: 500
        end
      end

      def crowdedness_list
        store = Store.find(params[:id])
        store_crowdedness_list = store.crowdednesses.to_a
        if store_crowdedness_list.present?
          render json: { store_crowdedness_list: store_crowdedness_list }, status: :ok
        else
          render json: {}, status: 404
        end
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
        store_crowdedness_with_memo = Crowdedness.where(store_id: params[:id]).where.not(memo: "")
        result = store_crowdedness_with_memo.map do |crowdedness|
          {
            id: crowdedness.id,
            user_id: crowdedness.user_id,
            nickname: crowdedness.user.nickname,
            store_id: crowdedness.store_id,
            day_of_week: crowdedness.day_of_week,
            time: crowdedness.time,
            level: crowdedness.level,
            memo: crowdedness.memo,
            created_at: crowdedness.created_at,
            updated_at: crowdedness.updated_at
          }
        end
          if result.present?
            render json: {latest_store_reviews: result}, status: :ok
          else
            render json: {}, status: 404
          end
      end

      def show_by_name
        store = Store.find_by(name: params[:name])
        if store.present?
          render json: { store: store }, status: :ok
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

    end
  end
end
