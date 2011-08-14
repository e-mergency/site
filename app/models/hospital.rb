class Hospital < ActiveRecord::Base
  validates_presence_of :latitude, :longitude, :name

  validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0, :less_than_or_equal_to => 180.0
  validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0, :less_than_or_equal_to => 90.0


end
