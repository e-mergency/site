require 'json'

class HospitalsController < ApplicationController
  def index
    # @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end

  def json_list
    max_distance = 5000
    max_results = 20

    location = {lat: params[:lat].to_f, lon: params[:lon].to_f, radius: (params[:radius] || max_distance).to_i}

    @hospitals = Hospital.find_hospitals_sorted(location[:lat],
                                                location[:lon],
                                                location[:radius],
                                                params[:sort],
                                                (params[:max_results] || max_results).to_i)
    render :json => @hospitals
  end
end
