class Map < ActiveRecord::Base

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
  accepts_nested_attributes_for :map_description, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true
  
  # Scopes
  scope :created_desc, order("created_at DESC")
  
  # Methods
  
  def get_map_values
    slides, places, scenics, recommends, records, detaileds, infos = [], [], [], [], [], [], []
    if self.map_slides.present?
      slides ||= []
      self.map_slides.order_asc.each do |slide|
        slides << { image: slide.file.url}
      end
    end
    if self.places_count > 0
      places ||= []
      self.places.each do |place|
        places << get_map_place_values(place)
      end
    end
    if self.scenics_count > 0
      scenics ||= []
      self.scenics.each do |scenic|
        scenics << get_map_scenic_values(scenic)
      end
    end
    if self.recommends_count > 0
      self.recommends.each do |recommend|
        recommends << get_map_recommend_values(recommend)
      end
    end
    if self.infos_count > 0
      self.infos.order_asc.each do |info|
        infos << {
                    name: info.name,
                    slug: info.slug,
                    description: get_file_value(info.letter,"body",false)
                  }
      end
    end
    {   
      cover: get_file_value(self.map_cover,"file",true),
      description: get_file_value(self.map_description,"body",false),
      slides: slides,
      scenics: scenics,
      places: places,
      recommends: recommends,
      infos: infos
    }
  end
  

  private
  
  def get_map_place_values place
    {
      id: place.id,
      name: place.name,
      subtitle: place.subtitle,
      slug: place.slug,
      icon: get_file_value(place.place_icon,"file",true),
      image: get_file_value(place.place_image,"file",true),
      audio: get_file_value(place.place_audio,"file",true),
      audio_size: get_file_value(place.place_audio,"file_size",false),
      audio_duration: get_file_value(place.place_audio,"duration",false),
      video: get_file_value(place.place_video,"file",true),
      video_size: get_file_value(place.place_video,"file_size",false),
      video_duration: get_file_value(place.place_video,"duration",false),
      description: get_file_value(place.place_description,"body",false)
    }
  end

  def get_map_scenic_values scenic
    {
      id: scenic.id,
      name: scenic.name,
      subtitle: scenic.subtitle,
      slug: scenic.slug,
      icon: get_file_value(scenic.scenic_icon,"file",true),
      image: get_file_value(scenic.scenic_image,"file",true),
      impression: get_file_value(scenic.scenic_impression,"file",true),
      impression_size: get_file_value(scenic.scenic_impression,"file_size",false),
      impression_duration: get_file_value(scenic.scenic_impression,"duration",false),
      route: get_file_value(scenic.scenic_route,"file",true),
      route_size: get_file_value(scenic.scenic_route,"file_size",false),
      route_duration: get_file_value(scenic.scenic_route,"duration",false),
      description: get_file_value(scenic.scenic_description,"body",false)
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
            detail += detailed.images if detailed.images.present?
            detail += detailed.videos if detailed.videos.present?
            detail += detailed.audios if detailed.audios.present?
            detail += detailed.texts if detailed.texts.present?
            detail += detailed.image_lists if detailed.image_lists.present?
            detail = detail.sort {|a,b| a[:order] <=> b[:order]}
            content = {:name => detailed.name}
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
                d.images.order_asc.each do |img|
                  imgs << {image: img.file.url}
                end
                image_lists << {images: imgs,  order: d.order}
              end
            end
            content.merge!({images: images}) 
            content.merge!({videos: videos})
            content.merge!({audios: audios})
            content.merge!({texts: texts})
            content.merge!({image_lists: image_lists}) if image_lists.present?
            detaileds << content
          end
        end
        records << {
                      name: record.name,
                      cover: get_file_value(record.recommend_record_cover,"file",true),
                      detaileds: detaileds
                    }
      end
    end
    { 
      name: recommend.name,
      slug: recommend.slug,
      video: get_file_value(recommend.recommend_video,"file",true),
      video_size: get_file_value(recommend.recommend_video,"file_size",false),
      video_duration: get_file_value(recommend.recommend_video,"duration",false),
      video_cover: get_file_value(recommend.recommend_video,"cover",true),
      cover: get_file_value(recommend.recommend_cover,"file",true),
      records: records
    }
  end

  def get_file_value(file, meth_name,url)
    if file.present?
      if url
        result = file.send(meth_name.to_sym).url
      else
        result = file.send(meth_name.to_sym)
      end
    else
      result= ""
    end
    result
  end
end
