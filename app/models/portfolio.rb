class Portfolio < ActiveRecord::Base
  has_many :allocations, dependent: :destroy

  validates :name, presence: true
end
