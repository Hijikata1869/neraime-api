class Store < ApplicationRecord
  has_many :crowdednesses, dependent: :destroy
  belongs_to :prefecture

  validates :name, :address, presence: true
  validates :name, :address, uniqueness: { case_sensitive: false }
end
