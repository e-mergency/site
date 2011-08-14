class HospitalsController < ApplicationController
  def index
  end

  def map
    @json = Hospital.all.to_gmaps4rails
  end
end
