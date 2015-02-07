Sequel.migration do
  change do
    add_index :funds, :symbol, unique: true
  end
end
