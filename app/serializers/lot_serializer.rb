class LotSerializer < ActiveModel::Serializer
  attributes :id, :fund_id, :portfolio_id, :acquired_at, :sold_at, :proceeds, :quantity, :share_cost
end
