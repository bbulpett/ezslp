class ChangeStringToTextInPatAuth < ActiveRecord::Migration
  def change
		   change_column :patient_authorizations, :short_term_goals, :text
		   change_column :patient_authorizations, :long_term_goals, :text
  end
end
