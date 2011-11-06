require 'json'

class HospitalsController < ApplicationController
  def index
    @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end
  
  def list_all
    @hospitals = Hospital.find(:all, :limit => 10)
    render :json => @hospitals
  end
end
