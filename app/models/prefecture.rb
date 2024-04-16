class Prefecture < ApplicationRecord
  has_many :stores
  
  validates :name, presence: true

end