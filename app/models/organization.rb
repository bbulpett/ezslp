class Organization < ActiveRecord::Base
  has_many :events
  has_many :users
  has_many :patients, :through => :users

  # attr_accessible :name, :contact, :phone

  validates_uniqueness_of :name
  validates_presence_of :name
end
