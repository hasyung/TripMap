class Audio < ActiveRecord::Base
  
  # Enumerable hash table, in growing.
  as_enum :type,
  {
    :place_audio => 0,

  },
  :column => "audio_type"
  
  # White list
  attr_accessible :file, :duration, :order
  
  # Associations
  belongs_to :audioable, :polymorphic => true
  
  # Validates
  validates :file, :duration, :presence => true
  
  
  # with_options :if => :name? do |name|
  #   name.validates :name, :length => { :within => 2..15 }
  # end
  
  with_options :if => :order? do |order|
    order.validates :order, :numericality =>
    {
      :only_integer => true,
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 999
    }
  end
  
  # with_options :if => :duration do |duration|
  #   duration.validates :duration, :format =>
  #   {
  #     :with => /(?:[01]\d|2[0-3])(?::[0-5]\d){2}$/, 
  #     :message => I18n.translate("errors.messages.format_invalid")
  #   }
  # end
  
  with_options :if => :file? do |attachment|
    attachment.validates :file, :file_size => { :maximum => 10.megabytes.to_i }
  end
  
  # Carrierwave
  mount_uploader :file, AudioUploader
  
  # Callbacks
  before_save :update_audio_attributes
  
  def update_audio_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end

end
