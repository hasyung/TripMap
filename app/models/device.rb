class Device < ActiveRecord::Base
   # White list
  attr_accessible :device_id, :created_at

  # Associations
  has_many :logs,   :dependent => :destroy
  has_and_belongs_to_many :map_serial_numbers

  # Validates
  validates :device_id, presence: true, :uniqueness => true

  # Scopes
  scope :created_desc, order("created_at DESC")
end
