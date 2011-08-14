class Hospital < ActiveRecord::Base
  validates_presence_of :latitude, :longitude, :name
  validates_uniqueness_of :name
    
  validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0, :less_than_or_equal_to => 180.0
  validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0, :less_than_or_equal_to => 90.0

  def self.to_rad(ang)
    rad = ang/180.0*Math::PI
  end

  def self.distance(lon1, lat1, lon2, lat2)
    # For perfomance reasons use the equirectangular approximation.
    # Its fast and accurate for small distances
    earth_radius = 6371000
    x = (Hospital.to_rad(lon2-lon1)) * Math.cos((Hospital.to_rad(lat1+lat2))/2)
    y = Hospital.to_rad(lat2-lat1)
    d = Math.sqrt(x*x + y*y) * earth_radius
  end

#  def self.find_hospitals_from_longlat(longtitude, latitude, max_distance)
#    earth_radius =  6371000
#
#    return [] if max_distance <= 0.0
#    max_distance=earth_radius if max_distance >= earth_radius
#
#    # The bounding box:
#    # The hospitals of interest are in [longtitude +- delta_max, latitude +- delta_max]
#    delta_max = max_distance/earth_radius/Math::PI*180
#    
#    return Hospital.find(:longtitude => (longtitude-delta_max..longtitude+delta_max), :latitude => (latitude-delta_max..latitude+delta_max)) 
#    
#      #Hospital.find_each(:longtitude => (longtitude-delta_max..longtitude+delta_max), :latitude => (latitude-delta_max..latitude+delta_max)) do |hospital|
#    #  debugger
#    #end
#  end

end
