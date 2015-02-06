class AddUniqueIndexToFundSymbol < ActiveRecord::Migration
  def change
    add_index :funds, :symbol, unique: true
  end
end
