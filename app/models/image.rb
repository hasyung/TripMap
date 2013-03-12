class Image < ActiveRecord::Base
  
  # Enumerable hash table, in growing.
  as_enum :type,
  {
    :map_cover                  => 0,
    :map_plat                   => 1,
    :map_slides                 => 2,
    
    :scenic_icon                => 3,
    :scenic_description_image   => 4,
    :scenic_image               => 5,
    
    :place_icon                 => 6,
    :place_description_image    => 7,
    :place_image                => 8,
    
    :recommend_cover            => 9,
    
    :recommend_record_cover      => 10,
  },
  :column => "image_type"
  
  # White list
  attr_accessible  :file, :file_size, :order, :group_id, :group_order
  
  # Associations
  belongs_to :imageable, :polymorphic => true
  
  # SimpleEnum
  as_enum :type, :cover => 0, :plat => 1, :slide => 2, :icon => 3, :column => "image_type"
  
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

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  # Carrierwave
  mount_uploader :file, ImageUploader

  # Callbacks
  before_save :update_image_attributes

  # Methods
  def update_image_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end
  
end
