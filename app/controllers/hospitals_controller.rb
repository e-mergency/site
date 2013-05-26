require 'json'

class HospitalsController < ApplicationController

  def index
    max_distance = 5 # Distance in kilometers
    max_results = 20

    @hospitals = Hospital.find_hospitals_sorted(params[:lat].to_f,
                                                params[:lon].to_f,
                                                (params[:radius] || max_distance).to_f,
                                                params[:sort],
                                                (params[:max_results] || max_results).to_i)
    respond_to do |format|
      format.html # index.html.haml
      format.json  { render :json => @hospitals.as_json(:mobile => params[:mobile]) }
    end
  end

  def find
    @hospitals = Hospital.find(:all, :limit => 10)
    render :json => @hospitals
  end

end
