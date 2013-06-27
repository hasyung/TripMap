require 'app/common'

class Map < ActiveRecord::Base
  include SerialNumber::Generate
  include App::Model

  attr_accessor :slug
  
  #White list
  attr_accessible :province, :province_id, :name, :slug, :version,
                  :map_description_attributes, :map_cover_attributes, :map_plat_attributes, :map_weather_bg_image_attributes

  # Associations
  belongs_to :province, :counter_cache => true
  belongs_to :active_map

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :scenics, :autosave => true
    assoc.has_many :places, :autosave => true
    assoc.has_many :recommends, :autosave => true
    assoc.has_many :shares, :autosave => true
    assoc.has_many :info_lists, :autosave => true
    assoc.has_many :logs
    assoc.has_many :surround_cities
    assoc.has_many :panel_videos
    assoc.has_many :broadcasts
    assoc.has_many :specials
    assoc.has_many :audio_list_categories
    assoc.has_many :first_knowns
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :map_cover,            :conditions => { :image_type => Image.map_cover   }
    assoc.has_one  :map_plat,             :conditions => { :image_type => Image.map_plat    }
    assoc.has_one  :map_weather_bg_image, :conditions => { :image_type => Image.map_weather_bg_image }
    assoc.has_many :map_slides,           :conditions => { :image_type => Image.map_slides  }
  end

  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do |assoc|
    assoc.has_one :map_description,       :conditions => { :text_type => Letter.map_description }
  end

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_many :map_slugs,              :conditions => { :keyword_type => Keyword.map_slugs }
  end

  has_many :map_serial_numbers

  # Validates
  with_options :presence => true do |column|
    column.validates :province_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :map_cover,            reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_plat,             reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_weather_bg_image, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_description,      :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

   # Callbacks
  after_destroy :after_destroy

  # Methods

  def get_map_values
    {
      cover:                  get_file_value(self.map_cover,"file",true),
      description:            get_file_value(self.map_description,"body"),
      slides:                 get_map_slides(),
      scenics:                get_scenics(),
      places:                 get_places(),
      recommends:             get_recommends(),
      info_lists:             get_info_lists(),
      panel_videos:           get_panel_videos(),
      broadcasts:             get_broadcasts(),
      specials:               get_specials(),
      audio_list_categories:  get_audio_list_categories(),
      first_known:            get_first_known()
    }
  end
  
  private

  def after_destroy
    Rails.cache.delete("map_#{self.id}")
  end

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

  def get_info_lists()
    ret = []
    self.info_lists.order_asc.each do |info_list|
      r = {
        info_list_slug:       get_file_value(info_list.info_list_slug, "slug"),
        info_list_is_free:    info_list.is_free.to_s,
        slug_icon:            get_file_value(info_list.infolist_slug_icon, "file", true),
      }
      tmp_infos = []
      info_list.infos.order_asc.each do |o|
        tmp_infos << { name: o.name, slug: get_file_value( o.info_slug, "slug"), is_free: o.is_free.to_s, description: get_file_value(o.letter, "body")}
      end
      r["infos"] = tmp_infos
      ret << r
    end
    ret
  end

  def get_map_place_values place
    {
      id:                     place.id,
      name:                   place.name,
      is_free:                place.is_free.to_s,
      menu_type:              place.menu_type,
      subtitle:               place.subtitle,
      slug:                   get_file_value(place.place_slug, "slug"),
      icon:                   get_file_value(place.place_icon, "file", true),
      slug_icon:              get_file_value(place.place_slug_icon, "file", true),
      image:                  get_file_value(place.place_image, "file", true),
      audio:                  get_file_value(place.place_audio, "file", true),
      audio_size:             get_file_value(place.place_audio, "file_size"),
      audio_duration:         get_file_value(place.place_audio, "duration"),
      video:                  get_file_value(place.place_video, "file",true),
      video_size:             get_file_value(place.place_video, "file_size"),
      video_duration:         get_file_value(place.place_video, "duration"),
      description:            get_file_value(place.place_description, "body"),
      slides:                 get_place_slides(place)
    }
  end

  def get_place_slides place
    slides = []
    place.place_slides.order_asc.each{ |o| slides << { image: o.file.url} } if place.place_slides.present?
    slides
  end

  def get_map_scenic_values scenic
    {
      id:                     scenic.id,
      name:                   scenic.name,
      is_free:                scenic.is_free.to_s,
      menu_type:              scenic.menu_type,
      subtitle:               scenic.subtitle,
      slug:                   get_file_value( scenic.scenic_slug, "slug"),
      icon:                   get_file_value(scenic.scenic_icon, "file", true),
      slug_icon:              get_file_value(scenic.scenic_slug_icon, "file", true),
      image:                  get_file_value(scenic.scenic_image, "file", true),
      impression:             get_file_value(scenic.scenic_impression, "file", true),
      impression_size:        get_file_value(scenic.scenic_impression, "file_size"),
      impression_duration:    get_file_value(scenic.scenic_impression, "duration"),
      route:                  get_file_value(scenic.scenic_route, "file", true),
      route_size:             get_file_value(scenic.scenic_route, "file_size"),
      route_duration:         get_file_value(scenic.scenic_route, "duration"),
      description:            get_file_value(scenic.scenic_description, "body"),
      slides:                 get_scenic_slides(scenic)
    }
  end

  def get_scenic_slides scenic
    slides = []
    scenic.scenic_slides.order_asc.each{ |o| slides << { image: o.file.url} } if scenic.scenic_slides.present?
    slides
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
            detail += detailed.detailed_texts if detailed.detailed_texts.present?
            detail += detailed.detailed_infos if detailed.detailed_infos.present?
            detail = detail.sort {|a,b| a[:order] <=> b[:order]}
            content = { :name => detailed.name }
            images ||= []
            videos ||= []
            audios ||= []
            texts  ||= []
            infos ||= []
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
                if d.text_type == 5
                  infos << {url: d.body, order: d.order}
                else
                  texts << {text: d.body, order: d.order}
                end
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
            content.merge!({infos: infos})
            if recommend.category_cd == 2
              content.merge!({cover: get_file_value(detailed.recommend_detailed_cover,"file",true)})
            end
            detaileds << content
          end
        end
        records << { name: record.name, description: get_file_value(record.recommend_record_description,"body", false), cover: get_file_value(record.recommend_record_cover,"file", true), detaileds: detaileds }
      end
    end

    {
      name:                   recommend.name,
      slug:                   get_file_value(recommend.recommend_slug, "slug"),
      is_free:                recommend.is_free.to_s,
      menu_type:              recommend.menu_type,
      category:               recommend.category_cd,
      slug_icon:              get_file_value(recommend.recommend_slug_icon, "file", true),
      video:                  get_file_value(recommend.recommend_video,"file",true),
      video_size:             get_file_value(recommend.recommend_video,"file_size",false),
      video_duration:         get_file_value(recommend.recommend_video,"duration",false),
      video_cover:            get_file_value(recommend.recommend_video,"cover",true),
      cover:                  get_file_value(recommend.recommend_cover,"file",true),
      records:                records
    }
  end

  def get_panel_videos
    ret = []
    self.panel_videos.each{|c| ret << o_to_h(c, ['map_id', 'version']) }
    ret
  end

  def get_broadcasts
    ret = []
    self.broadcasts.each do|c|
      h_c = o_to_h(c, ['map_id', 'version'])
      l_cc = []
      c.children_broadcasts.order_asc.each{|cc| l_cc << o_to_h(cc, ['broadcast_id']) }
      h_c[:children_broadcasts] = l_cc
      ret << h_c
    end
    ret
  end

  def get_specials
    specials ||= []

    self.specials.each do |s|
      minorities ||= []
      s.minorities.order_asc.each do |m|
        slides, feels = [], []
        m.minority_slides.order_asc.each do |ms|
          slides << {
            image:       get_file_value(ms.minority_slide_icon, "file", true),
            description: get_file_value(ms.minority_slide_description,"body")
          }
        end
        m.minority_feels.order_asc.each do |mf|
          sl ||= []
          mf.minority_feel_slides.order_asc.each{ |o| sl << { image: o.file.url} }
          feels << {
            name:        mf.name,
            image:       get_file_value(mf.minority_feel_icon, "file", true),
            description: get_file_value(mf.minority_feel_description,"body"),
            slides:      sl
          }
        end
        minorities << {
          name:           m.name,
          slug:           get_file_value(m.minority_slug, "slug"),
          slug_icon:      get_file_value(m.minority_slug_icon, "file", true),
          is_free:        m.is_free.to_s,
          menu_type:      m.menu_type,
          image:          get_file_value(m.minority_icon, "file", true),
          video:          get_file_value(m.minority_video, "file", true),
          video_size:     get_file_value(m.minority_video,"file_size"),
          video_duration: get_file_value(m.minority_video,"duration"),
          video_cover:    get_file_value(m.minority_video,"cover",true),
          description:    get_file_value(m.minority_description,"body"),
          slides:         slides,
          feels:          feels
        }
      end
      specials << { 
        name:             s.name, 
        slug:             get_file_value(s.special_slug, "slug"),
        slug_icon:        get_file_value(s.special_slug_icon, "file", true),
        is_free:          s.is_free.to_s,
        menu_type:        s.menu_type,
        image:            get_file_value(s.special_icon, "file", true),
        minorities:       minorities
      }
    end
    specials
  end

  def get_audio_list_categories
    ret = []
    self.audio_list_categories.each do|c|
      h_c = o_to_h(c, ['map_id', 'version'])
      l_cc = []
      c.audio_lists.order_asc.each do |cc|
        h_cc = o_to_h(cc, ['audio_list_category_id'])
        l_ccc = []
        cc.audio_list_items.order_asc.each{|ccc| l_ccc << o_to_h(ccc, ['audio_list_id']) }
        h_cc[:audio_list_items] = l_ccc
        l_cc << h_cc
      end
      h_c[:audio_lists] = l_cc
      ret << h_c
    end
    ret
  end

  def get_first_known
    ret = []
    self.first_knowns.each do|c|
      h_c = o_to_h(c, ['map_id', 'version'])
      l_cc = []
      c.first_known_lists.order_asc.each do |cc|
        h_cc = o_to_h(cc, ['first_known_id'])
        l_ccc = []
        cc.first_known_list_items.order_asc.each{|ccc| l_ccc << o_to_h(ccc, ['first_known_list_id']) }
        h_cc[:first_known_list_items] = l_ccc
        l_cc << h_cc
      end
      h_c[:first_known_lists] = l_cc
      ret << h_c
    end
    ret
  end

  def get_file_value( file, field, url = false )
    is_file_blank = file.blank? || file.send(field.to_sym).blank?
    is_zero_type = ( field == "file_size" || field == "duration" )

    ( return is_zero_type ? 0 : "" ) if is_file_blank

    result = url ? file.send(field.to_sym).url : file.send(field.to_sym)
  end

end