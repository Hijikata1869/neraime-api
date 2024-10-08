require 'rails_helper'

RSpec.describe Prefecture, type: :model do

  describe "バリデーションのテスト" do
    context "有効なバリデーション" do
      it "nameが47都道府県の中のいずれかであれば有効な状態であること" do
        expect(FactoryBot.build(:prefecture)).to be_valid
      end
    end

    context "無効なバリデーション" do
      it "nameが47都道府県の中のいずれでもなければ無効な状態であること" do
        prefecture = FactoryBot.build(:prefecture, name: "仙台市")
        prefecture.valid?
        expect(prefecture.errors[:name]).to include("仙台市 は無効な値です")
      end

      it "nameが存在しなければ無効な状態であること" do
        prefecture = FactoryBot.build(:prefecture, name: nil)
        prefecture.valid?
        expect(prefecture.errors[:name]).to include("can't be blank")
      end
    end
  end

end
