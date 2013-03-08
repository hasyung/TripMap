class Text < ActiveRecord::Base
  belongs_to :textable, :polymorphic => true
end
