require 'rails_helper'

RSpec.describe Crowdedness, type: :model do

  before do
    @user = User.create(
      nickname: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
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

  it "user_id, store_id, day_of_week, time, levelが存在すれば有効な状態であること" do
    crowdedness = Crowdedness.new(
      user_id: @user.id,
      store_id: @store.id,
      day_of_week: "月曜日",
      time: "0:00",
      level: "空いてる"
    )
    expect(crowdedness).to be_valid
  end

  it "day_of_weekが存在しなければ無効な状態であること" do
    crowdedness = Crowdedness.new(day_of_week: nil)
    crowdedness.valid?
    expect(crowdedness.errors[:day_of_week]).to include("can't be blank")
  end

  it "timeが存在しなければ無効な状態であること" do
    crowdedness = Crowdedness.new(time: nil)
    crowdedness.valid?
    expect(crowdedness.errors[:time]).to include("can't be blank")
  end

  it "levelが存在しなければ無効な状態であること" do
    crowdedness = Crowdedness.new(time: nil)
    crowdedness.valid?
    expect(crowdedness.errors[:level]).to include("can't be blank")
  end

  it "day_of_weekは「月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日」のいずれかでなければ無効な状態であること" do
    crowdedness = Crowdedness.new(day_of_week: "月")
    crowdedness.valid?
    expect(crowdedness.errors[:day_of_week]).to include("月 は無効な値です")
  end

  it "timeは0:00 ~ 23:00のいずれかの値であること" do
    crowdedness = Crowdedness.new(time: "24:00")
    crowdedness.valid?
    expect(crowdedness.errors[:time]).to include("24:00 は無効な値です")
  end

  it "levelは「空いてる 普通 混雑 空き無し」のいずれかの値であること" do
    crowdedness = Crowdedness.new(level: "激混み")
    crowdedness.valid?
    expect(crowdedness.errors[:level]).to include("激混みは無効な値です")
  end

  it "memoは300文字以内なら有効な状態であること" do
    @memo = "a" * 300
    crowdedness = Crowdedness.new(memo: @memo)
    crowdedness.valid?
    expect(crowdedness.errors[:memo]).to_not include("is too long (maximum is 300 characters)")
  end

  it "memoは301文字以上であれば無効な状態であること" do
    @memo = "a" * 301
    crowdedness = Crowdedness.new(memo: @memo)
    crowdedness.valid?
    expect(crowdedness.errors[:memo]).to include("is too long (maximum is 300 characters)")
  end

end
