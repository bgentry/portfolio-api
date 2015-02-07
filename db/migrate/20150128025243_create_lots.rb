Sequel.migration do
  change do
    create_table :lots do
      primary_key :id

      foreign_key :fund_id, :funds,           on_delete: :restrict
      foreign_key :portfolio_id, :portfolios, on_delete: :restrict

      DateTime :acquired_at,     null: false
      DateTime :sold_at
      BigDecimal :quantity,      null: false, size: [15,6]
      money :share_cost,         null: false
      money :proceeds

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
