class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :allocations
  has_many :lots
end
