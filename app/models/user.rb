class User < ApplicationRecord

  has_many :crowdednesses

  validates :nickname, :email, :password_digest, presence: true
  validates :nickname, length: { maximum: 30 }
  validates :self_introduction, length: { maximum: 200 }

end