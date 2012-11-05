#when moding data for users must change user_id (2 places), data names prefix (3 places) and ther_id and site_id ranges

namespace :db do
	desc "populate random data for testing"
	task :create_data => :environment do
		require 'populator'
		require 'faker'
		#NOTE These deletions may not work on heroku. You will need to reset/load db for primary key ids to reset
		#[Therapist, PatientAuthorization, Patient, Visit].each(&:delete_all)

		#user 1 and org 1
		Patient.populate 5 do |patient|
      patient.user_id = 1
      patient.first_name = 'ez' + Populator.words(1).titleize
      patient.middle_name = Populator.words(1).titleize
      patient.last_name = Populator.words(1).titleize
      patient.contact = Populator.words(2).titleize
      patient.medicaid_number = Populator.value_in_range(111111111..999999999)
      patient.address_1 = Faker::Address.street_address
      patient.address_2 = ['', 'Apartment 2', 'Box 8', 'Apt. 302']
      patient.city = Faker::Address.city
      patient.state = Faker::Address.state_abbr
      patient.zip = Populator.value_in_range(27773..89223)
      patient.phone = Faker::PhoneNumber.phone_number
      patient.dob = 80.years.ago..5.years.ago
	    patient.created_at = 2.years.ago..Time.now
			PatientAuthorization.populate 1 do |pat_auth|
        pat_auth.patient_id = patient.id
        pat_auth.from_date = 2.years.ago..Time.now
        pat_auth.to_date = pat_auth.from_date..Time.now
        pat_auth.initial_number_visits = Populator.value_in_range(10..30)
        pat_auth.active = true
				Visit.populate pat_auth.initial_number_visits - 1 do |visit|
          visit.patient_authorization_id = pat_auth.id
          visit.visit_date = pat_auth.from_date..pat_auth.to_date
          visit.visit_notes = Populator.sentences(5..10)
          u = User.first
          visit.therapist_name = u.email
          visit.created_at = visit.visit_date
          visit.session_length = Populator.value_in_range(30..60)
          Event.create :name => patient.first_name, :start_at => visit.visit_date, 
                    :end_at => visit.visit_date, :visit_id => visit.id, :organization_id => 1
				end
			end
		end
	end
end
