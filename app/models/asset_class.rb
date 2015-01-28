class AssetClass < ActiveRecord::Base
  has_many :funds, dependent: :destroy

  validates :name, presence: true
end
