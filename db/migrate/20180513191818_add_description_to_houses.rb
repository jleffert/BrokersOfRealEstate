class AddDescriptionToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :description, :string
  end
end
