class Audio < ActiveRecord::Base

  # White list
  attr_accessible :file, :duration, :order

  # Associations
  belongs_to :audioable, :polymorphic => true

  # Validates
  validates :file, :duration, :presence => true

  validate :order_increment

  with_options :presence => true do |column|
    column.validates :file, :file_size => { :maximum => 5.megabytes.to_i, :message => I18n.t("errors.type.big_audio_file") }
    column.validates_numericality_of :duration, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999999
  end

  validates :order, uniqueness: { scope: [:audioable_id, :audioable_type, :audio_type] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :place_audio => 0,
  },
  :column => "audio_type"

  # Carrierwave.
  mount_uploader :file, AudioUploader

  # Callbacks
  before_save :update_audio_attributes

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  private

  def update_audio_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end

  def order_increment
    if self.new_record? && self.order == 0 && !self.audioable_id.nil?
      self.order = Audio.where( audioable_id: self.audioable_id, 
                                audioable_type: self.audioable_type, 
                                audio_type: self.audio_type ).maximum(:order).to_i + 1
    elsif self.audioable_id.nil?
      self.order = 1
    end
  end

end