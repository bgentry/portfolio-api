class FundSerializer < ActiveModel::Serializer
  attributes :id, :asset_class_id, :name, :symbol, :expense_ratio, :price
  has_one :asset_class
end
