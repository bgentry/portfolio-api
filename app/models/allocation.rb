class Allocation < ActiveRecord::Base
  belongs_to :asset_class
  belongs_to :portfolio, inverse_of: :allocations

  validates :asset_class, :portfolio, presence: true
end
