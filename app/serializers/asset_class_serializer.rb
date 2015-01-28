class AssetClassSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :name
  has_many :funds
end
