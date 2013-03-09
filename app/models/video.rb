class Video < ActiveRecord::Base
  attr_accessible :videoable_id, :videoable_type, :file, :file_type, :file_size, :cover, :cover_type, :cover_size, :order, :duration
  
  belongs_to :videoable, :polymorphic => true
end
