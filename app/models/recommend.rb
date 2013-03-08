class Recommend < ActiveRecord::Base
  has_one :cover,             :as => :imageable
  has_one :video,             :as => :videoable
  
  has_many :recommend_records, :dependent => :destroy
  
  belongs_to :map, counter_cache => true
end
