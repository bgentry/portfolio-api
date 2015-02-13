Sequel.migration do
  change do
    create_table :sells do
      primary_key :id

      foreign_key :lot_id, :lots,           on_delete: :restrict

      BigDecimal :quantity, null: false, size: [15,6]
      money :price,         null: false
      DateTime :sold_at,    null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
