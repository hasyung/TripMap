class Text < ActiveRecord::Base
  
  attr_accessible :body, :order
  
  # Associations
  belongs_to :textable, :polymorphic => true
end
