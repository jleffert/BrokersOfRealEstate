class Room < ApplicationRecord
  belongs_to :house
  scope :bedrooms, -> { where("category LIKE ?", '%Bedroom%') }
end
