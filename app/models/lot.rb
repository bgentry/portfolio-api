class Lot < Sequel::Model
  many_to_one :portfolio
  many_to_one :fund
  one_to_many :sells

  # TODO: validations
  # TODO: validate share_cost as money > $0

  dataset_module do
    def with_quantity_sold
      lwqs = from(:sells).select(:lot_id).
        select_append{sum(quantity).as(quantity_sold)}.
        group(:lot_id)

      with(:lot_ids_with_quantity_sold, lwqs).
        with(:lots_with_quantity_sold,
             left_outer_join(:lot_ids_with_quantity_sold, lots__id: :lot_ids_with_quantity_sold__lot_id).
             select_all(:lots).
             select_append{coalesce(:quantity_sold, 0).as(:quantity_sold)}
        ).
        from{lots_with_quantity_sold.as(:lots)}
    end

    def unrealized
      with_quantity_sold.where{quantity_sold < quantity}
    end

    def realized
      unrealized.invert
    end

    def join_fund
      join(:funds, funds__id: :lots__fund_id)
    end

    def join_portfolio
      join(:portfolios, portfolios__id: :lots__portfolio_id)
    end

    def join_sells
      join(:sells, sells__lot_id: :lots__id)
    end

    def unrealized_gains
      unrealized.gains.select_all(:lots)
    end

    def unrealized_losses
      unrealized.losses.select_all(:lots)
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

    def recently_purchased_fund_ids
      recently_purchased.distinct(:fund_id).select(:fund_id)
    end

    def recently_sold
      join_sells.distinct(:lots__id).
        where("date_trunc('day', sold_at) >= date_trunc('day', now()) - interval '30 days'").
        select_all(:lots)
    end

    def gains
      join_fund.where{funds__price > share_cost}.select_all(:lots)
    end

    def losses
      join_fund.where{funds__price < share_cost}.select_all(:lots)
    end

    def would_be_wash_sells
      unrealized_losses.where(fund_id: recently_purchased_fund_ids)
    end

    def safe_to_sell
      unrealized.exclude(fund_id: recently_purchased_fund_ids)
    end

    def safe_to_sell_taxable_losses
      safe_to_sell.losses.join_portfolio.where(portfolios__taxable: true).select_all(:lots)
    end
  end

  def quantity_sold
    values[:quantity_sold] || BigDecimal.new(sells.sum(&:quantity))
  end

  def safe_to_sell?
    !self.class.safe_to_sell.where(id: self.id).empty?
  end
end
