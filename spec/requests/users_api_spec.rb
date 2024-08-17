require 'rails_helper'

RSpec.describe "UsersApis", type: :request do

  before do
    @user = FactoryBot.create(:user)
  end

  it "ログイン中のユーザーであれば登録情報を更新できること" do
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
