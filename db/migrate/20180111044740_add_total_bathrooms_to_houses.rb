class AddTotalBathroomsToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :total_bathrooms, :integer, default: 0
  end
end
