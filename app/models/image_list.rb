class ImageList < ActiveRecord::Base
  
  # White list
	attr_accessible :name

  # Associations
 	has_many :images, :as => :imageable
  
 	belongs_to :recommend_record
  
end
