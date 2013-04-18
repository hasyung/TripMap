class Version < ActiveRecord::Base

  # White list
  attr_accessible :app, :description, :platform, :value

  # Associations
  # To do

  # Validates
  validates :platform,  :presence => true
  validates :value,     :presence => true, uniqueness: { scope: [:platform, :value] }

end