class AddDescriptionToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :description, :string, before: :house_id
  end
end
