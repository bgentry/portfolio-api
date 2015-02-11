class Portfolio < Sequel::Model
  one_to_many :allocations
  one_to_many :lots

  add_association_dependencies allocations: :destroy, lots: :destroy

  validates :name, presence: true
  validate :allocation_weights_must_add_to_1

  plugin :nested_attributes
  nested_attributes :allocations, destroy: true, fields: ->(portfolio) {
    portfolio.new? ? [:asset_class_id, :weight] : [:weight]
  }

  def allocation_weights_must_add_to_1
    if allocations.map(&:weight).inject(:+) != BigDecimal.new("1.0")
      errors.add(:allocations, "weights must add up to 100%")
    end
  end
end
