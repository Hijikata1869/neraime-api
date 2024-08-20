require 'rails_helper'

RSpec.describe "FavoritesApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @store = FactoryBot.create(:store)
  end

  describe "お気に入りの作成" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーであれば、店舗をお気に入り登録できること" do
        token = generate_token(@user.id)
        post "/api/v1/stores/#{@store.id}/favorites",
        headers: {
          "Content-Type": "application/json",
          Authorization: token,
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインしていなければ店舗をお気に入り登録できないこと" do
        post "/api/v1/stores/#{@store.id}/favorites",
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end
    end
  end

  describe "お気に入りの解除" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーは店舗のお気に入り登録を解除できること" do
        FactoryBot.create(:favorite, user_id: @user.id, store_id: @store.id)
        token = generate_token(@user.id)
        delete "/api/v1/stores/#{@store.id}/favorites",
        headers: {
          "Content-Type": "application/json",
          Authorization: token
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインをしていなければお気に入り登録を解除できないこと" do
        FactoryBot.create(:favorite, user_id: @user.id, store_id: @store.id)
        delete "/api/v1/stores/#{@store.id}/favorites",
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end
    end
  end

end
