class Nickname < ActiveRecord::Base
  # attr_accessible
  attr_accessible :map_serial_number_id , :name

  belongs_to :map_serial_number
  has_many :shares, :dependent => :destroy


  validates :name, :presence => true, :length => { :within => 0..30 }
end
