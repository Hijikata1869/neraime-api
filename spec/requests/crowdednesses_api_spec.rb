require 'rails_helper'

RSpec.describe "CrowdednessesApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @store = FactoryBot.create(:store)
  end

  describe "混雑度の新規作成" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーであれば混雑度を投稿できること" do
        token = generate_token(@user.id)
        post  "/api/v1/crowdednesses",
        params: {
          crowdedness: {
            user_id: @user.id,
            store_id: @store.id,
            day_of_week: "月曜日",
            time: "0:00",
            level: "空いてる",
            memo: "今日は空いてました",
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
      it "ログインしていなければ混雑度を投稿できないこと" do
        post  "/api/v1/crowdednesses",
        params: {
          crowdedness: {
            user_id: @user.id,
            store_id: @store.id,
            day_of_week: "月曜日",
            time: "0:00",
            level: "空いてる",
            memo: "今日は空いてました",
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
