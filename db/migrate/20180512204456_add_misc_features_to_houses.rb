class AddMiscFeaturesToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :misc_features, :string, before: :lot_id
  end
end
