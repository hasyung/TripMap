class ImageList < ActiveRecord::Base
  
  # White list
	attr_accessible :name, :order

  # Associations
 	has_many :images, :as => :imageable, :dependent => :destroy
  
 	belongs_to :recommend_detailed

  validates_numericality_of :order, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 999
  validates :name, length: { within: 1..20 }, presence: true
  validates :order, uniqueness: { scope: :recommend_detailed_id }

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")
end
