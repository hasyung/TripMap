class Image < ActiveRecord::Base

  # White list
  attr_accessible  :file, :file_size, :order

  # Associations
  belongs_to :imageable, :polymorphic => true

  # Validates
  validates :file, :imageable_type, :image_type, :presence => true
  validates :file, :file_size => { :maximum => 5.megabytes.to_i, :message => I18n.t("errors.type.big_image_file") }
  validate :order_increment
  validates :order, uniqueness: { scope: [:imageable_id, :imageable_type, :image_type] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }

  # SampleEnum. hash table is in growing.
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

    :recommend_record_cover     => 10,

    :share_image                => 11,
    :recommend_detailed_cover   => 12,
    :detailed_images            => 13,

    :place_slides               => 14,
    :scenic_slides              => 15,

    :map_weather_bg_image       => 16,

    :merchant_slides            => 17,

    :scenic_slug_icon           => 18,
    :place_slug_icon            => 19,
    :recommend_slug_icon        => 20,
    :infolist_slug_icon         => 21,
  },
  :column => "image_type"

  # Carrierwave
  mount_uploader :file, ImageUploader

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  # Callbacks
  before_save :update_image_attributes

  # Methods
  private
  def update_image_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
      self.file_type = file.file.content_type
    end
  end

  def order_increment
    if self.new_record? && self.order == 0 && !self.imageable_id.nil?
      self.order = Image.where( imageable_id: self.imageable_id, 
                                imageable_type: self.imageable_type, 
                                image_type: self.image_type ).maximum(:order).to_i + 1
    elsif self.imageable_id.nil?
      self.order = 1
    end
  end

end