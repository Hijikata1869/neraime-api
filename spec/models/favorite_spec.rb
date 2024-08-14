require 'rails_helper'

RSpec.describe Favorite, type: :model do

  describe "バリデーションのテスト" do
    context "有効なバリデーション" do
      it "user_id, store_idがあれば有効な状態であること" do
        favorite = FactoryBot.create(:favorite)
        expect(favorite).to be_valid
      end
    end

    context "無効なバリデーション" do
      it "user_idが存在しなければ無効な状態であること" do
        favorite = FactoryBot.build(:favorite, user_id: nil)
        favorite.valid?
        expect(favorite.errors[:user_id]).to include("can't be blank")
      end

      it "store_idが存在しなければ無効な状態であること" do
        favorite = FactoryBot.build(:favorite, store_id: nil)
        favorite.valid?
        expect(favorite.errors[:store_id]).to include("can't be blank")
      end

      it "ユーザーは同じ店舗を二重に登録できないこと" do
        favorite = FactoryBot.create(:favorite)
        second_favorite = FactoryBot.build(:favorite, user_id: favorite.user_id, store_id: favorite.store_id)
        expect(second_favorite).to_not be_valid
      end
    end
  end

end
