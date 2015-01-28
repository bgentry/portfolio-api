class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.integer :fund_id
      t.integer :portfolio_id
      t.datetime :acquired_at
      t.datetime :sold_at
      t.money :proceeds,                  scale: 2
      t.decimal :quantity, precision: 15, scale: 6
      t.money :share_cost,                scale: 2

      t.timestamps null: false
    end
  end
end
