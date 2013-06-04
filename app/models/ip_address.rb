class IpAddress < ActiveRecord::Base

  # White list
  attr_accessible :ip, :counter

  # Validates
  validates :ip, :presence => true

end