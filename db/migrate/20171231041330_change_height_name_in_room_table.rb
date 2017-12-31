class ChangeHeightNameInRoomTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :rooms, :height, :length
  end
end
