class Store < ApplicationRecord
  has_many :crowdednesses, dependent: :destroy
  belongs_to :prefecture

  validates :name, :address, presence: true

end
