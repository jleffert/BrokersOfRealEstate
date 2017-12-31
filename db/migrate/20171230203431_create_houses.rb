class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses do |t|
      t.integer :square_footage, null: false
      t.string :appliances
      t.string :interior_features
      t.string :basement_type
      t.integer :garage_space
      t.string :cooling
      t.string :heating
      t.string :foundation
      t.integer :year_built
      t.references :lot, foreign_key: true, null: false

      t.timestamps
    end
  end
end
