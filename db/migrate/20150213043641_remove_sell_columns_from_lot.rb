Sequel.migration do
  change do
    drop_column :lots, :sold_at
    drop_column :lots, :proceeds
  end

  down do
    add_column :lots, :sold_at, DateTime
    add_column :lots, :proceeds, :money
  end
end
