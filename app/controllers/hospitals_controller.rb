require 'json'

class HospitalsController < ApplicationController
  def index
    # @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end
  
  def json_list
    if params[:radius]
      radius = params[:radius].to_i
    else
      radius = 1000
    end
    
    location = {lat: params[:lat].to_f, lon: params[:lon].to_f, radius: radius}
    
    # Add the filtering back in when it's implemented
    
    # case params[:sort]
    # when "agony" # Our custom ranking algorithm
    # @hospitals = Hospital.find_hospitals_near_latlon(location[:lat], location[:lon], location[:radius])
    # when "wait" # By wait time
    # @hospitals = Hospital.find_hospitals_near_latlon(location[:lat], location[:lon], location[:radius])
    # else # By distance
    # @hospitals = Hospital.find_hospitals_near_latlon(location[:lat], location[:lon], location[:radius])
    # end

    @hospitals = Hospital.find_hospitals_near_latlon(location[:lat], location[:lon], location[:radius])
    render :json => @hospitals
  end
end
