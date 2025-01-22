require 'rails_helper'

RSpec.describe Useful, type: :model do

  describe "バリデーションのテスト" do

    context "有効なバリデーション" do
      it "user_id, crowdedness_idがあれば有効な状態であること" do
        useful = FactoryBot.create(:useful)
        expect(useful).to be_valid
      end
    end

    context "無効なバリデーション" do
      it "user_idが存在しなければ無効な状態であること" do
        useful = FactoryBot.build(:useful, user_id: nil)
        useful.valid?
        expect(useful.errors[:user_id]).to include("can't be blank")
      end

      it "crowdedness_idが存在しなければ無効な状態であること" do
        useful = FactoryBot.build(:useful, crowdedness_id: nil)
        useful.valid?
        expect(useful.errors[:crowdedness_id]).to include("can't be blank")
      end

      it "ユーザーは同じ投稿に二重にusefulを登録できないこと" do
        useful = FactoryBot.create(:useful)
        second_useful = FactoryBot.build(:useful, user_id: useful.user_id, crowdedness_id: useful.crowdedness_id)
        expect(second_useful).to_not be_valid
      end
    end
  end
end
