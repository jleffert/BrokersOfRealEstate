class AddMiscFeaturesToHouses < ActiveRecord::Migration[5.2]
  def change
    add_column :houses, :misc_features, :string, before: :lot_id
  end
end
