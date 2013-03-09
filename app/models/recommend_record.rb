class RecommendRecord < ActiveRecord::Base
  
  has_one :cover, :as => :imageable
  has_one :description, :as => :textable
  
  has_many :videos, :as => :videoable
  has_many :audios, :as => :audioable
  has_many :images, :as => :imageable
  has_many :texts,  :as => :textable
  
  belongs_to :recommend, :counter_cache => true
end
