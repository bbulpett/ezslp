class Visit < ActiveRecord::Base
  belongs_to :patient_authorization
  has_one :patient, :through => :patient_authorization

  attr_accessible :visit_date, :patient_authorization_id, :visit_notes, :session_length, :therapist_name

#this scope will return only the visits associated with an active patient_authorization. I'm using this in the
#visits controller/index so we only display 'active' visits or a way to 'archive' visits
  scope :active_visits, :joins => :patient_authorization, :conditions => {"patient_authorizations.active" => true}

  def self.get_visits(current_user)
    if current_user.role == 'admin'
      Visit.find_all_by_patient_authorization_id(PatientAuthorization.find_all_by_patient_id(current_user.organization.patients))
    elsif current_user.role == 'super'
      Visit.all
    else
      Visit.find_all_by_patient_authorization_id(PatientAuthorization.find_all_by_patient_id((current_user.patients)))
    end
  end

  def self.search(from_date, to_date, current_user)
    current_user_visits = get_visits(current_user)
    Visit.find_all_by_id(current_user_visits, :conditions => [ "(visit_date  BETWEEN ? AND ?)", from_date, to_date])
  end

  validates :visit_date, :presence => true
  validates :visit_notes, :presence => true
  validate :validate_visit_date #this verifies a visit date is between the to and from dates of a patient authorization
  private
    def validate_visit_date
      self.errors.add(:visit_date, " is not within range for the active patient authorization. The
      current authorization dates for this patient are #{self.patient_authorization.from_date} to #{self.patient_authorization.to_date}") unless
      ((self.patient_authorization.from_date)..(self.patient_authorization.to_date)).include?(self.visit_date)
  end

end
