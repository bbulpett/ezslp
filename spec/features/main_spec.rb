require "spec_helper"

describe "new user registration with patient and visit creation" do
  it "allows users to sign in after they have registered" do
    visit "/register"
    fill_in "user_organization_attributes_name",    :with => "UNCA"
    fill_in "Email (This will be your login ID)",    :with => "admin@unca.edu"
    fill_in "user_password", :with => "test"
    fill_in "user_password_confirmation", :with => "test"

    click_button "Submit"
    page.should have_content("Welcome! You have signed up successfully")
    page.should have_content("admin@unca.edu")

    visit "/visits"
    page.should have_content("New Visit")

    visit "/patient_authorizations"
    page.should have_content("Re-Authorize a Patient")

    visit "/patients"
    page.should have_content("New Patient")

    visit "/dashboard"
    page.should have_content("New User")

    visit "/calendar"
    page.should have_content("Calendar")

    visit "/patients/new"
    fill_in "patient_first_name", :with => "Mista"
    fill_in "patient_middle_name", :with => "Cornmelious"
    fill_in "patient_last_name", :with => "Busta"
    fill_in "patient_address_1", :with => "2774 Wintas Road"
    fill_in "patient_address_2", :with => "Apartment B"
    fill_in "patient_city", :with => "Maxton"
    fill_in "patient_state", :with => "NC"
    fill_in "patient_zip", :with => "37488"
    fill_in "patient_phone", :with => "281-992-1122"
    fill_in "patient_patient_authorizations_attributes_0_from_date", :with => "2012-01-01"
    fill_in "patient_patient_authorizations_attributes_0_to_date", :with => "2012-03-03"
    fill_in "patient_patient_authorizations_attributes_0_initial_number_visits", :with => "8"
    fill_in "patient_patient_authorizations_attributes_0_short_term_goals", :with => "short term goal text"
    fill_in "patient_patient_authorizations_attributes_0_long_term_goals", :with => "long term goals"
    fill_in "patient_patient_authorizations_attributes_0_frequency_per_week", :with => "3"
    fill_in "patient_patient_authorizations_attributes_0_session_length", :with => "55"
    select 'Moderate', :from => 'patient_patient_authorizations_attributes_0_severity_level'
    select 'Receptive Language', :from => 'patient_patient_authorizations_attributes_0_diagnosis'
    click_button "Create Patient"
    page.should have_content("Successfully created patient.")

    visit "/patients/1"
    page.should have_content("Mista")
    page.should have_content("Cornmelious")
    page.should have_content("Busta")
    page.should have_content("2774 Wintas Road")
    page.should have_content("Apartment B")
    page.should have_content("Maxton")
    page.should have_content("NC")
    page.should have_content("37488")
    page.should have_content("281-992-1122")

    visit "/patient_authorizations/1"
    page.should have_content("To Date: 2012-03-03")
    page.should have_content("From Date: 2012-01-01 ")
    page.should have_content("Mista Busta")
    page.should have_content("Initial Number Visits: 8")
    page.should have_content("Short term goals: short term goal text")
    page.should have_content("Long term goals: long term goals")
    page.should have_content("Number of Visits per Week (Frequency): 3")
    page.should have_content("Session Length: 55")
    page.should have_content("Severity Level: Moderate")
    page.should have_content("Diagnosis: Receptive Language")
    
    visit "/patient_authorizations" 
    page.should have_content("Mista Busta")
    page.should have_content("admin@unca.edu 8 8")
    page.should have_content("2012-01-01 2012-03-03 Mista Busta admin@unca.edu 8 8")
    
    visit "/visits/new" 
    page.should have_content("admin@unca.edu")
    fill_in "visit_visit_date", :with => "2012-02-01"
    fill_in "visit_session_length", :with => "47"
    fill_in "visit_visit_notes", :with => "good test of visit notes"
    click_button "Create Visit"
    page.should have_content("Successfully created visit.")

    visit "/visits/1"
    page.should have_content("Visit Date: 2012-02-01")
    page.should have_content("Therapist: admin@unca.edu ")
    page.should have_content("Patient: Mista Busta")
    page.should have_content("Visit Notes: good test of visit notes")

    visit "/visits"
    page.should have_content("admin@unca.edu ")
    page.should have_content("Mista Busta")
    page.should have_content("47")

#after we create a visit, we revisit the pat auth page and verify the number of remaining visits has gone down by 1
    visit "/patient_authorizations" 
    page.should have_content("Mista Busta")
    page.should have_content("admin@unca.edu 8 7")

    visit "/dashboard"
    page.should have_content("admin@unca.edu")
    visit "/user/new"
    fill_in "user_email", :with => "my_buddy@unca.edu"
    fill_in "user_password", :with => "test9721"
    fill_in "user_password_confirmation", :with => "test9721"
    click_button "Submit"
    page.should have_content("Successfully created User.")
    page.should have_content("my_buddy@unca.edu")
    click_link "Sign out"

#create a second user to verify proper visit filtering on visit searches
    visit "/register"
    fill_in "user_organization_attributes_name",    :with => "AB Tech"
    fill_in "Email (This will be your login ID)",    :with => "admin@abtech.edu"
    fill_in "user_password", :with => "test"
    fill_in "user_password_confirmation", :with => "test"

    click_button "Submit"
    page.should have_content("Welcome! You have signed up successfully")
    page.should have_content("admin@abtech.edu")
2012-03-03
    visit "/patients/new"
    fill_in "patient_first_name", :with => "Thomas"
    fill_in "patient_middle_name", :with => "Ray"
    fill_in "patient_last_name", :with => "Magnum"
    fill_in "patient_address_1", :with => "24 Wykiki Road"
    fill_in "patient_address_2", :with => "Apartment B"
    fill_in "patient_city", :with => "Big Island"
    fill_in "patient_state", :with => "HA"
    fill_in "patient_zip", :with => "37488"
    fill_in "patient_phone", :with => "281-992-1122"
    fill_in "patient_patient_authorizations_attributes_0_from_date", :with => "2012-01-01"
    fill_in "patient_patient_authorizations_attributes_0_to_date", :with => "2012-03-03"
    fill_in "patient_patient_authorizations_attributes_0_initial_number_visits", :with => "8"
    fill_in "patient_patient_authorizations_attributes_0_short_term_goals", :with => "short term goal text"
    fill_in "patient_patient_authorizations_attributes_0_long_term_goals", :with => "long term goals"
    fill_in "patient_patient_authorizations_attributes_0_frequency_per_week", :with => "3"
    fill_in "patient_patient_authorizations_attributes_0_session_length", :with => "55"
    select 'Moderate', :from => 'patient_patient_authorizations_attributes_0_severity_level'
    select 'Receptive Language', :from => 'patient_patient_authorizations_attributes_0_diagnosis'
    click_button "Create Patient"
    page.should have_content("Successfully created patient.")
    visit "/visits/new" 
    fill_in "visit_visit_date", :with => "2012-02-01"
    fill_in "visit_session_length", :with => "47"
    fill_in "visit_visit_notes", :with => "another good test of visit notes"
    click_button "Create Visit"
    page.should have_content("Successfully created visit.")

    click_link "Sign out"
#end creation of 2nd user/org

#test visit search pages
    visit "/login"
    fill_in "Email", :with => "admin@unca.edu"
    fill_in "Password", :with => "test"
    click_button "Sign in"
    visit "/searchs"
    page.should have_content("Enter the dates to print")
    page.should have_content("Choose Patient Authorization/Contract Period")

#test search by pat auth
    page.select 'Mista Busta 2012-01-01 to 2012-03-03', :from => 'patient_authorization_patient_authorization_id'
    click_button "search_by_pat_auth"
    page.should have_content("Your search returned 1 visits")
    page.should have_content("Visit Date: 2012-02-01")
    page.should have_content("User: admin@unca.edu")
    page.should have_content("Patient: Mista Busta")
    page.should have_content("Visit Notes: good test of visit notes")
#TODO test search by date
=begin
		visit "/searchs"
		page.select 'January', :from => 'from_date_month'
		page.select '1', :from => 'from_date_day'
		page.select '2012', :from => 'from_date_year'
		page.select 'March', :from => 'from_date_month'
		page.select '1', :from => 'from_date_day'
		page.select '2012', :from => 'from_date_year'
    click_button "Search by Date"
		page.should have_content("Your search returned 1 visits")
    page.should have_content("Visit Date: 2012-02-01")
    page.should have_content("User: admin@unca.edu")
    page.should have_content("Patient: Mista Busta")
    page.should have_content("Visit Notes: good test of visit notes")
=end
#Test search box
    fill_in "search_field",  :with => "Busta"
    click_button "Search Patients"
    page.should have_content("Your search returned 1 patients")
  end
end
