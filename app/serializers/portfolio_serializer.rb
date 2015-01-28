class PortfolioSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :name
  has_many :allocations
  has_many :lots
end
