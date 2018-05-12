class House < ApplicationRecord
  paginates_per 25
  belongs_to :lot
  has_many :rooms

  def images
    lot.images
  end
end
