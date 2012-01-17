class DelaysController < ApplicationController
  before_filter :authenticate_user!
  check_authorization :except => :index
  # Check whether the logged in user is allowed to manage delays based on the
  # assigned hospital
  load_and_authorize_resource :hospital
  load_and_authorize_resource :through => :hospital
  # Everyone can view delays
  skip_authorize_resource :only => :index
  skip_authorize_resource :hospital, :only => :index

  before_filter :get_hospital

  def get_hospital
     @hospital = Hospital.find(params[:hospital_id])
  end

  # GET /delays
  # GET /delays.xml
  def index
    @delays = Delay.all
    dates = Delay.find(:all).map{|d| d.created_at.to_f}.reverse
    start = dates[0]
    dates2 = dates.map{|d| (d-start)/10}
    data = [dates2, Delay.find(:all, :select => :minutes).map(&:minutes).reverse]
    #require 'ruby-debug'
    #debugger
    @graph_url = Gchart.line_xy(:size => '500x300', 
                             :title => "example title",
#                             :bg => 'efefef',
                             :legend => 'first data set label',
                             :data => data,
                             :axis_with_label => 'x,y',
                             :axis_labels => ['Jan|July|Jan|July|Jan|6|7|8', '0|100|1|2|3|4|5|6'])

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
        format.html { redirect_to(new_hospital_delay_path(@hospital), :notice => 'Delay was successfully created.') }
        format.xml  { render :xml => @delay, :status => :created, :location => @delay }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delay.errors, :status => :unprocessable_entity }
      end
    end
  end
end
