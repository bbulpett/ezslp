class UserController < ApplicationController
  load_and_authorize_resource
  
  def index
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.organization = current_user.organization
    if @user.save
      flash[:notice] = "Successfully created User." 
      redirect_to dashboard_index_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    if @user = User.get_users(current_user.organization).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to patients_url
    end

  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to dashboard_index_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if User.get_users(current_user.organization).select {|p| p.id.eql?(params[:id].to_i) }.first and @user.patients.empty?
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to dashboard_index_path
    end
    else
      redirect_to dashboard_index_path, :notice  => 'This user is associated with a Patient. It cannot be destroyed. If you want to remove this user you will need to reassign this users patients to another therapist.'
    end
  end
  
end
