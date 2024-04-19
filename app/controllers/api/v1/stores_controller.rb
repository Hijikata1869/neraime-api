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
        updated_store = store.convert_prefecture_id_to_name
        if updated_store.present?
          render json: { store: updated_store }, stauts: :ok
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