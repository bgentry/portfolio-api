class SellSerializer < ActiveModel::Serializer
  attributes :id, :price, :quantity, :sold_at
end
