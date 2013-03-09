class Map < ActiveRecord::Base
  
  attr_accessible :province_id, :name, :slug

  # Associations
  has_many  :scenics,     :dependent => :destroy
  has_many  :places,      :dependent => :destroy
  has_many  :recommend,   :dependent => :destroy
  
  has_one   :cover,       :as => :imageable
  has_one   :plat,        :as => :imageable
  has_many  :images,      :as => :imageable
  has_one   :desciption,  :as => :textable
  
  belongs_to :province, :counter_cache => true
  
  # Validates
  validates :name, :presence => true
  
end
