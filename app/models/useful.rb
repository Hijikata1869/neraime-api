class Useful < ApplicationRecord

  belongs_to :user
  belongs_to :crowdedness

  validates :user_id, presence: true
  validates :crowdedness_id, presence: true
  validates :user_id, uniqueness: { scope: :crowdedness_id, message: "ユーザーは同じ混雑度投稿に２回参考になった登録はできません" }

end
