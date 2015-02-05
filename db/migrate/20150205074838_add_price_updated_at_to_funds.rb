class AddPriceUpdatedAtToFunds < ActiveRecord::Migration
  def change
    add_column :funds, :price_updated_at, :datetime
  end
end
