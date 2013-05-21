class Keyword < ActiveRecord::Base
  # White list
  attr_accessible  :slug

  # Associations
  belongs_to :keywordable, :polymorphic => true

  validates :slug, :presence=> true, :length => { :within => 1..20 },  :format => { :with => /^[a-z]+$/, :message => I18n.t("errors.type.slug") }, :uniqueness => true

  # SampleEnum. hash table is in growing.
  as_enum :type,
  {
    :map_slug                  => 0,
    :scenic_slug                   => 1,
    :place_slug                 => 2,
    :recommend_slug                => 3,
    :info_list_slug   => 4,
    :info_slug               => 5,
    :merchant_slug                 => 6
  },
  :column => "keyword_type"
end
