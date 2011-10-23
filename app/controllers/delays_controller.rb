class DelaysController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  before_filter :get_hospital

  def get_hospital
     @hospital = Hospital.find(params[:hospital_id])
  end

  # GET /delays
  # GET /delays.xml
  def index
    @delays = Delay.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delays }
    end
  end

  # GET /delays/new
  # GET /delays/new.xml
  def new
    @delay = Delay.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delay }
    end
  end

  # POST /delays
  # POST /delays.xml
  def create
    @delay = @hospital.delays.new(params[:delay])

    respond_to do |format|
      if @delay.save
        format.html { redirect_to(hospital_delays_path(@hospital), :notice => 'Delay was successfully created.') }
        format.xml  { render :xml => @delay, :status => :created, :location => @delay }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delay.errors, :status => :unprocessable_entity }
      end
    end
  end
end
