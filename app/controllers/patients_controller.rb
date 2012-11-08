class PatientsController < ApplicationController
  before_filter :get_users_for_collection_select

  def index
    @patients = Patient.get_patients(current_user) #multi-tenancy; only returns tasks with the the current users org
    @patients.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }
  end

#if conditionals below only allows user to view model if it is returned via the get_patients method
 def show
    if @patient = Patient.get_patients(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to patients_url
    end
  end

  def new
    @patient = Patient.new
    @patient.patient_authorizations.build
  end

  def create
    @patient = Patient.new(params[:patient])
    if @patient.save
      redirect_to patients_path, :notice => "Successfully created patient."
    else
      render :action => 'new'
    end
  end

  def edit
    if @patient = Patient.get_patients(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to patients_url
    end
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(params[:patient])
      redirect_to @patient, :notice  => "Successfully updated patient."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    if Patient.get_patients(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first and @patient.patient_authorizations.empty?
      @patient.destroy
      redirect_to patients_url, :notice => "Successfully destroyed patient."
    else
      redirect_to patients_url, :notice  => 'This patient is associated with a Patient Authorization. It cannot be destroyed. If you want to remove this patient you will need to destroy the Patient Authorization and any associated visits.'
    end
  end

#TODO this should only return all users for admin role
  def get_users_for_collection_select
    @users = User.find_all_by_organization_id(current_user.organization, :order => :email)
  end

  def search
    @patients = Patient.search(params[:search], current_user)
  end
end
