class SurroundCity < ActiveRecord::Base

  # White list
  attr_accessible :map, :map_id, :city_name

  # Associations
  belongs_to :map

  # Validates
  validates :city_name, :map_id, :presence => true
  validates :city_name, :uniqueness => true

end