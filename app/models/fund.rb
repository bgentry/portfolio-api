class Fund < ActiveRecord::Base
  belongs_to :asset_class

  validates :asset_class, :name, :symbol, :expense_ratio, presence: true
end
