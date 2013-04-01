class Letter < ActiveRecord::Base
  
  self.table_name = 'texts'

  # White list
	attr_accessible :body, :order
  
  # Associations
  belongs_to :textable, :polymorphic => true
  
  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :map_description                => 0,
    
    :scenic_description             => 1,
    
    :place_description              => 2,
    
    :recommend_record_description   => 3,

    :share_text                     => 4
  },
  :column => "text_type"

  validates :order, uniqueness: { scope: [:textable_id, :textable_type, :text_type] }, 
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
end
