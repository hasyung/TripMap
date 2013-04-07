class Nickname < ActiveRecord::Base

  # White list
  attr_accessible :activate_map_id , :activate_map, :name

  # Associations
  belongs_to :activate_map
  has_many :shares, :dependent => :destroy

  # Validates
  validates :name, :presence => true, :length => { :within => 1..30, :message => I18n.t("errors.type.name")  }, :uniqueness => true
  validates :activate_map_id, :presence => true, :uniqueness => true

  # Scopes
  scope :created_desc, order("created_at DESC")
  scope :search_name, lambda { |name| where("ucase(`nicknames`.`name`) like concat('%',ucase(?),'%')", name) }

end