class Keyword < ActiveRecord::Base

  # White list
  attr_accessible  :slug

  # Associations
  belongs_to :keywordable, :polymorphic => true

  # Validates
  validates :slug, :presence=> true, :length => { :within => 1..20 },  :format => { :with => /^[a-z]+$/, :message => I18n.t("errors.type.slug") }, :uniqueness => true

  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :map_slug                   => 0,

    :scenic_slug                => 1,

    :place_slug                 => 2,

    :recommend_slug             => 3,

    :info_list_slug             => 4,
    :info_slug                  => 5,

    :merchant_slug              => 6,

    :panel_video_slug           => 7,

    :special_slug               => 8,

    :minority_slug              => 9,

    :broadcast_slug             => 10,

    :audio_list_category_slug   => 11,
  },
  :column => "keyword_type"

end