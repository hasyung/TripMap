class ActivateMap < ActiveRecord::Base
  attr_accessible :device_id, :map, :map_id, :map_serial_number_id

  has_many :logs,   :dependent => :destroy

  validates :device_id, :map_id, :map_serial_number_id, presence: true

end
