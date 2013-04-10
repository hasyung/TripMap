class Map < ActiveRecord::Base
 include SerialNumber::Generate

  #White list
  attr_accessible :province, :province_id, :name, :slug, :version,
                  :map_description_attributes, :map_cover_attributes, :map_plat_attributes

  # Associations
  with_options :dependent => :destroy do |assoc|
    assoc.has_many :scenics, :autosave => true
    assoc.has_many :places, :autosave => true
    assoc.has_many :recommends, :autosave => true
    assoc.has_many :shares, :autosave => true
    assoc.has_many :infos, :autosave => true
    assoc.has_many :logs
  end
  has_many :map_serial_numbers

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :map_cover,   :conditions => { :image_type => Image.map_cover   }
    assoc.has_one  :map_plat,    :conditions => { :image_type => Image.map_plat    }
    assoc.has_many :map_slides,  :conditions => { :image_type => Image.map_slides  }
  end

  has_one :map_description, :as => :textable, :class_name => 'Letter', 
          :conditions => { :text_type => Letter.map_description },
          :dependent => :destroy

  belongs_to :province, :counter_cache => true
  belongs_to :active_map

  # Validates
  with_options :presence => true do |column|
    column.validates :province_id
    column.validates :name, :length => { :within => 1..20,    :message => I18n.t("errors.type.name") }, :uniqueness => true
    column.validates :slug, :length => { :within => 1..20 },  :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }, :uniqueness => true
  end

  #validate :require_map_cover_attributes

  # NestedAttributes
  accepts_nested_attributes_for :map_cover, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_plat, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_description, :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

  # Methods

  def get_map_values
    {   
      cover:            get_file_value(self.map_cover,"file",true),
      description:      get_file_value(self.map_description,"body"),
      slides:           get_map_slides(),
      scenics:          get_scenics(),
      places:           get_places(),
      recommends:       get_recommends(),
      infos:            get_infos()
    }
  end

  private

  def get_map_slides()
    slides = []
    self.map_slides.order_asc.each{ |o| slides << { image: o.file.url} } if self.map_slides.present?
    slides
  end

  def get_places()
    places = []
    self.places.each{ |o| places << get_map_place_values(o) } if self.places_count > 0
    places
  end

  def get_scenics()
    scenics = []
    self.scenics.each{ |o| scenics << get_map_scenic_values(o) } if self.scenics_count > 0
    scenics
  end

  def get_recommends()
    recommends = []
    self.recommends.each{ |o| recommends << get_map_recommend_values(o) } if self.recommends_count > 0
    recommends
  end

  def get_infos()
    infos = []
    self.infos.order_asc.each{ |o| infos << { name: o.name, slug: o.slug, description: get_file_value(o.letter, "body")} }
    infos
  end

  def get_map_place_values place
    {
      id:               place.id,
      name:             place.name,
      subtitle:         place.subtitle,
      slug:             place.slug,
      icon:             get_file_value(place.place_icon, "file", true),
      image:            get_file_value(place.place_image, "file", true),
      audio:            get_file_value(place.place_audio, "file", true),
      audio_size:       get_file_value(place.place_audio, "file_size"),
      audio_duration:   get_file_value(place.place_audio, "duration"),
      video:            get_file_value(place.place_video, "file",true),
      video_size:       get_file_value(place.place_video, "file_size"),
      video_duration:   get_file_value(place.place_video, "duration"),
      description:      get_file_value(place.place_description, "body")
    }
  end

  def get_map_scenic_values scenic
    {
      id:               scenic.id,
      name:             scenic.name,
      subtitle:         scenic.subtitle,
      slug:             scenic.slug,
      icon:             get_file_value(scenic.scenic_icon, "file", true),
      image:            get_file_value(scenic.scenic_image, "file", true),
      impression:       get_file_value(scenic.scenic_impression, "file", true),
      impression_size:  get_file_value(scenic.scenic_impression, "file_size"),
      impression_duration: get_file_value(scenic.scenic_impression, "duration"),
      route:            get_file_value(scenic.scenic_route, "file", true),
      route_size:       get_file_value(scenic.scenic_route, "file_size"),
      route_duration:   get_file_value(scenic.scenic_route, "duration"),
      description:      get_file_value(scenic.scenic_description, "body")
    }
  end

  def get_map_recommend_values recommend
    records ||= []
    if recommend.recommend_records.present?
      recommend.recommend_records.order_asc.each do |record|
        detaileds ||= []
        if record.recommend_detaileds.present?
          record.recommend_detaileds.order_asc.each do |detailed|
            detail ||= []
            if recommend.category_cd == 1
              detail += detailed.videos if detailed.videos.present?
              detail += detailed.audios if detailed.audios.present?
              detail += detailed.image_lists if detailed.image_lists.present?
            end
            if recommend.category_cd != 3
              detail += detailed.detailed_images if detailed.detailed_images.present?
            end
            detail += detailed.texts if detailed.texts.present?
            detail = detail.sort {|a,b| a[:order] <=> b[:order]}
            content = { :name => detailed.name }
            images ||= []
            videos ||= []
            audios ||= []
            texts ||= []
            image_lists ||= []

            detail.each do |d|
              case d.class.to_s
              when "Image"
                images << {image: d.file.url,  order: d.order}
              when "Video"
                videos << {video: d.file.url,  size: d.file_size, duration: d.duration, cover: d.cover.url,  order: d.order}
              when "Audio"
                audios << {audio: d.file.url,  size: d.file_size, duration: d.duration,  order: d.order}
              when "Letter"
                 texts << {text: d.body, order: d.order}
              when "ImageList"
                imgs ||= []
                d.images.order_asc.each{ |o| imgs << { image: o.file.url }}
                image_lists << {images: imgs,  order: d.order}
              end
            end
            if recommend.category_cd != 3
              content.merge!({images: images}) 
            end
            if recommend.category_cd == 1
              content.merge!({videos: videos})
              content.merge!({audios: audios})
              content.merge!({image_lists: image_lists}) 
            end
            content.merge!({texts: texts})
            if recommend.category_cd == 2
              content.merge!({cover: get_file_value(detailed.recommend_detailed_cover,"file",true)})
            end
            detaileds << content
          end
        end
        records << { name: record.name, description: record.recommend_record_description.body, cover: get_file_value(record.recommend_record_cover,"file", true), detaileds: detaileds }
      end
    end

    {
      name: recommend.name,
      slug: recommend.slug,
      category: recommend.category_cd,
      video: get_file_value(recommend.recommend_video,"file",true),
      video_size: get_file_value(recommend.recommend_video,"file_size",false),
      video_duration: get_file_value(recommend.recommend_video,"duration",false),
      video_cover: get_file_value(recommend.recommend_video,"cover",true),
      cover: get_file_value(recommend.recommend_cover,"file",true),
      records: records
    }
  end

  def get_file_value( file, meth_name, url = false )
    if file.blank?
      return (meth_name == "file_size" || meth_name == "duration") ? 0 : ""
    end 

    result = url ? file.send(meth_name.to_sym).url : file.send(meth_name.to_sym)
  end

end