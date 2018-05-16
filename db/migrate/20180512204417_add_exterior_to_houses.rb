class AddExteriorToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :exterior, :string, before: :lot_id
  end
end
