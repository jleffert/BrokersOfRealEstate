class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :category, null: false
      t.integer :width, null: false
      t.integer :length, null: false
      t.references :house, foreign_key: true, null: false

      t.timestamps
    end
  end
end
