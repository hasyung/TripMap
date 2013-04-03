class IpAddress < ActiveRecord::Base
  attr_accessible :ip, :counter

  validates :ip, :presence => true
end
