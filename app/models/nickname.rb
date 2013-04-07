class Nickname < ActiveRecord::Base

  # White list
  attr_accessible :map_serial_number_id , :map_serial_number, :name

  # Associations
  belongs_to :map_serial_number
  has_many :shares, :dependent => :destroy

  # Validates
  validates :name, :presence => true, :length => { :within => 1..30, :message => I18n.t("errors.type.name")  }, :uniqueness => true
  validates :map_serial_number_id, :presence => true, :uniqueness => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end