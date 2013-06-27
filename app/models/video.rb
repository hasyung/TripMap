class Video < ActiveRecord::Base

  # White list
  attr_accessible :file, :file_type, :file_size, :cover,  :cover_type, :cover_size, :order, :duration, :video_type

  # Associations
  belongs_to :videoable, :polymorphic => true

  # Callbacks
  before_save :update_video_attributes, :update_video_cover_attributes

  # Validates
  validates :file, :file_size => { :maximum => 40.megabytes.to_i, :message => I18n.t("errors.type.big_video_file") }
  validates :cover, :presence => true, :file_size => { :maximum => 10.megabytes.to_i, :message => I18n.t("errors.type.big_image_file") }
  validates_numericality_of :duration, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999999

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 },
                    uniqueness: { scope: [:videoable_id, :videoable_type, :video_type] }
   validates_with OrderValidator

  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :scenic_impression      => 0,
    :scenic_route           => 1,

    :place_video            => 2,

    :recommend_video        => 3,

    :minority_video         => 4,

    :merchant_video         => 5,

    :fight_video            => 6,

    :first_known_video      => 7,
  },
  :column => "video_type"

  # Carrierwave
  mount_uploader :file,  VideoUploader
  mount_uploader :cover, ImageUploader

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  # Methods
  private

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