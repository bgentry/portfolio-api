class Sell < Sequel::Model
  many_to_one :lot

  validates :lot, :price, :sold_at, presence: true
  validates :quantity, numericality: {greater_than: 0}
  # TODO: validate price as money > $0

end
