class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates :user_id, presence: true
  validates :store_id, presence: true
  validates :user_id, uniqueness: { scope: :store_id, message: "ユーザーは同じ店舗を２重にお気に入り登録できません" }
end
