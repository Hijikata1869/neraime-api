class Store < ApplicationRecord
  has_many :crowdednesses
  belongs_to :prefecture

  validates :name, :address, presence: true
end