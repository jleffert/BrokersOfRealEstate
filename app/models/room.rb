class Room < ApplicationRecord
  belongs_to :house

  def label
    "#{self.humanize_category}: #{self.description}"
  end

  def humanize_category
    self.category.underscore.humanize 
  end
end
