class VisitObserver  < ActiveRecord::Observer
  def after_create(visit)
		@patient = visit.patient
    @current_authorization = @patient.current_authorization #we get this from the patient model
    deactivate_authorization if no_more_visits_remaining
  end

  private
  def no_more_visits_remaining
    @current_authorization.current_number_visits.zero? #we get this from patient_authorization model
  end

  def deactivate_authorization
    @current_authorization.update_attribute :active, false
  end
end
