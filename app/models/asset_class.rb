class AssetClass < ActiveRecord::Base
  validates :name, presence: true
end
