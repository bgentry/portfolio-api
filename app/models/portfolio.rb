class Portfolio < ActiveRecord::Base
  validates :name, presence: true
end
