class Room < ApplicationRecord
  belongs_to :house
  scope :bedrooms, -> { where("category LIKE ?", '%Bedroom%') }

  def label
    "#{self.humanize_category}: #{self.description}"
  end

  def humanize_category
    self.category.underscore.humanize 
  end
end
