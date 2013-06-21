class Audio < ActiveRecord::Base

  # White list
  attr_accessible :file, :duration, :order

  # Associations
  belongs_to :audioable, :polymorphic => true

  # Validates
  validates :file, :duration, :presence => true

  with_options :presence => true do |column|
    column.validates :file, :file_size => { :maximum => 8.megabytes.to_i, :message => I18n.t("errors.type.big_audio_file") }
    column.validates_numericality_of :duration, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999999
  end

  validates :order, uniqueness: { scope: [:audioable_id, :audioable_type, :audio_type] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :place_audio                    => 0,

    :broadcast_audio                => 1,

    :audio_list_item_audio          => 2,
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

end