class Audio < ActiveRecord::Base
  belongs_to :audioable, :polymorphic => true
end
