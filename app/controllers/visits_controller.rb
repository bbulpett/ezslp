class VisitsController < ApplicationController
require 'will_paginate/array'
  before_filter :patients_for_collection_select, :only => [:new, :create, :edit]

#this index method is crazy code. It supports the visits link on the patient_authorizations index view, but we also need to
#ensure a user is authorized to view patient_authorizations/:id/visits. first if statement checks to see if route like 
#patient_authorizations/3/visits has been clicked. 2nd if statement then verifies the user has the right to view those visits,
#if they do then we display them, if not we flash "Unauthorized Page View"
  def index
    if params[:patient_authorization_id] #this makes the Vists link active; if this is false we drop down to line 14
      if @patient_authorization = PatientAuthorization.get_authorizations(current_user).select {|p| p.id.eql?(params[:patient_authorization_id].to_i) }.first #this checkes whether the user has access to the this visit ID
      @patient_authorization = PatientAuthorization.find(params[:patient_authorization_id])
      @patient_authorizations = PatientAuthorization.get_authorizations(current_user)
      @visits = @patient_authorization.visits.paginate(:page => params[:page], :per_page => 10)
      else
        flash[:notice] = "Unauthorized Page View"
        redirect_to visits_url
      end
    else
      @visits = Visit.active_visits.get_visits(current_user).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    if @visit = Visit.get_visits(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to visits_url
    end
  end

  def new
    @visit = if params[:patient_id].blank?
      @visit = Visit.new
    else
      patient = Patient.find params[:patient_id]
      patient_authorization = PatientAuthorization.find_by_patient_id(patient.id, :conditions => {:active => true})
      patient_authorization.visits.build
    end
   end

  def create
    @visit = Visit.new(params[:visit])
#add therapist_name in case a patient is assigned a new therapist, then the therapist that performs a visit does not change
    @visit.therapist_name = @visit.patient_authorization.patient.user.email
    if @visit.save
      #TODO when we edit a visit we need to also update it in the calendar
      #here we create and save an 'event' for the calendar
      @event = Event.new :name => @visit.patient_authorization.patient.patient_full_name, :start_at => @visit.visit_date,
                         :end_at => @visit.visit_date, :visit_id => @visit.id, :organization_id => current_user.organization.id
      @event.save
      redirect_to @visit, :notice => "Successfully created visit."
    else
      render :action => 'new'
    end
  end

  def edit
      #TODO when we edit a visit we need to also update it in the calendar
      if @visit = Visit.get_visits(current_user).select {|p| p.id.eql?(params[:id].to_i) }.first
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @patient }
      end
    else
      flash[:notice] = "Unauthorized Page View"
      redirect_to visits_url
    end
  end

  def update
    @visit = Visit.find(params[:id])
    if @visit.update_attributes(params[:visit])
      redirect_to @visit, :notice  => "Successfully updated visit."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @visit = Visit.find(params[:id])
    @event = Event.find_by_visit_id(params[:id]) #we also destroy the calendar event if we destroy the visit
    @visit.destroy
    @event.destroy
    redirect_to visits_url, :notice => "Successfully destroyed visit."
  end

  def patients_for_collection_select
    patient_ids = Patient.get_patients(current_user)
    @patients = PatientAuthorization.find(:all, :conditions => { :active => true, :patient_id => patient_ids })
  end

  def search_visits_by_date
    from_date = Date.new(params[:from_date][:year].to_i, params[:from_date][:month].to_i, params[:from_date][:day].to_i).to_s(:db)
    to_date = Date.new(params[:to_date][:year].to_i, params[:to_date][:month].to_i, params[:to_date][:day].to_i).to_s(:db)
    @visits = Visit.search(from_date, to_date, current_user)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = VisitPdf.new(@visits, from_date, to_date)
          send_data pdf.render
        end
      end
   end

  def search_visits_by_patient_authorization
    @visits = Visit.find_all_by_patient_authorization_id(params[:patient_authorization][:patient_authorization_id])
    respond_to do |format|
      format.html
      format.pdf do
          pdf = VisitByAuthPdf.new(@visits)
          send_data pdf.render
        end
    end
  end
end
