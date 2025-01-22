require 'rails_helper'

RSpec.describe "UsefulsApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @crowdedness = FactoryBot.create(:crowdedness)
  end

  describe "usefulの作成" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーであれば、usefulを作成できること" do
        token = generate_token(@user.id)
        post "/api/v1/crowdednesses/#{@crowdedness.id}/usefuls",
        headers: {
          "Content-Type": "application/json",
          Authorization: token,
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインしていなければ、usefulを作成できないこと" do
        post "/api/v1/crowdednesses/#{@crowdedness.id}/usefuls",
          headers: {
            "Content-Type": "application/json",
          }
          expect(response).to_not have_http_status(:success)
      end
    end
  end

  describe "usefulの削除" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーは自分のusefulを削除できること" do
        FactoryBot.create(:useful, user_id: @user.id, crowdedness_id: @crowdedness.id)
        token = generate_token(@user.id)
        delete "/api/v1/crowdednesses/#{@crowdedness.id}/usefuls",
        headers: {
          "Content-Type": "application/json",
          Authorization: token,
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインしていなければusefulを削除できないこと" do
        FactoryBot.create(:useful, crowdedness_id: @crowdedness.id)
        delete "/api/v1/crowdednesses/#{@crowdedness.id}/usefuls",
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end
    end
  end

end
