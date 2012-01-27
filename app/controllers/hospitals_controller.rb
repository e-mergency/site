require 'json'

class HospitalsController < ApplicationController
  def index
    # @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end

  def json_list
    if params[:radius]
      radius = params[:radius].to_i
    else
      radius = 5000
    end

    location = {lat: params[:lat].to_f, lon: params[:lon].to_f, radius: radius}

    @hospitals = Hospital.find_hospitals_sorted(location[:lat], location[:lon], location[:radius], params[:sort])
    render :json => @hospitals
  end
end
