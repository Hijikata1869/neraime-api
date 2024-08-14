require 'rails_helper'

RSpec.describe Crowdedness, type: :model do

  describe "バリデーションのテスト" do
    context "有効なバリデーション" do
      it "user_id, store_id, day_of_week, time, levelが存在すれば有効な状態であること" do
        expect(FactoryBot.build(:crowdedness)).to be_valid
      end

      it "memoは300文字以内なら有効な状態であること" do
        memo = "a" * 300
        crowdedness = FactoryBot.build(:crowdedness, memo: memo)
        crowdedness.valid?
        expect(crowdedness.errors[:memo]).to_not include("is too long (maximum is 300 characters)")
      end
    end

    context "無効なバリデーション" do
      it "day_of_weekが存在しなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, day_of_week: nil)
        crowdedness.valid?
        expect(crowdedness.errors[:day_of_week]).to include("can't be blank")
      end

      it "timeが存在しなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, time: nil)
        crowdedness.valid?
        expect(crowdedness.errors[:time]).to include("can't be blank")
      end

      it "levelが存在しなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, level: nil)
        crowdedness.valid?
        expect(crowdedness.errors[:level]).to include("can't be blank")
      end

      it "day_of_weekは「月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日」のいずれかでなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, day_of_week: "月")
        crowdedness.valid?
        expect(crowdedness.errors[:day_of_week]).to include("月 は無効な値です")
      end

      it "timeは0:00 ~ 23:00のいずれかの値でなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, time: "24:00")
        crowdedness.valid?
        expect(crowdedness.errors[:time]).to include("24:00 は無効な値です")
      end

      it "levelは「空いてる 普通 混雑 空き無し」のいずれかの値でなければ無効な状態であること" do
        crowdedness = FactoryBot.build(:crowdedness, level: "激混み")
        crowdedness.valid?
        expect(crowdedness.errors[:level]).to include("激混みは無効な値です")
      end

      it "memoは301文字以上であれば無効な状態であること" do
        memo = "a" * 301
        crowdedness = FactoryBot.build(:crowdedness, memo: memo)
        crowdedness.valid?
        expect(crowdedness.errors[:memo]).to include("is too long (maximum is 300 characters)")
      end
    end
  end
end
