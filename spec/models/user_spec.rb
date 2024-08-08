require 'rails_helper'

RSpec.describe User, type: :model do
  it "nickname, email, password, password_confirmationがあれば有効な状態であること" do
    user = User.new(
      nickname: "user1",
      email: "user1@example.com",
      password: "password1",
      password_confirmation: "password1",
    )
    expect(user).to be_valid
  end

  it "nicknameが存在しなければ無効な状態であること" do
    user = User.new(nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include("can't be blank")
  end

  it "emailが存在しなければ無効な状態であること" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "passwordがなければ無効な状態であること" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "nicknameは30文字以内であれば有効な状態であること" do
    nickname = "a" * 30
    user = User.new(nickname: nickname)
    user.valid?
    expect(user.errors[:password]).to_not include("is too long (maximum is 30 characters)")
  end

  it "nicknameは31文字以上だと無効な状態であること" do
    nickname = "a" * 31
    user = User.new(nickname: nickname)
    user.valid?
    expect(user.errors[:nickname]).to include("is too long (maximum is 30 characters)")
  end

  it "self_introductionは200文字以内であれば有効な状態であること" do
    introduction = "a" * 200
    user = User.new(self_introduction: introduction)
    user.valid?
    expect(user.errors[:self_introduction]).to_not include("is too long (maximum is 200 characters)")
  end

  it "self_introductionは201文字以上だと向こうであること" do
    introduction = "a" * 201
    user = User.new(self_introduction: introduction)
    user.valid?
    expect(user.errors[:self_introduction]).to include("is too long (maximum is 200 characters)")
  end

  it "emailの重複は無効な状態であること" do
    User.create(
      nickname: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
    )
    user = User.new(
      nickname: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

end
