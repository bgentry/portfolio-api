class Allocation < Sequel::Model
  many_to_one :asset_class
  many_to_one :portfolio

  validates :asset_class, :portfolio, :weight, presence: true
  validates :weight, numericality: {
    greater_than: BigDecimal.new("0.0"),
    less_than_or_equal_to: BigDecimal.new("1.0"),
  }
end
