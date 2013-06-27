class Keyword < ActiveRecord::Base

  # White list
  attr_accessible  :slug

  # Associations
  belongs_to :keywordable, :polymorphic => true

  # Validates
  validates :slug, :presence=> true, :length => { :within => 1..20 }, :format => { :with => /^[a-z]+$/, :message => I18n.t("errors.type.slug") }, :uniqueness => true

  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :map_slugs                  => 0,

    :scenic_slugs               => 1,

    :place_slugs                => 2,

    :recommend_slugs            => 3,

    :info_list_slugs            => 4,
    :info_slugs                 => 5,

    :merchant_slugs             => 6,

    :panel_video_slugs          => 7,

    :special_slugs              => 8,

    :minority_slugs             => 9,

    :broadcast_slugs            => 10,

    :audio_list_category_slugs  => 11,

    :first_known_slugs          => 12,

    :fight_slugs                => 13,
  },
  :column => "keyword_type"

  def self.get_slug(all_slug)
    all_slug.map(&:slug).join(";")
  end

end