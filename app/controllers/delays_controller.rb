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

    nb_days = 20
    start = nb_days.days.ago.to_f 
    dates = [start.to_f] + Delay.all(:conditions => {:updated_at => start..0.days.ago}).map{|d| d.created_at.to_f}.reverse + [0] # We add to additional nodes at the beginning and the end of the timespan
    dates2 = dates.map{|d| (d-start)/20}
    delays = Delay.find(:all, :select => :minutes).map(&:minutes).reverse
    delays2 = [delays[0]] + delays + [delays[-1]]
    data = [dates2, delays2] 
    wdays = ['Sun', 'Sat', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    @graph_url = Gchart.line_xy(:size => '500x300', 
                             :title => "Last weeks delay time",
#                             :bg => 'efefef',
                             :legend => 'first data set label',
                             :data => data,
                             :axis_with_label => 'x,y',
                             :axis_labels => ['Mon|Tue|Wed|Thu|Fri|Sat|Sun']
                            )
    # We need some extra parameters for the graph axis that is not supported by Gchart...
    @graph_url = @graph_url + "&chxt=x,y"



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
