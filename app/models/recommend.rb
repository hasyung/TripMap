class Recommend < ActiveRecord::Base

  attr_accessible :name, :slug
  
  # Associations
  has_one :cover,             :as => :imageable
  has_one :video,             :as => :videoable
  
  has_many :recommend_records, :dependent => :destroy
  
  belongs_to :map, :counter_cache => true  
  
end
