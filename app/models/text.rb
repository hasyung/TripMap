class Text < ActiveRecord::Base
  
  # Enumerable hash table, in growing.
  as_enum :type,
  {
    :map_description                => 0,
    
    :scenic_description             => 1,
    
    :place_description              => 2,
    
    :recommend_record_description   => 3,

    :share_text           => 4
  },
  :column => "text_type"
  
  # White list
	attr_accessible :body, :order
  
  # Associations
  belongs_to :textable, :polymorphic => true
  
end
