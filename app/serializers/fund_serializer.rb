class FundSerializer < ActiveModel::Serializer
  attributes :id, :asset_class_id, :name, :symbol, :expense_ratio, :price, :price_updated_at
end
