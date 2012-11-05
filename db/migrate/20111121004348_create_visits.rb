class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.date :visit_date
      t.integer :patient_authorization_id
      t.integer :session_length
      t.text :visit_notes
      t.string :therapist_name #adding this to capture the theripist name who actually performs visit
      t.timestamps
    end
  end

  def self.down
    drop_table :visits
  end
end
