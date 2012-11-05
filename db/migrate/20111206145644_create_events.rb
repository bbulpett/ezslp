class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.integer :organization_id
      t.integer :visit_id
      t.datetime :start_at
      t.datetime :end_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
