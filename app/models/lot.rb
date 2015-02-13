class Lot < Sequel::Model
  many_to_one :portfolio
  many_to_one :fund
  one_to_many :sells

  dataset_module do
    subset :unrealized, {sold_at: nil}

    def with_quantity_sold
      left_join(:sells, lot_id: :id).group(:lots__id, :sells__id).select_all(:lots).
        select_append{coalesce(sum(sells__quantity), 0).as(quantity_sold)}.
        order(:lots__id)
    end

    def realized
      unrealized.invert
    end

    def join_funds
      join(:funds, id: :fund_id)
    end

    def gains
      join_funds.where{share_cost * quantity < coalesce(proceeds, quantity * price)}
    end

    def losses
      join_funds.where{share_cost * quantity > coalesce(proceeds, quantity * price)}
    end

    def realized_losses
      realized.losses
    end

    def unrealized_losses
      unrealized.losses
    end

    def short_term
      where("(coalesce(sold_at, now()) - acquired_at) < interval '1 year'")
    end

    def long_term
      where("(coalesce(sold_at, now()) - acquired_at) >= interval '1 year'")
    end

    def recently_purchased
      where("date_trunc('day', acquired_at) > date_trunc('day', now()) - interval '30 days'")
    end

    def recently_sold
      realized.where("date_trunc('day', sold_at) > date_trunc('day', now()) - interval '30 days'")
    end

    def recently_realized_losses
      realized_losses.recently_sold
    end

    def would_be_wash_sells
      unrealized.where(fund_id: recently_purchased.select(:fund_id).distinct)
    end

    def safe_to_sell
      unrealized.exclude(fund_id: would_be_wash_sells.select(:fund_id).distinct)
    end

    def safe_to_sell_losses
      safe_to_sell.losses
    end
  end

  def quantity_sold
    values[:quantity_sold] || sells_dataset.select{coalesce(sum(quantity), 0)}
  end

  def safe_to_sell?
    !self.class.safe_to_sell.where(id: self.id).empty?
  end
end
