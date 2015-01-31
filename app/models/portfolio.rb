class Portfolio < ActiveRecord::Base
  has_many :allocations, dependent: :destroy, inverse_of: :portfolio
  has_many :lots, dependent: :destroy

  validates :name, presence: true
  validate :allocation_weights_must_add_to_1

  accepts_nested_attributes_for :allocations

  def allocation_weights_must_add_to_1
    if allocations.map(&:weight).inject(:+) != BigDecimal.new("1.0")
      errors.add(:allocations, "weights must add up to 100%")
    end
  end
end
