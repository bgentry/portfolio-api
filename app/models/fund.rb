class Fund < ActiveRecord::Base
  belongs_to :asset_class
  has_many :lots

  validates :asset_class, :name, :symbol, :expense_ratio, presence: true

  scope :recently_purchased, -> {
    joins(:lots).distinct.where(
      "date_trunc('day', lots.acquired_at) > date_trunc('day', now()) - interval '30 days'"
    )
  }
  scope :recently_sold, -> {
    joins(:lots).distinct.where.not(lots: {sold_at: nil}).where(
      "date_trunc('day', lots.sold_at) > date_trunc('day', now()) - interval '30 days'"
    )
  }
  scope :recently_realized_losses, -> {
    recently_sold.where(
      "(lots.share_cost * lots.quantity) > coalesce(lots.proceeds, lots.quantity * price)"
    )
  }
end
