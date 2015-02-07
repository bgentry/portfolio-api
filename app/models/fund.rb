class Fund < ActiveRecord::Base
  belongs_to :asset_class
  has_many :lots

  validates :asset_class, :name, :symbol, :expense_ratio, presence: true

  scope :recently_purchased, -> { joins(:lots).merge(Lot.recently_purchased).distinct }
  scope :recently_sold, -> { joins(:lots).merge(Lot.recently_sold).distinct }
  scope :recently_realized_losses, -> { joins(:lots).merge(Lot.recently_realized_losses).distinct }
end
