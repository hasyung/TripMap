class Account < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname

  # Associations
  has_many :shares,   :dependent => :destroy
  has_one :map_serial_number
  has_many :activate_with_accounts
  has_many :activate_maps, :through => :activate_with_accounts

  # Validates
  validates :nickname, :presence => true, :length => { :within => 1..30, :message => I18n.t("errors.type.name")  }, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :search_name, lambda { |name| where("ucase(`accounts`.`nickname`) like concat('%',ucase(?),'%')", name) }
end