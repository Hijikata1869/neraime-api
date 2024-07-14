class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_image

  has_many :crowdednesses, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_stores, through: :favorites, source: :store

  validates :nickname, :email, :password_digest, presence: true
  validates :nickname, length: { maximum: 30 }
  validates :self_introduction, length: { maximum: 200 }

end
