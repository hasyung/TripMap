class Video < ActiveRecord::Base
  attr_accessible :file, :cover, :order
  
  belongs_to :videoable, :polymorphic => true
  
  as_enum :type, :route => 0, :impression => 1, :column => "video_type"
end
