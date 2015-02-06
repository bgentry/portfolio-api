class Lot < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :fund

  scope :closed, -> { where.not(sold_at: nil) }
  scope :open, -> { where(sold_at: nil) }

  scope :gains, -> { joins(:fund).where("share_cost < funds.price") }
  scope :losses, -> { joins(:fund).where("share_cost > funds.price") }
  scope :unrealized_losses, -> { open.losses }

  scope :long_term, -> { where("(coalesce(sold_at, now()) - acquired_at) >= '1 year'") }
  scope :short_term, -> { where("(coalesce(sold_at, now()) - acquired_at) < '1 year'") }
end
