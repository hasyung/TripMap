class Province < ActiveRecord::Base
  attr_accessible :name, :slug
  
  has_many :maps, :dependent => :destroy
end
