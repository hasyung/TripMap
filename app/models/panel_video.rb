class PanelVideo < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :name, :video,
                  :panel_video_slug_attributes, :panel_video_slug_cover_attributes

  # Associations
  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_one :panel_video_slug,              :conditions => { :keyword_type => Keyword.panel_video_slug }
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :panel_video_slug_cover,       :conditions => { :image_type => Image.panel_video_slug_cover }
  end

  belongs_to :map

  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 1..20,    :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :map_id
    column.validates :video
  end

  # Carrierwave
  mount_uploader :video, VideoUploader do
    def store_dir
      "uploads/video"
    end
  end

  # Vlidates
  accepts_nested_attributes_for :panel_video_slug_cover, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :panel_video_slug,       :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

end