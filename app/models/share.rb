class Share < ActiveRecord::Base
	attr_accessible :map, :map_id, :nickname, :title, :state_cd, :share_text_attributes, :share_image_attributes

	belongs_to :map, :counter_cache => true

    # Carrierwave
    mount_uploader :file, ImageUploader

    # Callbacks
    before_save :update_image_attributes
    
	# Associations
	with_options :dependent => :destroy do |assoc|
	  assoc.has_one :share_image, :as => :imageable, :class_name => 'Image', :conditions => { :image_type => Image.share_image }
	  assoc.has_one :share_text, :as => :textable, :class_name => 'Letter', :conditions => { :text_type => Letter.share_text }
	end
	
	#SimpleEnum
  as_enum :state, { :draft => 0, :publish => 1 }

  # NestedAttributes
  accepts_nested_attributes_for :share_image, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :share_text, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true
  
	# Scopes
  scope :created_desc, order("created_at DESC")

  # Validates
  with_options :presence=> true do |column|
    column.validates :map_id
    column.validates :title, :length => { :within => 1..20,    :message => I18n.t("errors.type.name") }
    column.validates :nickname, :length => { :within => 0..30 }
  end
  
  # Methods
  private
  
  def update_image_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end

end
