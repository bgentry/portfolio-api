class AllocationSerializer < ActiveModel::Serializer
  attributes :id, :asset_class_id, :portfolio_id, :weight
  has_one :asset_class
end
