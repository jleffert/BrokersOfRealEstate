class CreateHomes < ActiveRecord::Migration[5.1]
  def change
    create_table :homes do |t|
      t.string :type
      t.string :sub_type
      t.string :address
      t.string :zip
      t.string :city
      t.string :state
      t.integer :lot_square_footage
      t.decimal :listing_price
      t.integer :bathrooms
      t.string :appliances
      t.string :interior_features
      t.string :cooling
      t.string :heating
      t.string :foundation
      t.integer :year_build
      t.string :disclaimer
      t.integer :picture_count
      t.boolean :publish_to_internet
      t.integer :list_id

      t.timestamps
    end
  end
end
