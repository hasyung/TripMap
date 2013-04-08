class ActivateMap < ActiveRecord::Base

  # White list
  attr_accessible :device_id, :map, :map_id, :map_serial_number_id

  # Associations
  has_many :logs,   :dependent => :destroy
  has_one :nickname, :dependent => :destroy
  has_many :maps
  belongs_to :map_serial_number

  # Validates
  validates :device_id, :map_id, :map_serial_number_id, presence: true

  # Scopes
  scope :created_desc, order("created_at DESC")
  
end