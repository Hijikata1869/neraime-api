class Store < ApplicationRecord
  has_many :crowdednesses, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  belongs_to :prefecture

  validates :name, :address, presence: true
  validates :name, :address, uniqueness: { case_sensitive: false }
end
