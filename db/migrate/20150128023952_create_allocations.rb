Sequel.migration do
  change do
    create_table :allocations do
      primary_key :id

      foreign_key :asset_class_id, :asset_classes, on_delete: :restrict
      foreign_key :portfolio_id, :portfolios, on_delete: :restrict
      BigDecimal :weight, null: false, size: [3,2]

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
