class Video < ActiveRecord::Base
  
  # Enumerable hash table, in growing.
  as_enum :type,
  {
    :scenic_impression      => 0,
    :scenic_route           => 1,
    
    :place_video            => 2,
    
    :recommend_video        => 3,
  },
  :column => "video_type"
  
  # White list
  attr_accessible :file, :file_type, :file_size, :cover,  :cover_type, :cover_size, :order, :duration, :video_type
  
  # Associations
  belongs_to :videoable, :polymorphic => true

  # Callbacks
  before_save :update_video_attributes, :update_video_cover_attributes
  
  # Validates
  validates :file, :cover, :duration, :presence => true
  
  with_options :if => :order? do |order|
    order.validates :order, :numericality => 
    {
      :only_integer => true,
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 999
    }
  end
  
  with_options :if => :duration do |duration|
    duration.validates :duration, :format =>
    {
      :with => /(?:[01]\d|2[0-3])(?::[0-5]\d){2}$/,
      :message => I18n.translate("errors.messages.format_invalid")
    }
  end
  
  with_options :if => :file? do |attachment|
    attachment.validates :file, :file_size => { :maximum => 100.megabytes.to_i }
  end
  
  with_options :if => :cover? do |cover|
    cover.validates :cover, :file_size => { :maximum => 10.megabytes.to_i }
  end

  # Carrierwave
  mount_uploader :file,   VideoUploader
  mount_uploader :cover,  ImageUploader

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("created_at DESC")
  
  def update_video_attributes
    if file.present? and file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end
  
  def update_video_cover_attributes
    if cover.present? and cover_changed?
      self.cover_size = cover.file.size
      self.cover_type = cover.file.content_type
    end
  end
  
end
