class PatientAuthorization < ActiveRecord::Base
  belongs_to :patient
  has_many :visits
  attr_accessible :to_date, :from_date, :patient_id, :initial_number_visits, :active, :short_term_goals,
                  :long_term_goals, :frequency_per_week, :session_length, :severity_level, :diagnosis
  delegate :patient_full_name, :to => :patient

  def current_number_visits
    self.initial_number_visits - visits.count
  end

  def name_with_visits
    "#{patient.first_name} #{patient.last_name} has #{current_number_visits} visits remaining"
  end

  def name_with_dates
    "#{patient.first_name} #{patient.last_name} #{self.from_date} to #{self.to_date}"
  end

  def self.get_authorizations(current_user)
    if current_user.role == 'admin'
      PatientAuthorization.find_all_by_patient_id(current_user.organization.patients)
    elsif current_user.role == 'super'
      PatientAuthorization.all
    else
      current_user.patient_authorizations
    end
  end

  validates_uniqueness_of :active, :scope => :patient_id, :message => ': Patient currently has an active authorization.'
  validates :initial_number_visits, :presence => true
  validates_numericality_of :initial_number_visits, :greater_than => 0
  validates :from_date, :presence => true
  validates :to_date, :presence => true
 #this verifies the from/to dates are correctly ordered and at least one day on length
  validate :validate_dates, :if => :to_date?, :if => :from_date
  private
    def validate_dates
      self.errors.add(:to_date, " must be after the from date, and must be at least one day in length") unless
      (self.from_date-self.to_date) < 0
  end
end
