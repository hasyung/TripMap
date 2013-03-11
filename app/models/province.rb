class Province < ActiveRecord::Base
  attr_accessible :name, :slug
  
  # Associations
  has_many :maps, :dependent => :destroy
  
  # Validates
  validates :name, :slug, :presence => true
end

