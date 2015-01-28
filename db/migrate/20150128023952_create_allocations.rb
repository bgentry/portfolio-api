class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :asset_class_id,                 null: false
      t.integer :portfolio_id,                   null: false
      t.decimal :weight, precision: 3, scale: 2, null: false

      t.timestamps null: false
    end

    add_foreign_key :allocations, :asset_classes, on_delete: :restrict
    add_foreign_key :allocations, :portfolios,    on_delete: :restrict
  end
end
