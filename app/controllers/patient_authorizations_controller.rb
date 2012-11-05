class PatientAuthorizationsController < ApplicationController
  def index
    @patient_authorizations = PatientAuthorization.get_authorizations(current_user)
  end

  def show
    if @patient_authorization = PatientAuthorization.get_authorizations(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to patient_authorizations_url
    end
  end

  def new
    @patient_authorization = PatientAuthorization.new
#TODO need to add logic to filter patients. we only should display patients in 're-authorize' that are 'eligible'
  end

  def create
    @patient_authorization = PatientAuthorization.new(params[:patient_authorization])
    if @patient_authorization.save
      redirect_to @patient_authorization, :notice => "Successfully created patient authorization."
    else
      render :action => 'new'
    end
  end

  def edit
    if @patient_authorization = PatientAuthorization.get_authorizations(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to patient_authorizations_url
    end
  end

  def update
    @patient_authorization = PatientAuthorization.find(params[:id])
    if @patient_authorization.update_attributes(params[:patient_authorization])
      redirect_to @patient_authorization, :notice  => "Successfully updated patient authorization."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @patient_authorization = PatientAuthorization.find(params[:id])
    if PatientAuthorization.get_authorizations(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first and
      @patient_authorization.visits.empty? #check if there are any Visits with this Patient Authorization before deleting
      @patient_authorization.destroy
      redirect_to patient_authorizations_url, :notice => "Successfully destroyed patient authorization."
    else
      redirect_to patient_authorizations_url, :notice  => 'This Patient Authorization is a associated with one or more visits. It cannot be destroyed. If you want to remove this authorization you will need to first destroy all visits associated with it.'
    end
  end
end
