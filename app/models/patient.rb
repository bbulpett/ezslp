class Patient < ActiveRecord::Base
  belongs_to :user
  has_many :patient_authorizations
  accepts_nested_attributes_for :patient_authorizations
  has_one :current_authorization, :class_name => 'PatientAuthorization',
                                  :conditions => { :active => true }


  attr_accessible :first_name, :last_name, :middle_name, :address_1, :address_2, :city, :state, :zip, :phone, :dob, :medicaid_number, :contact, :user_id, :patient_authorizations_attributes

  def patient_full_name
    "#{first_name} #{last_name}"
  end

#In this method we find all patient authorizations for the patient that are active, and return the current_number_visits
#Or if there are not active patient authorizations, then we return 'No active authorizations'
  def show_remaining_visits(patient)
    @pat_auth = PatientAuthorization.find_by_patient_id(patient, :conditions => {:active => true})
    if @pat_auth != nil
      @pat_auth.current_number_visits
    else
      'No Active Authorizations'
    end
  end


 #Calling this from the controller for multi-tenancy
  def self.get_patients(current_user)
    if current_user.role == 'admin'
      current_user.organization.patients
    elsif current_user.role == 'super'
      Patient.all
    else
      current_user.patients
    end
  end

  def self.search(search_param, current_user)
    search_condition = "%" + search_param.downcase + "%"
    current_user_patients = get_patients(current_user)
    find_all_by_id(current_user_patients, :conditions => ['lower(first_name) LIKE ? OR lower(last_name) LIKE ?', search_condition, search_condition])
  end

  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
