require 'rails_helper'

RSpec.describe "UsersApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
  end

  describe "登録情報の更新" do
    context "ログイン中のユーザー" do
      it "ログイン中のユーザーは自分の登録情報を更新できること" do
        token = generate_token(@user.id)
        patch "/api/v1/users/#{@user.id}",
        params: {
          nickname: "updated_nickname",
          email: "updatedemail@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
          Authorization: token
        }
        expect(response).to have_http_status(:success)
      end

      it "ログイン中のユーザーは自分のアカウントを削除できること" do
        token = generate_token(@user.id)
        delete "/api/v1/users/#{@user.id}",
        params: {
          nickname: "updated_nickname",
          email: "updatedemail@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
          Authorization: token
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログインユーザー" do
      it "ログインしていなければ自分の登録情報を更新できないこと" do
        patch "/api/v1/users/#{@user.id}",
        params: {
          nickname: "updated_nickname",
          email: "updatedemail@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end

      it "ログインしていなければ自分のアカウントを削除できないこと" do
        delete "/api/v1/users/#{@user.id}",
        params: {
          nickname: "updated_nickname",
          email: "updatedemail@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
        }
        expect(response).to_not have_http_status(:success)
      end
    end

    context "ゲストユーザー" do
      before do
        @guest_user = User.create(nickname: "guest", email: "guest@example.com", password: "guest_password", password_confirmation: "guest_password")
      end

      it "ゲストユーザーの情報は更新できないこと" do
        token = generate_token(@guest_user.id)
        patch "/api/v1/users/#{@guest_user.id}",
        params: {
          nickname: "guest_updated",
          email: "guest_updated@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
          Authorization: token
        }
        expect(response).to_not have_http_status(:success)
      end

      it "ゲストユーザーは削除できないこt" do
        token = generate_token(@guest_user.id)
        delete "/api/v1/users/#{@guest_user.id}",
        params: {
          nickname: "guest",
          email: "guest@example.com"
        }.to_json,
        headers: {
          "Content-Type": "application/json",
          Authorization: token
        }
        expect(response).to_not have_http_status(:success)
      end

    end

  end
end
