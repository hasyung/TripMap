class Province < ActiveRecord::Base
  
  attr_accessible :name, :slug
  
  # Associations
  has_many :maps, :dependent => :destroy
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15 }
    column.validates :slug, :format => { :with => /([a-z]|[A-Z])+/ }
  end
  
end

