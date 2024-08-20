require 'rails_helper'

RSpec.describe Store, type: :model do

  describe "バリデーションのテスト" do

    context "有効なバリデーション" do
      it "name, address, prefecture_idがあれば有効な状態であること" do
        expect(FactoryBot.build(:store)).to be_valid
      end
    end

    context "無効なバリデーション" do
      it "nameが存在しなければ無効な状態であること" do
        store = FactoryBot.build(:store, name: nil)
        store.valid?
        expect(store.errors[:name]).to include("can't be blank")
      end

      it "addressが存在しなければ無効な状態であること" do
        store = FactoryBot.build(:store, address: nil)
        store.valid?
        expect(store.errors[:address]).to include("can't be blank")
      end

      it "nameの重複は無効な状態であること" do
        FactoryBot.create(:store, name: "store")
        store = FactoryBot.build(:store, name: "store")
        store.valid?
        expect(store.errors[:name]).to include("has already been taken")
      end

      it "addressの重複は無効な状態であること" do
        FactoryBot.create(:store, address: "address")
        store = FactoryBot.build(:store, address: "address")
        store.valid?
        expect(store.errors[:address]).to include("has already been taken")
      end
    end

  end

end
