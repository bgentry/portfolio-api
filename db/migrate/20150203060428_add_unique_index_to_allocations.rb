class AddUniqueIndexToAllocations < ActiveRecord::Migration
  def change
    add_index :allocations, [:portfolio_id, :asset_class_id], unique: true
  end
end
