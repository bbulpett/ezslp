# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111206145644) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.integer  "visit_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "patient_authorizations", :force => true do |t|
    t.date     "to_date"
    t.date     "from_date"
    t.integer  "patient_id"
    t.integer  "initial_number_visits"
    t.string   "long_term_goals"
    t.string   "short_term_goals"
    t.string   "frequency_per_week"
    t.string   "session_length"
    t.string   "severity_level"
    t.string   "diagnosis"
    t.boolean  "active",                :default => true
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "phone"
    t.date     "dob"
    t.string   "medicaid_number"
    t.string   "contact"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",      :null => false
    t.string   "encrypted_password",     :default => "",      :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "organization_id"
    t.string   "role",                   :default => "admin"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :force => true do |t|
    t.date     "visit_date"
    t.integer  "patient_authorization_id"
    t.integer  "session_length"
    t.text     "visit_notes"
    t.string   "therapist_name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
