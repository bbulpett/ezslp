class SearchsController < ApplicationController
  def index
    @patient_authorizations = PatientAuthorization.get_authorizations(current_user)
  end
end
