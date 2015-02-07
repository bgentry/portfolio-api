class Lot < Sequel::Model
  many_to_one :portfolio
  many_to_one :fund

  dataset_module do
    subset :unrealized, {sold_at: nil}

    def realized
      unrealized.invert
    end

    def join_funds
      join(:funds, :id => :fund_id)
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
end
