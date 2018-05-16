class AddSchoolsToLot < ActiveRecord::Migration[5.1]
  def change
    add_column :lots, :school_1, :string, before: :created_at
    add_column :lots, :school_2, :string, before: :created_at
    add_column :lots, :school_3, :string, before: :created_at
    add_column :lots, :school_4, :string, before: :created_at
  end
end
