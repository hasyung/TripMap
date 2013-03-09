class Image < ActiveRecord::Base
  
  attr_accessible :imageable_id, :imageable_type, :file, :file_type, :file_size, :order, :group_id, :group_order

  # Associations
  belongs_to :imageable, :polymorphic => true
  
  # Validates
  validates :file, :presence => true
  
  with_options :if => :order? do |order|
    order.validates :order, :numericality =>
    {
      :only_integer => true,
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 999
    }
  end
  
  with_options :if => :file? do |image|
    image.validates :file, :file_size => { :maximum => 5.megabytes.to_i }
  end

  # scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("created_at DESC")

  # Carrierwave
  mount_uploader :file, MapUploader

  # Callbacks
  before_save :update_image_attributes

  # Methods
  def update_image_attributes
    Rails.logger.debug file.file.basename
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end
    
end
