class Nickname < ActiveRecord::Base
  # attr_accessible
  attr_accessible :map_serial_number_id , :nickname

  belongs_to :map_serial_number
  has_many :shares, :dependent => :destroy


  validates :nickname, :presence => true, :length => { :within => 0..30 }
end
