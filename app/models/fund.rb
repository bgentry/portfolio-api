class Fund < Sequel::Model
  many_to_one :asset_class
  one_to_many :lots

  validates :asset_class, :name, :symbol, :expense_ratio, presence: true

  dataset_module do
    # Not safe to harvest losses of these funds:
    def recently_purchased
      where(id: Lot.recently_purchased.select(:fund_id)).distinct
    end

    def recently_sold
      where(id: Lot.recently_sold.select(:fund_id)).distinct
    end

    # Not safe to buy funds in this group:
    def recently_realized_losses
      where(id: Lot.recently_realized_losses.select(:fund_id)).distinct
    end
  end
end
