class CreateLots < ActiveRecord::Migration[5.1]
  def change
    create_table :lots do |t|
      t.string :sub_type
      t.string :address
      t.string :zip
      t.string :city
      t.string :state
      t.string :directions
      t.decimal :list_price
      t.decimal :original_list_price
      t.integer :square_footage
      t.string :lot_features
      t.string :water_source
      t.string :electric_provider
      t.string :gas_provider
      t.integer :tax_amount
      t.integer :tax_year
      t.string :disclaimer
      t.integer :picture_count
      t.boolean :publish_to_internet, null: false
      t.integer :list_id, null: false

      t.timestamps
    end
  end
end
