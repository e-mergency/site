class UsersController < ApplicationController

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end


  # GET /users/1/edit_hospital
  # GET /users/1/edit_hospital.xml
  def edit_hospital
    @user = User.find(params[:id])
    if not @user.hospital.nil?
      @hospital = Hospital.new(:id => 0, :name => @user.hospital.name)
    end
    @hospitals = Hospital.find(:all).map {|p| [p.name, p.id] }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.hospital_id = params[:user]["hospital_id"]

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_url, :flash => {:notice => 'User was successfully updated.'}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end



end
