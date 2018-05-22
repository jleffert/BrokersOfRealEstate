class Lot < ApplicationRecord
  has_one :house, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy

  LOT_FEATURES = {
    "SECL": "Secluded",
    "PRIV": "Private Roadway",
    "LEVE": "Lot Description: Level"
  }
end
