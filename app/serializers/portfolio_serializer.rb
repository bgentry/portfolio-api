class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :allocations, embed: :objects
  has_many :lots
end
