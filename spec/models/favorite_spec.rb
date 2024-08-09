require 'rails_helper'

RSpec.describe Favorite, type: :model do

  before do
    @user = User.create(
      nickname: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    )
    @prefecture = Prefecture.create(
      name: "宮城県"
    )
    @store = Store.create(
      name: "store",
      address: "store_address",
      prefecture_id: @prefecture.id
    )
  end

  it "user_id, store_idがあれば有効な状態であること" do
    favorite = Favorite.new(
      user_id: @user.id,
      store_id: @store.id
    )
    expect(favorite).to be_valid
  end

  it "user_idが存在しなければ無効な状態であること" do
    favorite = Favorite.new(
      user_id: nil
    )
    favorite.valid?
    expect(favorite.errors[:user_id]).to include("can't be blank")
  end

  it "store_idが存在しなければ無効な状態であること" do
    favorite = Favorite.new(
      store_id: nil
    )
    favorite.valid?
    expect(favorite.errors[:store_id]).to include("can't be blank")
  end

  it "ユーザーは同じ店舗を二重に登録できないこと" do
    Favorite.create(
      user_id: @user.id,
      store_id: @store.id
    )
    favorite = Favorite.new(
      user_id: @user.id,
      store_id: @store.id
    )
    expect(favorite).to_not be_valid
  end
end
