Sequel.migration do
  change do
    add_index :allocations, [:portfolio_id, :asset_class_id], unique: true
  end
end
