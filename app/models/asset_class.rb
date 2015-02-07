class AssetClass < Sequel::Model
  one_to_many :funds

  validates :name, presence: true
end
