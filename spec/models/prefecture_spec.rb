require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  it "nameが47都道府県の中のいずれかであれば有効な状態であること" do
    prefecture = Prefecture.new(name: "宮城県")
    expect(prefecture).to be_valid
  end

  it "nameが47都道府県の中のいずれでもなければ無効な状態であること" do
    prefecture = Prefecture.new(name: "仙台市")
    prefecture.valid?
    expect(prefecture.errors[:name]).to include("仙台市 は無効な値です")
  end

  it "nameが存在しなければ無効な状態であること" do
    prefecture = Prefecture.new(name: nil)
    prefecture.valid?
    expect(prefecture.errors[:name]).to include("can't be blank")
  end
end
