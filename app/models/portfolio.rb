class Portfolio < ActiveRecord::Base
  has_many :allocations, dependent: :destroy, inverse_of: :portfolio
  has_many :lots, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :allocations
end
