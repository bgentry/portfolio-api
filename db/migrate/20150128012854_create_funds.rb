class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.integer :asset_class_id, null: false
      t.string :name,            null: false
      t.string :symbol,          null: false
      t.decimal :expense_ratio,  null: false, precision: 4, scale: 4
      t.money :price, scale: 2,  null: false

      t.timestamps null: false
    end

    add_foreign_key :funds, :asset_classes, on_delete: :restrict
  end
end
