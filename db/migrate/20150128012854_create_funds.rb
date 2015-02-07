Sequel.migration do
  change do
    create_table :funds do
      primary_key :id

      foreign_key :asset_class_id, :asset_classes, on_delete: :restrict
      String :name,              null: false
      String :symbol,            null: false
      BigDecimal :expense_ratio, null: false, size: [4,4]
      money :price,              null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
