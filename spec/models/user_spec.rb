require 'rails_helper'

RSpec.describe User, type: :model do

  describe "バリデーションのテスト" do

    context "有効なバリデーション" do
      it "nickname, email, password, password_confirmationがあれば有効な状態であること" do
        expect(FactoryBot.build(:user)).to be_valid
      end

      it "nicknameは30文字以内であれば有効な状態であること" do
        nickname = "a" * 30
        user = FactoryBot.build(:user, nickname: nickname)
        user.valid?
        expect(user.errors[:password]).to_not include("is too long (maximum is 30 characters)")
      end

      it "self_introductionは200文字以内であれば有効な状態であること" do
        introduction = "a" * 200
        user = FactoryBot.build(:user, self_introduction: introduction)
        user.valid?
        expect(user.errors[:self_introduction]).to_not include("is too long (maximum is 200 characters)")
      end
    end

    context "無効なバリデーション" do
      it "nicknameが存在しなければ無効な状態であること" do
        user = FactoryBot.build(:user, nickname: nil)
        user.valid?
        expect(user.errors[:nickname]).to include("can't be blank")
      end

      it "emailが存在しなければ無効な状態であること" do
        user = FactoryBot.build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "passwordがなければ無効な状態であること" do
        user = FactoryBot.build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      it "nicknameは31文字以上だと無効な状態であること" do
        nickname = "a" * 31
        user = FactoryBot.build(:user, nickname: nickname)
        user.valid?
        expect(user.errors[:nickname]).to include("is too long (maximum is 30 characters)")
      end

      it "self_introductionは201文字以上だと無効な状態であること" do
        introduction = "a" * 201
        user = FactoryBot.build(:user, self_introduction: introduction)
        user.valid?
        expect(user.errors[:self_introduction]).to include("is too long (maximum is 200 characters)")
      end

      it "emailの重複は無効な状態であること" do
        FactoryBot.create(:user, email: "user@example.com")
        user = FactoryBot.build(:user, email: "user@example.com")
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
    end

  end

end
