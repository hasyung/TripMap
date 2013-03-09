class Map < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :province_id, :name, :slug

  has_many  :scenics,     :dependent => :destroy 
  has_many  :places,      :dependent => :destroy
  has_many  :recommends,   :dependent => :destroy
  
  belongs_to :province, :counter_cache => true
end
