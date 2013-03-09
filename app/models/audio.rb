class Audio < ActiveRecord::Base
	attr_accessible :audioable_id, :audioable_type, :file, :file_type,:file_size, :order, :duration
  belongs_to :audioable, :polymorphic => true
end
