class Lot < ApplicationRecord
  has_one :house
  has_many :images, as: :imageable, dependent: :destroy
end
