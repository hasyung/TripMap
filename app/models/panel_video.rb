class PanelVideo < ActiveRecord::Base

  attr_accessor :slug
  # White list
  attr_accessible :map_id, :name, :video,
                  :slug, :panel_video_slug_cover_attributes

  # Associations
  belongs_to :map

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_many :panel_video_slugs,          :conditions => { :keyword_type => Keyword.panel_video_slugs }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :panel_video_slug_cover,   :conditions => { :image_type => Image.panel_video_slug_cover }
  end

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :map_id
    column.validates :video
  end

  # Nested attributes validates
  accepts_nested_attributes_for :panel_video_slug_cover, reject_if: ->(attr){ attr[:file].blank? }, :allow_destroy => true

  # Carrierwave
  mount_uploader :video, VideoUploader do
    def store_dir
      "uploads/video"
    end
  end

  # Scopes
  scope :created_desc, order("created_at DESC")

end