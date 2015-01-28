class Allocation < ActiveRecord::Base
  belongs_to :asset_class
  belongs_to :portfolio

  validates :asset_class, :portfolio, presence: true
end
