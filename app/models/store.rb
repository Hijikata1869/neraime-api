class Store < ApplicationRecord
  has_many :crowdednesses
  belongs_to :prefecture

  validates :name, :address, presence: true

  def convert_prefecture_id_to_name
    data = {
      id: self.id,
      name: self.name,
      address: self.address,
      prefecture: self.prefecture.name,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

end