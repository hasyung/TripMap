class Image < ActiveRecord::Base
  attr_accessible :imageable_id, :imageable_type, :file, :file_type, :file_size, :order, :group_id, :group_order

  belongs_to :imageable, :polymorphic => true
  
end
