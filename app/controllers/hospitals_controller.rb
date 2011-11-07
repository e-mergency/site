require 'json'

class HospitalsController < ApplicationController
  def index
    @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end
  
  def json_list
    case params[:sort]
    when "agony" # Our custom ranking algorithm
      @hospitals =  Hospital.find(:all, :limit => 20).reverse[0..9]
    when "wait" # By wait time
      @hospitals =  Hospital.find(:all, :limit => 30).reverse[0..9]
    else # By distance
      @hospitals = Hospital.find(:all, :limit => 10)
    end
    render :json => @hospitals
  end
end
