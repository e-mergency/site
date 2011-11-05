class Hospital < ActiveRecord::Base
  has_many :delays
  has_many :users

  validates_presence_of :latitude, :longitude, :name
  validates_uniqueness_of :name
    
  validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0, :less_than_or_equal_to => 180.0
  validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0, :less_than_or_equal_to => 90.0

  attr_accessor :distance

  def compute_distance(lat, lon)
    lat2 = self.latitude
    lon2 = self.longitude
    distance = Hospital.compute_distance(lat, lon, lat2, lon2)
  end

  def self.find_hospitals_near_latlon(lat, lon, max_distance)
    earth_radius = 6371000.0
    earth_radius_at_lat = Math.cos(Hospital.to_rad(lat))*earth_radius

    # Check for valid input data
    max_distance = [earth_radius*2*Math::PI, Float(max_distance)].min

    # The hospitals of interest are in the bounding box [longtitude +- delta_max_lat, latitude +- delta_max_lon]
    delta_max_lon = Hospital.to_deg(Float(max_distance)/earth_radius_at_lat)
    delta_max_lat = Hospital.to_deg(Float(max_distance)/earth_radius)
    
    hospitals_bb = Hospital.where(:longitude => (lon-delta_max_lon..lon+delta_max_lon), :latitude => (lat-delta_max_lat..lat+delta_max_lat)) 

    # Remove the hospitals with distance > max_distance
    hospitals = []
    hospitals_bb.each do |hospital| 
      hospital.distance = hospital.compute_distance(lat, lon)
      if hospital.distance <= max_distance
        hospitals.push(hospital)
      end
    end

    return hospitals
  end

  def current_delay
    self.delays.first or Delay.new
  end

  ### Class methods  ###

  def self.to_rad(ang)
    rad = Float(ang)/180.0*Math::PI
  end

  def self.to_deg(ang)
    rad = Float(ang)*180.0/Math::PI
  end

  def self.compute_distance(lat1, lon1, lat2, lon2)
    # For perfomance reasons use the equirectangular approximation.
    # Its fast and accurate for small distances
    earth_radius = 6371000.0
    x = (Hospital.to_rad(lon2-lon1)) * Math.cos((Hospital.to_rad(lat1+lat2))/2)
    y = Hospital.to_rad(lat2-lat1)
    d = Math.sqrt(x*x + y*y) * earth_radius
  end
end
