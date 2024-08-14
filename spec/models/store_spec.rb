require 'rails_helper'

RSpec.describe Store, type: :model do

  before do
    @prefecture = Prefecture.create(
      name: "宮城県",
    )
  end

  describe "バリデーションのテスト" do

    context "有効なバリデーション" do
      it "name, address, prefecture_idがあれば有効な状態であること" do
        store = Store.new(
          name: "store",
          address: "store_address",
          prefecture_id: @prefecture.id,
        )
        expect(store).to be_valid
      end
    end

    context "無効なバリデーション" do
      it "nameが存在しなければ無効な状態であること" do
        store = Store.new(name: nil)
        store.valid?
        expect(store.errors[:name]).to include("can't be blank")
      end

      it "addressが存在しなければ無効な状態であること" do
        store = Store.new(address: nil)
        store.valid?
        expect(store.errors[:address]).to include("can't be blank")
      end

      it "nameの重複は無効な状態であること" do
        Store.create(
          name: "store",
          address: "store1_address",
          prefecture_id: @prefecture.id
        )
        store = Store.new(
          name: "store",
          address: "store2_address",
          prefecture_id: @prefecture.id
        )
        store.valid?
        expect(store.errors[:name]).to include("has already been taken")
      end

      it "addressの重複は無効な状態であること" do
        Store.create(
          name: "store1",
          address: "store1_address",
          prefecture_id: @prefecture.id
        )
        store = Store.new(
          name: "store2",
          address: "store1_address",
          prefecture_id: @prefecture.id
        )
        store.valid?
        expect(store.errors[:address]).to include("has already been taken")
      end
    end

  end

end
