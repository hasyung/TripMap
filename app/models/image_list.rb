class ImageList < ActiveRecord::Base

  has_many :images, :as => :imageable
  
  belongs_to :recommend_record
  
end
