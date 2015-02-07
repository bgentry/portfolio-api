Sequel.migration do
  change do
    add_column :funds, :price_updated_at, DateTime
  end
end
