class Share < ActiveRecord::Base
	attr_accessible :map, :map_id, :ip, :title, :state_cd

	belongs_to :map, :counter_cache => true

	# Associations
	with_options :dependent => :destroy do |assoc|
	  assoc.has_one :share_image, :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.share_image }
	  assoc.has_one :share_text, :as => :textable, :class_name => 'Text', :conditions => { :text_type => Text.share_text }
	end
	
	#SimpleEnum
  as_enum :state, { :draft => 0, :publish => 1 }

	# Scopes
  scope :created_desc, order("created_at DESC")

  # Validates
  validates :title, :length => { :within => 0..20 }, :presence => true
  
end
