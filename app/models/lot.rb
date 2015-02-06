class Lot < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :fund

  scope :closed, -> { where.not(sold_at: nil) }
  scope :open, -> { where(sold_at: nil) }

  scope :gains, -> { joins(:fund).where("(share_cost * quantity) < coalesce(proceeds, quantity * funds.price)") }
  scope :losses, -> { joins(:fund).where("(share_cost * quantity) > coalesce(proceeds, quantity * funds.price)") }
  scope :realized_losses, -> { where("(share_cost * quantity) > proceeds").where.not(sold_at: nil) }
  scope :unrealized_losses, -> { open.losses }

  scope :long_term, -> { where("(coalesce(sold_at, now()) - acquired_at) >= '1 year'") }
  scope :short_term, -> { where("(coalesce(sold_at, now()) - acquired_at) < '1 year'") }
  scope :recently_purchased, -> {
    where("date_trunc('day', acquired_at) > date_trunc('day', now()) - interval '30 days'")
  }
  scope :recently_sold, -> {
    closed.where("date_trunc('day', sold_at) > date_trunc('day', now()) - interval '30 days'")
  }
end
