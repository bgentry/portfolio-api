class Lot < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :asset_class
end