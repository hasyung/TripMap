class ImageList < ActiveRecord::Base
	attr_accessible :name

 	has_many :images, :as => :imageable
  
 	belongs_to :recommend_record
  
end
