class Text < ActiveRecord::Base
  
	attr_accessible :textable_id, :textable_type, :body, :order
  
  # Associations
  belongs_to :textable, :polymorphic => true
  
end
