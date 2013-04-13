class ActivateMap < ActiveRecord::Base

  # White list
  attr_accessible :device_id

  # Associations
  has_many :logs,   :dependent => :destroy
  has_many :activate_with_accounts
  has_many :accounts, :through => :activate_with_accounts

  # Validates
  validates :device_id, presence: true, :uniqueness => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  
end