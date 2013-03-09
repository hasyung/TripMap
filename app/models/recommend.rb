class Recommend < ActiveRecord::Base
	attr_accessible :name, :slug
 	has_many :images,             :as => :imageable
 	has_many :videos,             :as => :videoable
  
 	has_many :recommend_records, :dependent => :destroy
  
 	belongs_to :map, :counter_cache => true
end
