class Province < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :maps, :dependent => :destroy
end
