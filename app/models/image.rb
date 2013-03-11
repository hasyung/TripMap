class Image < ActiveRecord::Base
  attr_accessible :file, :order, :group_id, :group_order
  
  belongs_to :imageable, :polymorphic => true
  
  as_enum :type, :cover => 0, :plat => 1, :slide => 2, :icon => 3, :column => "image_type"
  
end
