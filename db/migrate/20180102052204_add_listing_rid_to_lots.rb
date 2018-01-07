class AddListingRidToLots < ActiveRecord::Migration[5.1]
  def change
    add_column :lots, :listing_rid, :integer, null:false
  end
end
