class FundSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :asset_class_id, :name, :symbol, :expense_ratio, :price
  has_one :asset_class
end
