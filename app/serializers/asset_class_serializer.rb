class AssetClassSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :funds
end
