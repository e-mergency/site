require 'json'

class HospitalsController < ApplicationController
  def index
    @hospitals = Hospital.find_hospitals_near_latlon(53.9431092443469, -2.2680899081386, 5000)
  end
  
  def json_list
    case params[:sort]
    when "agony"
      @hospitals =  Hospital.find(:all, :limit => 20).reverse[0..9]
    when "wait"
      @hospitals =  Hospital.find(:all, :limit => 30).reverse[0..9]
    else
      @hospitals = Hospital.find(:all, :limit => 10)
    end
    puts @hospitals.inspect
    render :json => @hospitals
  end
end
