class AddTotalBedroomsToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :total_bedrooms, :integer, default: 0
  end
end
