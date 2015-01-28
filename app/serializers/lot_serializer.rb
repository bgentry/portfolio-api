class LotSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :fund_id, :portfolio_id, :acquired_at, :sold_at, :proceeds, :quantity, :share_cost
  has_one :fund
  has_one :portfolio
end
