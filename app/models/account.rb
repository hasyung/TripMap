class Account < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :map_serial_number_attributes

  # Associations
  has_many :shares,   :dependent => :destroy
  has_many :feedbacks, :dependent => :destroy
  has_one :map_serial_number
  has_many :activate_with_accounts
  has_many :activate_maps, :through => :activate_with_accounts

  # Validates
  validates_presence_of :nickname, :email, :password, :password_confirmation
  validates :nickname, :length => { :within => 1..30, :message => I18n.t("errors.type.name")  }, :uniqueness => true
  validates :email, :uniqueness => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :search_name, lambda { |name| where("ucase(`accounts`.`nickname`) like concat('%',ucase(?),'%')", name) }

  # NestedAttributes
  accepts_nested_attributes_for :map_serial_number,              reject_if: lambda { |i| i[:code].blank? }
end