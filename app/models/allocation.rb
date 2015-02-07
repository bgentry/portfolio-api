class Allocation < Sequel::Model
  many_to_one :asset_class
  many_to_one :portfolio

  validates :asset_class, :portfolio, presence: true
end
