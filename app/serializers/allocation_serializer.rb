class AllocationSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :asset_class_id, :portfolio_id, :weight
  has_one :asset_class
  has_one :portfolio
end
