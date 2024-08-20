require 'rails_helper'

RSpec.describe "StoresApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @prefecture = FactoryBot.create(:prefecture)
  end

  describe "店舗の新規登録" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーであれば店舗を新規登録できること" do
        token = generate_token(@user.id)
        post "/api/v1/stores",
        params: {
          store: {
            name: "store",
            address: "store_address",
            prefecture: @prefecture.name
          }
        }.to_json,
        headers: {
          "Content-Type": "application/json",
          Authorization: token,
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインしていないユーザーは店舗を新規登録できないこと" do
        post "/api/v1/stores",
        params: {
          store: {
            name: "store",
            address: "store_address",
            prefecture: @prefecture.name
          }
        }.to_json,
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end
    end
  end
end
