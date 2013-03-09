class Video < ActiveRecord::Base

  attr_accessible :videoable_id, :videoable_type, :file, :file_type, :file_size, :cover, :cover_type, :cover_size, :order, :duration

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
    cover.validates :cover, :cover_size => { :maximum => 10.megabytes.to_i }
  end

  # Carrierwave
  mount_uploader :file, VideoUploader
  mount_uploader :cover, VideoCoverUploader

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("created_at DESC")
  
  def update_video_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end
  
  def update_video_cover_attributes
    if cover.present? && cover_changed?
      self.cover_size = cover.file.size
      self.cover_type = cover.file.content_type
    end
  end

end
