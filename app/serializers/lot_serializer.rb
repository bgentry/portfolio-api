class LotSerializer < ActiveModel::Serializer
  attributes :id, :fund_id, :portfolio_id, :acquired_at, :quantity, :quantity_sold, :share_cost
end
