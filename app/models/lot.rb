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
      join(:funds, id: :fund_id)
    end

    def join_sells
      join(:sells, lot_id: :id)
    end

    def unrealized_gains
      unrealized.join_fund.where{funds__price > share_cost}
    end

    def unrealized_losses
      unrealized.join_fund.where{funds__price < share_cost}
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
      join_sells.distinct(:lots__id).
        where("date_trunc('day', sold_at) >= date_trunc('day', now()) - interval '30 days'")
    end

    def losses
      join_fund.where{funds__price < share_cost}
    end

    def would_be_wash_sells
      with(:lot_ids_with_quantity_sold,
           from(:sells).select(:lot_id).
           select_append{sum(quantity).as(quantity_sold)}.
           group(:lot_id)
      ).
      with(:lots_with_quantity_sold,
           left_outer_join(:lot_ids_with_quantity_sold, lots__id: :lot_ids_with_quantity_sold__lot_id).
           select_all(:lots).
           select_append{coalesce(:quantity_sold, 0).as(:quantity_sold)}
      ).
      with(:recently_purchased, recently_purchased.select(:id)).
      with(:losses, losses.select(:lots__id)).
      from{lots_with_quantity_sold.as(:lots)}.
      join(:losses, lots__id: :losses__id).
      where{quantity_sold < quantity}.
      where(lots__id: from(:recently_purchased).select(:id))
    end

    def safe_to_sell
      with(:lot_ids_with_quantity_sold,
           from(:sells).select(:lot_id).
           select_append{sum(quantity).as(quantity_sold)}.
           group(:lot_id)
      ).
      with(:lots_with_quantity_sold,
           left_outer_join(:lot_ids_with_quantity_sold, lots__id: :lot_ids_with_quantity_sold__lot_id).
           select_all(:lots).
           select_append{coalesce(:quantity_sold, 0).as(:quantity_sold)}
      ).
      with(:recently_purchased, recently_purchased.select(:id)).
      from{lots_with_quantity_sold.as(:lots)}.
      where{quantity_sold < quantity}.
      exclude(lots__id: from(:recently_purchased).select(:id))
    end

    def safe_to_sell_losses
      with(:lot_ids_with_quantity_sold,
           from(:sells).select(:lot_id).
           select_append{sum(quantity).as(quantity_sold)}.
           group(:lot_id)
      ).
      with(:lots_with_quantity_sold,
           left_outer_join(:lot_ids_with_quantity_sold, lots__id: :lot_ids_with_quantity_sold__lot_id).
           select_all(:lots).
           select_append{coalesce(:quantity_sold, 0).as(:quantity_sold)}
      ).
      with(:recently_purchased, recently_purchased.select(:id)).
      with(:losses, losses.select(:lots__id)).
      from{lots_with_quantity_sold.as(:lots)}.
      join(:losses, lots__id: :losses__id).
      where{quantity_sold < quantity}.
      exclude(lots__id: from(:recently_purchased).select(:id))
    end
  end

  def quantity_sold
    values[:quantity_sold] || BigDecimal.new(sells.sum(&:quantity))
  end

  def safe_to_sell?
    !self.class.safe_to_sell.where(id: self.id).empty?
  end
end
