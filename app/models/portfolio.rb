class Portfolio < ActiveRecord::Base
  has_many :allocations, dependent: :destroy
  has_many :lots, dependent: :destroy

  validates :name, presence: true
end
