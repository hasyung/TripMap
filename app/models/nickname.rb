class Nickname < ActiveRecord::Base

  # White list
  attr_accessible :map_serial_number_id , :name

  # Associations
  belongs_to :map_serial_number
  has_many :shares, :dependent => :destroy

  # Validates
  validates :name, :presence => true, :length => { :within => 0..30 }

end