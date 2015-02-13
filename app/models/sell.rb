class Sell < Sequel::Model
  many_to_one :lot

  validates :lot, :price, :sold_at, presence: true
  validates :price, numericality: {greater_than: 0}
  validates :quantity, numericality: {greater_than: 0}

end
