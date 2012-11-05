class CreatePatientAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :patient_authorizations do |t|
      t.date :to_date
      t.date :from_date
      t.integer :patient_id
      t.integer :initial_number_visits
      t.string :long_term_goals
      t.string :short_term_goals
      t.string :frequency_per_week
      t.string :session_length
      t.string :severity_level
      t.string :diagnosis
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_authorizations
  end
end
