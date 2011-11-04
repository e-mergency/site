class HospitalsController < ApplicationController
  def index
    @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end

  def map
    @json = Hospital.all.to_gmaps4rails
  end
end
