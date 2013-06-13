class Hospital
  include Mongoid::Document
  include ActionView::Helpers::DateHelper

  embeds_many :delays
  has_many :users
  field :source_uri, type: String
  field :name, type: String
  field :updated, type: Date
  field :odscode, type: String
  field :postcode, type: String
  field :location, type: Array
  index({ location: "2d" })

  validates_presence_of :location, :name
  validates_uniqueness_of :odscode

  validate :validate_location
  def validate_location
    errors.add(:location, 'invalid location') unless !self.location.nil? and
      self.location.length == 2 and
      self.location[0].is_a?(Numeric) and
      (-180..180).include?(self.location[0]) and
      self.location[1].is_a?(Numeric) and
      (-90..90).include?(self.location[1])
  end

  def as_json(options={})
    if options[:mobile]
      return super(:only => [:odscode], :methods => [:delay])
    end
    j = super(:only => [:_id, :odscode, :postcode, :name, :location, :distance],
          :methods => [:delay, :last_updated_at])
    j[:distance] = self.geo_near_distance.round(2) if self.geo_near_distance
    return j
  end

  def compute_distance(lat, lon)
    distance = Hospital.compute_distance(lat, lon, self.location[1], self.location[0])
  end

  def self.find_hospitals_sorted(lat, lon, max_distance, sort, max_results=20, units='km')
    hospitals = Hospital.find_hospitals_near_latlon(lat, lon, max_distance, max_results, units)

    case sort
    when "distance" # By distance
      hospitals # No need to sort, as the sorting by distance is the default
    when "wait" # By wait time
      hospitals.sort!{|a,b| a.delay <=> b.delay}
    else # Our custom ranking algorithm
      # FIXME: replace by some smart algorithm when we have one
      # Weigh delay against distance, assuming you travel 100m / min
      hospitals.sort!{|a,b| a.delay+10*a.geo_near_distance <=> b.delay+10*b.geo_near_distance}
    end
  end

  # Max distance must be provided in the given units (km or mi)
  def self.find_hospitals_near_latlon(lat, lon, max_distance=5, max_results=20, units='km')
    earth_radius = units == 'km' ? 6371.0 : 3959.0
    Hospital.limit(max_results).geo_near([lon, lat]).spherical.distance_multiplier(earth_radius).max_distance(max_distance/earth_radius).unique(true).to_a
  end

  def self.find_hospitals_in_bb(lat, lon, max_distance, max_results)
    earth_radius = 6371000.0
    earth_radius_at_lat = Math.cos(Hospital.to_rad(lat))*earth_radius

    # Check for valid input data
    max_distance = [earth_radius*2*Math::PI, Float(max_distance)].min

    # The hospitals of interest are in the bounding box [longtitude +- delta_max_lat, latitude +- delta_max_lon]
    delta_max_lon = Hospital.to_deg(Float(max_distance)/earth_radius_at_lat)
    delta_max_lat = Hospital.to_deg(Float(max_distance)/earth_radius)

    hospitals_bb = Hospital.within_box(:location => [ [lon-delta_max_lon, lat-delta_max_lat], [lon+delta_max_lon, lat+delta_max_lat] ]).limit(max_results)

    return hospitals_bb
  end

  def current_delay
    self.delays.first
  end

  def delay
    (self.current_delay.try(:minutes) or 0).round(2)
  end

  def last_updated_at
    begin
      "#{distance_of_time_in_words_to_now(self.current_delay.updated_at)} ago"
    rescue
      "never"
    end
  end

  def latitude
    self.location[1]
  end

  def longitude
    self.location[0]
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
