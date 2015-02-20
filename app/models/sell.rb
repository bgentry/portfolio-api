class Sell < Sequel::Model
  many_to_one :lot
  one_through_one :fund, :join_table=>:lots, :left_key=>:id, :left_primary_key=>:lot_id, :right_key=>:fund_id

  validates :lot, :price, :sold_at, presence: true
  validates :quantity, numericality: {greater_than: 0}
  # TODO: validate price as money > $0

  dataset_module do
    def join_lot
      join(:lots, id: :lot_id)
    end

    def gains
      join_lot.select_all(:sells).where{lots__share_cost < sells__price}
    end

    def losses
      join_lot.select_all(:sells).where{lots__share_cost > sells__price}
    end

    def short_term
      join_lot.select_all(:sells).
        where("(sold_at - lots.acquired_at) < interval '1 year'")
    end

    def long_term
      join_lot.select_all(:sells).
        where("(sold_at - lots.acquired_at) >= interval '1 year'")
    end

    def recently_realized
      where("date_trunc('day', sold_at) > date_trunc('day', now()) - interval '30 days'")
    end

    def recently_realized_losses
      losses.recently_realized
    end
  end

end
